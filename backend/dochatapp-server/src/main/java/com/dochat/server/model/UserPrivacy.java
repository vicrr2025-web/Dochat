package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_privacy")
public class UserPrivacy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 32)
    private String userId;

    @Column(nullable = false, length = 16)
    private String onlineVisibility = "all";

    @Column(nullable = false, length = 16)
    private String avatarVisibility = "all";

    @Column(nullable = false, length = 16)
    private String bioVisibility = "all";

    @Column(nullable = false, length = 16)
    private String messagePermission = "all";

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public UserPrivacy() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getOnlineVisibility() { return onlineVisibility; }
    public void setOnlineVisibility(String onlineVisibility) { this.onlineVisibility = onlineVisibility; }

    public String getAvatarVisibility() { return avatarVisibility; }
    public void setAvatarVisibility(String avatarVisibility) { this.avatarVisibility = avatarVisibility; }

    public String getBioVisibility() { return bioVisibility; }
    public void setBioVisibility(String bioVisibility) { this.bioVisibility = bioVisibility; }

    public String getMessagePermission() { return messagePermission; }
    public void setMessagePermission(String messagePermission) { this.messagePermission = messagePermission; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
