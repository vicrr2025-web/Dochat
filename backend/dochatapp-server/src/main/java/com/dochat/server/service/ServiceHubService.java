package com.dochat.server.service;

import com.dochat.server.dto.BadgeResponse;
import com.dochat.server.dto.BadgeUpdateRequest;
import com.dochat.server.dto.BadgeResponse.EcosystemInfo;
import com.dochat.server.model.EcosystemBadge;
import com.dochat.server.repository.EcosystemBadgeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ServiceHubService {

    private static final Logger log = LoggerFactory.getLogger(ServiceHubService.class);

    private static final Map<String, EcosystemInfo> ECOSYSTEM_MAP = new LinkedHashMap<>();

    static {
        ECOSYSTEM_MAP.put("guarantee",     new EcosystemInfo("担保",   "hand_thumbsup",          "/services/guarantee"));
        ECOSYSTEM_MAP.put("mall",          new EcosystemInfo("商城",   "bag",                    "/services/mall"));
        ECOSYSTEM_MAP.put("dating",        new EcosystemInfo("婚恋",   "heart",                  "/services/dating"));
        ECOSYSTEM_MAP.put("housing",       new EcosystemInfo("找房",   "house",                  "/services/housing"));
        ECOSYSTEM_MAP.put("recruit",       new EcosystemInfo("直聘",   "briefcase",              "/services/recruit"));
        ECOSYSTEM_MAP.put("emailService",         new EcosystemInfo("邮箱",   "envelope",               "/services/email"));
        ECOSYSTEM_MAP.put("shipping",      new EcosystemInfo("速运",   "shippingbox",            "/services/shipping"));
        ECOSYSTEM_MAP.put("homeService",   new EcosystemInfo("到家",   "house_circle",           "/services/homeService"));
    }

    private final EcosystemBadgeRepository ecosystemBadgeRepository;

    public ServiceHubService(EcosystemBadgeRepository ecosystemBadgeRepository) {
        this.ecosystemBadgeRepository = ecosystemBadgeRepository;
    }

    public List<BadgeResponse> getBadges(String userId) {
        List<EcosystemBadge> badges = ecosystemBadgeRepository.findByUserId(userId);
        Map<String, Integer> badgeCountMap = badges.stream()
                .collect(Collectors.toMap(EcosystemBadge::getEcosystemKey, EcosystemBadge::getBadgeCount));

        List<BadgeResponse> result = new ArrayList<>();
        for (Map.Entry<String, EcosystemInfo> entry : ECOSYSTEM_MAP.entrySet()) {
            String key = entry.getKey();
            EcosystemInfo info = entry.getValue();
            BadgeResponse resp = new BadgeResponse();
            resp.setEcosystemKey(key);
            resp.setEcosystemName(info.name);
            resp.setIconName(info.iconName);
            resp.setRoute(info.route);
            resp.setBadgeCount(badgeCountMap.getOrDefault(key, 0));
            result.add(resp);
        }
        return result;
    }


    public BadgeResponse updateBadge(String userId, BadgeUpdateRequest request) {
        EcosystemBadge badge = ecosystemBadgeRepository
                .findByUserIdAndEcosystemKey(userId, request.getEcosystemKey())
                .orElseGet(() -> {
                    EcosystemBadge newBadge = new EcosystemBadge();
                    newBadge.setUserId(userId);
                    newBadge.setEcosystemKey(request.getEcosystemKey());
                    newBadge.setBadgeCount(0);
                    return newBadge;
                });

        int newCount = badge.getBadgeCount() + request.getDelta();
        if (newCount < 0) newCount = 0;
        badge.setBadgeCount(newCount);
        ecosystemBadgeRepository.save(badge);

        BadgeResponse resp = new BadgeResponse();
        resp.setEcosystemKey(badge.getEcosystemKey());
        EcosystemInfo info = ECOSYSTEM_MAP.get(badge.getEcosystemKey());
        resp.setEcosystemName(info != null ? info.name : badge.getEcosystemKey());
        resp.setIconName(info != null ? info.iconName : "questionmark");
        resp.setRoute(info != null ? info.route : "");
        resp.setBadgeCount(newCount);
        return resp;
    }
}
