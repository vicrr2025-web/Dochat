package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "dating_lives")
public class DatingLive {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String liveId;

    @Column(nullable = false)
    private String userId;

    @Column(nullable = false, length = 16)
    private String status = "live";

    @Column(nullable = false)
    private int viewerCount = 0;

    @Column(nullable = false)
    private int giftValue = 0;

    @Column(nullable = false, updatable = false)
    private LocalDateTime startedAt;

    private LocalDateTime endedAt;

    @PrePersist
    protected void onCreate() {
        this.startedAt = LocalDateTime.now();
    }

    public DatingLive() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getLiveId() { return liveId; }
    public void setLiveId(String liveId) { this.liveId = liveId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getViewerCount() { return viewerCount; }
    public void setViewerCount(int viewerCount) { this.viewerCount = viewerCount; }

    public int getGiftValue() { return giftValue; }
    public void setGiftValue(int giftValue) { this.giftValue = giftValue; }

    public LocalDateTime getStartedAt() { return startedAt; }
    public void setStartedAt(LocalDateTime startedAt) { this.startedAt = startedAt; }

    public LocalDateTime getEndedAt() { return endedAt; }
    public void setEndedAt(LocalDateTime endedAt) { this.endedAt = endedAt; }
}
