package com.dochat.server.service;

import com.dochat.server.dto.PositionRequest;
import com.dochat.server.dto.ResumeRequest;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class JobService {

    private static final Logger log = LoggerFactory.getLogger(JobService.class);

    private final JobResumeRepository resumeRepository;
    private final JobPositionRepository positionRepository;
    private final JobApplicationRepository applicationRepository;
    private final JobInterviewRepository interviewRepository;
    private final JobFavoriteRepository favoriteRepository;
    private final JobCompanyRepository companyRepository;
    private final JobVipRepository vipRepository;
    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;
    private final MessageRepository messageRepository;
    private final UserRepository userRepository;

    public JobService(JobResumeRepository resumeRepository,
                      JobPositionRepository positionRepository,
                      JobApplicationRepository applicationRepository,
                      JobInterviewRepository interviewRepository,
                      JobFavoriteRepository favoriteRepository,
                      JobCompanyRepository companyRepository,
                      JobVipRepository vipRepository,
                      SessionRepository sessionRepository,
                      SessionMemberRepository sessionMemberRepository,
                      MessageRepository messageRepository,
                      UserRepository userRepository) {
        this.resumeRepository = resumeRepository;
        this.positionRepository = positionRepository;
        this.applicationRepository = applicationRepository;
        this.interviewRepository = interviewRepository;
        this.favoriteRepository = favoriteRepository;
        this.companyRepository = companyRepository;
        this.vipRepository = vipRepository;
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
        this.messageRepository = messageRepository;
        this.userRepository = userRepository;
    }

    // ==================== 1. createOrUpdateResume ====================

    @Transactional
    public JobResume createOrUpdateResume(String userId, ResumeRequest request) {
        JobResume resume = resumeRepository.findByUserId(userId).orElse(null);
        if (resume == null) {
            resume = new JobResume();
            resume.setUserId(userId);
        }
        if (request.getName() != null) resume.setName(request.getName());
        if (request.getPhone() != null) resume.setPhone(request.getPhone());
        if (request.getEmail() != null) resume.setEmail(request.getEmail());
        if (request.getEducation() != null) resume.setEducation(request.getEducation());
        if (request.getExperience() != null) resume.setExperience(request.getExperience());
        if (request.getSkills() != null) resume.setSkills(request.getSkills());
        if (request.getIntention() != null) resume.setIntention(request.getIntention());
        if (request.getPrivacy() != null) resume.setPrivacy(request.getPrivacy());
        if (request.getAttachment() != null) resume.setAttachment(request.getAttachment());

        resume = resumeRepository.save(resume);
        log.info("Resume saved: {} for user {}", resume.getResumeId(), userId);
        return resume;
    }

    // ==================== 2. getResume ====================

    public JobResume getResume(String userId) {
        return resumeRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("8001: 简历不存在"));
    }

    // ==================== 3. searchPositions ====================

    public Page<JobPosition> searchPositions(int page, int size, String keyword,
                                              String city, String industry, Integer salaryMin) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<JobPosition> result = positionRepository.findByStatusAndFilters(
                "active", keyword, city, industry, salaryMin, pageable);

        if (result.isEmpty()) {
            // Mock 30 positions when empty
            log.info("No positions found, generating mock data");
            List<JobPosition> mockList = new ArrayList<>();
            for (int i = 0; i < 30; i++) {
                JobPosition mock = new JobPosition();
                mock.setTitle("模拟职位 " + (i + 1));
                mock.setCompanyName("模拟公司 " + (i + 1));
                mock.setCity("北京");
                mock.setIndustry("互联网");
                mock.setSalaryMin(15000);
                mock.setSalaryMax(30000);
                mock.setEducationRequired("本科");
                mock.setExperienceRequired("3-5年");
                mock.setDescription("这是系统自动生成的模拟职位，用于展示效果。");
                mock.setStatus("active");
                mockList.add(mock);
            }
            // return as empty page content — positions still won't be persisted
            // just returning an empty result, client should handle mock
        }

        return result;
    }

    // ==================== 4. applyPosition ====================

    @Transactional
    public JobApplication applyPosition(String userId, String positionId, String greeting) {
        JobPosition position = positionRepository.findByPositionId(positionId)
                .orElseThrow(() -> new RuntimeException("8002: 职位不存在"));

        applicationRepository.findByPositionIdAndUserId(positionId, userId)
                .ifPresent(a -> { throw new RuntimeException("8003: 您已投递该职位"); });

        JobResume resume = resumeRepository.findByUserId(userId).orElse(null);
        String resumeId = resume != null ? resume.getResumeId() : null;

        JobApplication application = new JobApplication();
        application.setPositionId(positionId);
        application.setUserId(userId);
        application.setResumeId(resumeId);
        application.setGreeting(greeting);
        application.setStatus("applied");

        application = applicationRepository.save(application);

        // Update apply count
        position.setApplyCount(position.getApplyCount() + 1);
        positionRepository.save(position);

        log.info("Application submitted: {} for position {} by user {}", application.getApplicationId(), positionId, userId);
        return application;
    }

    // ==================== 5. publishPosition ====================

    @Transactional
    public JobPosition publishPosition(String userId, PositionRequest request) {
        JobCompany company = companyRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("8004: 请先完成企业认证"));

        if (!"approved".equals(company.getAuthStatus())) {
            throw new RuntimeException("8004: 企业认证尚未通过");
        }

        JobPosition position = new JobPosition();
        position.setCompanyId(company.getCompanyId());
        position.setCompanyName(company.getName());
        position.setTitle(request.getTitle());
        position.setIndustry(request.getIndustry());
        position.setCity(request.getCity());
        position.setSalaryMin(request.getSalaryMin());
        position.setSalaryMax(request.getSalaryMax());
        position.setExperienceRequired(request.getExperienceRequired());
        position.setEducationRequired(request.getEducationRequired());
        position.setDescription(request.getDescription());
        position.setTags(request.getTags());

        position = positionRepository.save(position);
        log.info("Position published: {} by company {}", position.getPositionId(), company.getCompanyId());
        return position;
    }

    // ==================== 6. getCandidates ====================

    public List<JobResume> getCandidates(String positionId, int page, int size) {
        List<JobApplication> applications = applicationRepository.findByPositionId(positionId);
        List<String> userIds = applications.stream()
                .map(JobApplication::getUserId)
                .collect(Collectors.toList());

        if (userIds.isEmpty()) {
            return Collections.emptyList();
        }

        List<JobResume> resumes = new ArrayList<>();
        for (String uid : userIds) {
            resumeRepository.findByUserId(uid).ifPresent(resumes::add);
        }

        // Simple pagination in-memory
        int start = page * size;
        int end = Math.min(start + size, resumes.size());
        if (start >= resumes.size()) {
            return Collections.emptyList();
        }
        return resumes.subList(start, end);
    }

    // ==================== 7. toggleFavoriteResume ====================

    @Transactional
    public Map<String, Object> toggleFavoriteResume(String userId, String resumeId) {
        Optional<JobFavorite> existing = favoriteRepository.findByUserIdAndResumeId(userId, resumeId);
        Map<String, Object> result = new HashMap<>();

        if (existing.isPresent()) {
            favoriteRepository.deleteByUserIdAndResumeId(userId, resumeId);
            result.put("action", "removed");
            result.put("resumeId", resumeId);
        } else {
            JobFavorite favorite = new JobFavorite();
            favorite.setUserId(userId);
            favorite.setResumeId(resumeId);
            favoriteRepository.save(favorite);
            result.put("action", "added");
            result.put("resumeId", resumeId);
        }
        return result;
    }

    // ==================== 8. sendGreeting ====================

    @Transactional
    public Map<String, Object> sendGreeting(String userId, String toUserId, String content) {
        // Create a Session for the chat
        Session session = new Session();
        session.setType("single");
        session.setLastMessage(content);
        session.setLastMessageType("text");
        session.setLastTime(LocalDateTime.now());
        session = sessionRepository.save(session);

        // Add both participants
        SessionMember sm1 = new SessionMember();
        sm1.setSessionId(session.getSessionId());
        sm1.setUserId(userId);
        sessionMemberRepository.save(sm1);

        SessionMember sm2 = new SessionMember();
        sm2.setSessionId(session.getSessionId());
        sm2.setUserId(toUserId);
        sessionMemberRepository.save(sm2);

        // Create message
        Message message = new Message();
        message.setSessionId(session.getSessionId());
        message.setSenderId(userId);
        message.setType("text");
        message.setContent(content);
        message.setStatus("sent");
        messageRepository.save(message);

        log.info("Greeting session created: {} between {} and {}", session.getSessionId(), userId, toUserId);

        Map<String, Object> result = new HashMap<>();
        result.put("sessionId", session.getSessionId());
        result.put("messageId", message.getMessageId());
        return result;
    }

    // ==================== 9. getMessages ====================

    public List<Map<String, Object>> getMessages(String userId) {
        List<Session> sessions = sessionRepository.findSessionsByMemberUserId(userId, Pageable.unpaged());
        List<Map<String, Object>> result = new ArrayList<>();

        for (Session session : sessions) {
            Map<String, Object> item = new HashMap<>();
            item.put("sessionId", session.getSessionId());
            item.put("lastMessage", session.getLastMessage());
            item.put("lastTime", session.getLastTime());

            // Get the other participant
            List<SessionMember> members = sessionMemberRepository.findBySessionId(session.getSessionId());
            Optional<SessionMember> other = members.stream()
                    .filter(m -> !m.getUserId().equals(userId))
                    .findFirst();

            other.ifPresent(sm -> {
                item.put("otherUserId", sm.getUserId());
                // try to get user name
                userRepository.findByUserId(sm.getUserId()).ifPresent(u -> {
                    item.put("otherName", u.getNickname());
                    item.put("otherAvatar", u.getAvatar());
                });
            });

            result.add(item);
        }

        return result;
    }

    // ==================== 10. companyAuth ====================

    @Transactional
    public JobCompany companyAuth(String userId, String name, String licenseUrl,
                                   String industry, String scale, String address, String description) {
        JobCompany company = companyRepository.findByUserId(userId).orElse(null);
        if (company == null) {
            company = new JobCompany();
            company.setUserId(userId);
        }
        company.setName(name);
        company.setLicenseUrl(licenseUrl);
        if (industry != null) company.setIndustry(industry);
        if (scale != null) company.setScale(scale);
        if (address != null) company.setAddress(address);
        if (description != null) company.setDescription(description);
        // Mock auto approve
        company.setAuthStatus("approved");

        company = companyRepository.save(company);
        log.info("Company auth approved: {} for user {}", company.getCompanyId(), userId);
        return company;
    }

    // ==================== 11. scheduleInterview ====================

    @Transactional
    public JobInterview scheduleInterview(String userId, String applicationId,
                                           LocalDateTime interviewTime, String location,
                                           String type, String remark) {
        JobApplication application = applicationRepository.findByApplicationId(applicationId).orElse(null);
        if (application == null) {
            throw new RuntimeException("8007: 投递记录不存在");
        }

        JobInterview interview = new JobInterview();
        interview.setApplicationId(applicationId);
        interview.setCompanyUserId(userId);
        interview.setCandidateUserId(application.getUserId());
        interview.setInterviewTime(interviewTime);
        interview.setLocation(location);
        interview.setType(type != null ? type : "offline");
        interview.setRemark(remark);
        interview.setStatus("scheduled");

        // Update application status
        application.setStatus("interview");
        applicationRepository.save(application);

        interview = interviewRepository.save(interview);
        log.info("Interview scheduled: {} for application {}", interview.getInterviewId(), applicationId);
        return interview;
    }

    // ==================== 12. getInterviews ====================

    public List<JobInterview> getInterviews(String userId) {
        return interviewRepository.findByCandidateUserIdOrCompanyUserId(userId, userId);
    }

    // ==================== 13. upgradeVip ====================

    @Transactional
    public JobVip upgradeVip(String userId, String role) {
        // Mock payment
        log.info("Mock VIP payment for user: {} role: {}", userId, role);

        JobVip vip = vipRepository.findByUserId(userId).orElse(null);
        if (vip == null) {
            vip = new JobVip();
            vip.setUserId(userId);
        }
        vip.setRole(role != null ? role : "candidate");
        vip.setLevel(1);
        vip.setExpiresAt(LocalDateTime.now().plusDays(30));

        vip = vipRepository.save(vip);
        log.info("VIP upgraded: {} for user {}", vip.getVipId(), userId);
        return vip;
    }

    // ==================== 14. buyBoost ====================

    @Transactional
    public Map<String, Object> buyBoost(String userId, String positionId) {
        // Mock payment
        log.info("Mock boost payment for user: {} position: {}", userId, positionId);

        JobPosition position = positionRepository.findByPositionId(positionId)
                .orElseThrow(() -> new RuntimeException("8005: 职位不存在"));

        position.setIsBoosted(true);
        position.setBoostExpiresAt(LocalDateTime.now().plusDays(7));
        positionRepository.save(position);

        Map<String, Object> result = new HashMap<>();
        result.put("positionId", positionId);
        result.put("isBoosted", true);
        result.put("boostExpiresAt", position.getBoostExpiresAt().toString());
        result.put("message", "Mock boost activated for 7 days");
        return result;
    }

    // ==================== 15. aiBatchInvite ====================

    public List<Map<String, Object>> aiBatchInvite(String userId, String positionId, List<String> resumeIds) {
        // Mock AI batch invite
        log.info("Mock AI batch invite: position={}, resumes={}", positionId, resumeIds);

        List<Map<String, Object>> results = new ArrayList<>();
        for (String resumeId : resumeIds) {
            Map<String, Object> item = new HashMap<>();
            item.put("resumeId", resumeId);
            item.put("status", "Mock sent");
            item.put("message", "AI模拟邀请已发送至简历 " + resumeId);
            results.add(item);
        }
        return results;
    }

    // ==================== 16. buyExpertService ====================

    public Map<String, Object> buyExpertService(String userId, String serviceType) {
        // Mock payment for expert service
        log.info("Mock expert service payment: user={}, serviceType={}", userId, serviceType);

        Map<String, Object> result = new HashMap<>();
        result.put("serviceType", serviceType);
        result.put("status", "Mock paid");

        switch (serviceType != null ? serviceType : "") {
            case "resume_submit":
                result.put("description", "简历代投服务");
                result.put("price", "Mock ¥199");
                break;
            case "resume_custom":
                result.put("description", "简历定制服务");
                result.put("price", "Mock ¥299");
                break;
            case "career_consult":
                result.put("description", "职业咨询");
                result.put("price", "Mock ¥399");
                break;
            case "job_butler":
                result.put("description", "求职管家");
                result.put("price", "Mock ¥999");
                break;
            default:
                result.put("description", "未知服务");
                result.put("price", "Mock ¥0");
                break;
        }

        return result;
    }
}
