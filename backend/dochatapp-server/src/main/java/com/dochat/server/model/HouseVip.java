package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "house_vips")
public class HouseVip {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, length = 32)
    private String vipId;

    @Column(length = 32)
    private String userId;

    private Integer level = 1;

    private LocalDateTime expiresAt;

    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (vipId == null) {
            vipId = UUID.randomUUID().toString().substring(0, 16);
        }
        createdAt = LocalDateTime.now();
    }

    public HouseVip() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getVipId() { return vipId; }
    public void setVipId(String vipId) { this.vipId = vipId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
