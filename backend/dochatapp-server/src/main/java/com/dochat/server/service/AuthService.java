package com.dochat.server.service;

import com.dochat.server.dto.AuthResponse;
import com.dochat.server.model.User;
import com.dochat.server.repository.UserRepository;
import com.dochat.server.security.JwtUtil;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.time.Duration;
import java.util.Base64;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final Gson GSON = new Gson();
    private static final String SMS_PREFIX = "sms:";
    private static final String LOGIN_ATTEMPT_PREFIX = "login_attempt:";
    private static final String TOKEN_BLACKLIST_PREFIX = "token_blacklist:";

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final SmsService smsService;
    private final StringRedisTemplate redisTemplate;

    @Value("${tencent.im.sdk-app-id:1600148063}")
    private long imSdkAppId;

    @Value("${tencent.im.secret-key:PLACEHOLDER_TENCENT_IM_SECRET_KEY}")
    private String imSecretKey;

    @Value("${tencent.im.expire-time:604800}")
    private long imExpireTime;

    public AuthService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder,
                       JwtUtil jwtUtil,
                       SmsService smsService,
                       StringRedisTemplate redisTemplate) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
        this.smsService = smsService;
        this.redisTemplate = redisTemplate;
    }

    public Map<String, Object> sendSms(String phone, String type) {
        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        String key = SMS_PREFIX + phone + ":" + type;
        redisTemplate.opsForValue().set(key, code, Duration.ofSeconds(300));
        smsService.sendSms(phone, code);
        log.debug("SMS code for {} (type={}): {}", phone, type, code);
        return Map.of("expireIn", 300, "retryAfter", 60);
    }

    public AuthResponse register(String phone, String smsCode, String password) {
        String key = SMS_PREFIX + phone + ":register";
        String storedCode = redisTemplate.opsForValue().get(key);
        if (storedCode == null || !storedCode.equals(smsCode)) {
            throw new RuntimeException("验证码错误或已过期");
        }
        if (userRepository.existsByPhone(phone)) {
            throw new RuntimeException("该手机号已注册");
        }

        redisTemplate.delete(key);

        User user = new User();
        user.setUserId("u_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16));
        user.setPhone(phone);
        user.setPassword(passwordEncoder.encode(password));
        user.setNickname("用户" + phone.substring(phone.length() - 4));
        user = userRepository.save(user);

        String token = jwtUtil.generateToken(user.getUserId());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUserId());
        String userSig = generateUserSig(user.getUserId());

        cacheToken(user.getUserId(), token);

        return new AuthResponse(user.getUserId(), token, refreshToken, userSig, 86400L);
    }

    public AuthResponse login(String phone, String password) {
        checkLoginLock(phone);

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("手机号未注册"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            incrementLoginAttempt(phone);
            throw new RuntimeException("密码错误");
        }

        if ("locked".equals(user.getStatus()) || "banned".equals(user.getStatus())) {
            throw new RuntimeException("账号已被锁定或封禁");
        }

        clearLoginAttempt(phone);

        String token = jwtUtil.generateToken(user.getUserId());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUserId());
        String userSig = generateUserSig(user.getUserId());

        cacheToken(user.getUserId(), token);

        return new AuthResponse(user.getUserId(), token, refreshToken, userSig, 86400L);
    }

    public AuthResponse loginBySms(String phone, String smsCode) {
        String key = SMS_PREFIX + phone + ":login";
        String storedCode = redisTemplate.opsForValue().get(key);
        if (storedCode == null || !storedCode.equals(smsCode)) {
            throw new RuntimeException("验证码错误或已过期");
        }

        redisTemplate.delete(key);

        User user = userRepository.findByPhone(phone).orElseGet(() -> {
            User newUser = new User();
            newUser.setUserId("u_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16));
            newUser.setPhone(phone);
            newUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
            newUser.setNickname("用户" + phone.substring(phone.length() - 4));
            return userRepository.save(newUser);
        });

        if ("locked".equals(user.getStatus()) || "banned".equals(user.getStatus())) {
            throw new RuntimeException("账号已被锁定或封禁");
        }

        String token = jwtUtil.generateToken(user.getUserId());
        String refreshToken = jwtUtil.generateRefreshToken(user.getUserId());
        String userSig = generateUserSig(user.getUserId());

        cacheToken(user.getUserId(), token);

        return new AuthResponse(user.getUserId(), token, refreshToken, userSig, 86400L);
    }

    public AuthResponse refreshToken(String refreshTokenStr) {
        if (!jwtUtil.validateToken(refreshTokenStr)) {
            throw new RuntimeException("RefreshToken无效或已过期");
        }
        String userId = jwtUtil.getUserIdFromToken(refreshTokenStr);

        String newToken = jwtUtil.generateToken(userId);
        String newRefreshToken = jwtUtil.generateRefreshToken(userId);
        String userSig = generateUserSig(userId);

        cacheToken(userId, newToken);

        return new AuthResponse(userId, newToken, newRefreshToken, userSig, 86400L);
    }

    public void logout(String userId) {
        Optional.ofNullable(redisTemplate.opsForValue().get("token:" + userId))
                .ifPresent(token -> {
                    redisTemplate.delete("token:" + userId);
                    redisTemplate.opsForValue().set(TOKEN_BLACKLIST_PREFIX + token, "1", Duration.ofHours(24));
                });
    }

    public void changePassword(String userId, String oldPassword, String newPassword) {
        User user = userRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("用户不存在"));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("旧密码错误");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        redisTemplate.delete("token:" + userId);
    }

    public void resetPassword(String phone, String smsCode, String newPassword) {
        String key = SMS_PREFIX + phone + ":reset";
        String storedCode = redisTemplate.opsForValue().get(key);
        if (storedCode == null || !storedCode.equals(smsCode)) {
            throw new RuntimeException("验证码错误或已过期");
        }

        redisTemplate.delete(key);

        User user = userRepository.findByPhone(phone)
                .orElseThrow(() -> new RuntimeException("手机号未注册"));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        redisTemplate.delete("token:" + user.getUserId());
    }

    private String generateUserSig(String userId) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(imSecretKey.getBytes(), "HmacSHA256");
            mac.init(secretKeySpec);

            long expire = System.currentTimeMillis() / 1000 + imExpireTime;
            String payload = userId + ":" + imSdkAppId + ":" + expire;
            byte[] hash = mac.doFinal(payload.getBytes());

            String sig = Base64.getEncoder().encodeToString(hash);
            Map<String, Object> sigData = Map.of(
                    "sdkAppId", imSdkAppId,
                    "userId", userId,
                    "expire", expire,
                    "sig", sig
            );
            return Base64.getEncoder().encodeToString(GSON.toJson(sigData).getBytes());
        } catch (Exception e) {
            log.error("Failed to generate UserSig", e);
            return "MOCK_USER_SIG_" + userId;
        }
    }

    private void cacheToken(String userId, String token) {
        redisTemplate.opsForValue().set("token:" + userId, token, Duration.ofHours(24));
    }

    private void checkLoginLock(String phone) {
        String attempts = redisTemplate.opsForValue().get(LOGIN_ATTEMPT_PREFIX + phone);
        if (attempts != null && Integer.parseInt(attempts) >= 5) {
            throw new RuntimeException("登录尝试次数过多，请30分钟后再试");
        }
    }

    private void incrementLoginAttempt(String phone) {
        String key = LOGIN_ATTEMPT_PREFIX + phone;
        redisTemplate.opsForValue().increment(key);
        redisTemplate.expire(key, 30, TimeUnit.MINUTES);
    }

    private void clearLoginAttempt(String phone) {
        redisTemplate.delete(LOGIN_ATTEMPT_PREFIX + phone);
    }
}
