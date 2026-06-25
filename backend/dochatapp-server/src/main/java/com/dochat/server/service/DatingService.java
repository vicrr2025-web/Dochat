package com.dochat.server.service;

import com.dochat.server.dto.ProfileRequest;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class DatingService {

    private final DatingProfileRepository profileRepository;
    private final DatingLikeRepository likeRepository;
    private final DatingNoteRepository noteRepository;
    private final DatingFeedRepository feedRepository;
    private final DatingLiveRepository liveRepository;

    public DatingService(DatingProfileRepository profileRepository,
                         DatingLikeRepository likeRepository,
                         DatingNoteRepository noteRepository,
                         DatingFeedRepository feedRepository,
                         DatingLiveRepository liveRepository) {
        this.profileRepository = profileRepository;
        this.likeRepository = likeRepository;
        this.noteRepository = noteRepository;
        this.feedRepository = feedRepository;
        this.liveRepository = liveRepository;
    }

    @Transactional
    public DatingProfile createOrUpdateProfile(String userId, ProfileRequest request) {
        DatingProfile profile = profileRepository.findByUserId(userId).orElse(null);
        if (profile == null) {
            profile = new DatingProfile();
            profile.setProfileId(UUID.randomUUID().toString().substring(0, 16));
            profile.setUserId(userId);
        }
        if (request.getGender() != null) profile.setGender(request.getGender());
        if (request.getBirthday() != null) profile.setBirthday(LocalDate.parse(request.getBirthday()));
        if (request.getHeight() != null) profile.setHeight(request.getHeight());
        if (request.getEducation() != null) profile.setEducation(request.getEducation());
        if (request.getIncome() != null) profile.setIncome(request.getIncome());
        if (request.getMaritalStatus() != null) profile.setMaritalStatus(request.getMaritalStatus());
        if (request.getAvatar() != null) profile.setAvatar(request.getAvatar());
        if (request.getPhotos() != null) profile.setPhotos(request.getPhotos());
        if (request.getTags() != null) profile.setTags(request.getTags());
        if (request.getAboutMe() != null) profile.setAboutMe(request.getAboutMe());
        return profileRepository.save(profile);
    }

    public DatingProfile getProfile(String userId) {
        return profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
    }

    public Page<DatingProfile> getRecommendations(String userId, Pageable pageable) {
        Page<DatingProfile> allProfiles = profileRepository.findAll(pageable);
        List<DatingProfile> filtered = allProfiles.getContent().stream()
                .filter(p -> !p.getUserId().equals(userId))
                .toList();
        return new PageImpl<>(filtered, pageable, allProfiles.getTotalElements());
    }

    @Transactional
    public Map<String, Object> like(String fromUserId, String toUserId) {
        DatingProfile fromProfile = profileRepository.findByUserId(fromUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        DatingProfile toProfile = profileRepository.findByUserId(toUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        if (likeRepository.findByFromUserIdAndToUserId(fromUserId, toUserId).isPresent()) {
            throw new IllegalStateException("Already liked");
        }

        DatingLike like = new DatingLike();
        like.setFromUserId(fromUserId);
        like.setToUserId(toUserId);
        like.setLikeType("normal");

        boolean isMatched = likeRepository.findByFromUserIdAndToUserId(toUserId, fromUserId).isPresent();
        if (isMatched) {
            like.setMatched(true);
            DatingLike reverse = likeRepository.findByFromUserIdAndToUserId(toUserId, fromUserId).get();
            reverse.setMatched(true);
            likeRepository.save(reverse);
        }
        likeRepository.save(like);

        Map<String, Object> result = new HashMap<>();
        result.put("isMatched", isMatched);
        return result;
    }

    @Transactional
    public Map<String, Object> superLike(String fromUserId, String toUserId) {
        DatingProfile fromProfile = profileRepository.findByUserId(fromUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        DatingProfile toProfile = profileRepository.findByUserId(toUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        if (fromProfile.getLoveCoin() < 5) {
            throw new IllegalStateException("Insufficient love coins");
        }

        fromProfile.setLoveCoin(fromProfile.getLoveCoin() - 5);
        profileRepository.save(fromProfile);

        DatingLike like = new DatingLike();
        like.setFromUserId(fromUserId);
        like.setToUserId(toUserId);
        like.setLikeType("super");

        boolean isMatched = likeRepository.findByFromUserIdAndToUserId(toUserId, fromUserId).isPresent();
        if (isMatched) {
            like.setMatched(true);
            DatingLike reverse = likeRepository.findByFromUserIdAndToUserId(toUserId, fromUserId).get();
            reverse.setMatched(true);
            likeRepository.save(reverse);
        }
        likeRepository.save(like);

        Map<String, Object> result = new HashMap<>();
        result.put("isMatched", isMatched);
        return result;
    }

    public List<DatingLike> getMatchStatus(String userId) {
        List<DatingLike> all = likeRepository.findByFromUserIdOrToUserId(userId);
        return all.stream().filter(DatingLike::isMatched).toList();
    }

    @Transactional
    public DatingNote sendNote(String fromUserId, String toUserId, String content) {
        DatingProfile fromProfile = profileRepository.findByUserId(fromUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        DatingProfile toProfile = profileRepository.findByUserId(toUserId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        String noteContent = (content == null || content.isBlank())
                ? "你好，很高兴认识你"
                : content;

        DatingNote note = new DatingNote();
        note.setNoteId(UUID.randomUUID().toString().substring(0, 16));
        note.setFromUserId(fromUserId);
        note.setToUserId(toUserId);
        note.setContent(noteContent);
        return noteRepository.save(note);
    }

    public List<DatingNote> getNotes(String userId) {
        List<DatingNote> sent = noteRepository.findByFromUserIdOrderByCreatedAtDesc(userId);
        List<DatingNote> received = noteRepository.findByToUserIdOrderByCreatedAtDesc(userId);
        List<DatingNote> all = new ArrayList<>();
        all.addAll(sent);
        all.addAll(received);
        all.sort((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()));
        return all;
    }

    @Transactional
    public Map<String, Object> authReal(String userId) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        profile.setRealVerified(true);
        profileRepository.save(profile);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    @Transactional
    public Map<String, Object> authWork(String userId) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        profile.setWorkVerified(true);
        profileRepository.save(profile);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    @Transactional
    public Map<String, Object> authEdu(String userId) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        profile.setEduVerified(true);
        profileRepository.save(profile);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    @Transactional
    public DatingFeed createFeed(String userId, String content, String images) {
        DatingFeed feed = new DatingFeed();
        feed.setFeedId(UUID.randomUUID().toString().substring(0, 16));
        feed.setUserId(userId);
        feed.setContent(content);
        feed.setImages(images);
        return feedRepository.save(feed);
    }

    public Page<DatingFeed> getFeeds(Pageable pageable) {
        List<DatingFeed> feeds = feedRepository.findAllByOrderByCreatedAtDesc(pageable);
        return new PageImpl<>(feeds, pageable, feeds.size());
    }

    @Transactional
    public Map<String, Object> toggleFeedLike(String feedId, String userId) {
        DatingFeed feed = feedRepository.findAll().stream()
                .filter(f -> f.getFeedId().equals(feedId))
                .findFirst()
                .orElseThrow(() -> new NoSuchElementException("Feed not found"));
        feed.setLikeCount(feed.getLikeCount() + 1);
        feedRepository.save(feed);
        Map<String, Object> result = new HashMap<>();
        result.put("feedId", feedId);
        result.put("likeCount", feed.getLikeCount());
        return result;
    }

    @Transactional
    public Map<String, Object> addFeedComment(String feedId, String userId, String content) {
        DatingFeed feed = feedRepository.findAll().stream()
                .filter(f -> f.getFeedId().equals(feedId))
                .findFirst()
                .orElseThrow(() -> new NoSuchElementException("Feed not found"));
        feed.setCommentCount(feed.getCommentCount() + 1);
        feedRepository.save(feed);
        Map<String, Object> result = new HashMap<>();
        result.put("feedId", feedId);
        result.put("commentCount", feed.getCommentCount());
        return result;
    }

    @Transactional
    public DatingLive startLive(String userId) {
        profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        Optional<DatingLive> existing = liveRepository.findByUserIdAndStatus(userId, "live");
        if (existing.isPresent()) {
            throw new IllegalStateException("Already in a live session");
        }

        DatingLive live = new DatingLive();
        live.setLiveId(UUID.randomUUID().toString().substring(0, 16));
        live.setUserId(userId);
        live.setStatus("live");
        return liveRepository.save(live);
    }

    @Transactional
    public DatingLive endLive(String userId) {
        DatingLive live = liveRepository.findByUserIdAndStatus(userId, "live")
                .orElseThrow(() -> new NoSuchElementException("No active live session"));
        live.setStatus("ended");
        live.setEndedAt(LocalDateTime.now());
        return liveRepository.save(live);
    }

    @Transactional
    public Map<String, Object> sendGift(String fromUserId, String toUserId, String giftType) {
        DatingProfile receiver = profileRepository.findByUserId(toUserId)
                .orElseThrow(() -> new NoSuchElementException("Receiver profile not found"));

        DatingLive live = liveRepository.findByUserIdAndStatus(toUserId, "live")
                .orElseThrow(() -> new NoSuchElementException("Receiver is not live"));

        int giftValue;
        switch (giftType != null ? giftType : "rose") {
            case "car": giftValue = 10; break;
            case "castle": giftValue = 50; break;
            default: giftValue = 1;
        }

        live.setGiftValue(live.getGiftValue() + giftValue);
        liveRepository.save(live);

        receiver.setCharmValue(receiver.getCharmValue() + giftValue);
        profileRepository.save(receiver);

        Map<String, Object> result = new HashMap<>();
        result.put("giftType", giftType);
        result.put("giftValue", giftValue);
        return result;
    }

    @Transactional
    public Map<String, Object> recharge(String userId, int amount) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));
        profile.setLoveCoin(profile.getLoveCoin() + amount);
        profileRepository.save(profile);
        Map<String, Object> result = new HashMap<>();
        result.put("loveCoin", profile.getLoveCoin());
        return result;
    }

    @Transactional
    public Map<String, Object> upgradeVip(String userId, int months) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        int cost = months * 30;
        if (profile.getLoveCoin() < cost) {
            throw new IllegalStateException("Insufficient love coins");
        }

        profile.setLoveCoin(profile.getLoveCoin() - cost);
        profile.setVipLevel(1);
        profile.setVipExpiresAt(LocalDateTime.now().plusMonths(months));
        profileRepository.save(profile);

        Map<String, Object> result = new HashMap<>();
        result.put("vipLevel", 1);
        result.put("vipExpiresAt", profile.getVipExpiresAt().toString());
        return result;
    }

    @Transactional
    public Map<String, Object> superBoost(String userId) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        if (profile.getLoveCoin() < 50) {
            throw new IllegalStateException("Insufficient love coins");
        }

        profile.setLoveCoin(profile.getLoveCoin() - 50);
        profileRepository.save(profile);

        Map<String, Object> result = new HashMap<>();
        result.put("message", "Super boost activated");
        result.put("remainingCoins", profile.getLoveCoin());
        return result;
    }

    @Transactional
    public Map<String, Object> charmWithdraw(String userId, int amount) {
        DatingProfile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new NoSuchElementException("Profile not found"));

        if (profile.getCharmValue() < amount) {
            throw new IllegalStateException("Insufficient charm value");
        }

        profile.setCharmValue(profile.getCharmValue() - amount);
        profileRepository.save(profile);

        Map<String, Object> result = new HashMap<>();
        result.put("charmValue", profile.getCharmValue());
        result.put("withdrawn", amount);
        return result;
    }
}
