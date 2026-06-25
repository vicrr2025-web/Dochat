package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "job_vips")
public class JobVip {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String vipId;

    @Column(nullable = false, length = 32)
    private String userId;

    @Column(nullable = false, length = 20)
    private String role = "candidate";

    @Column(nullable = false)
    private Integer level = 1;

    @Column(nullable = false)
    private LocalDateTime expiresAt;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.vipId == null) {
            this.vipId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public JobVip() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getVipId() { return vipId; }
    public void setVipId(String vipId) { this.vipId = vipId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
