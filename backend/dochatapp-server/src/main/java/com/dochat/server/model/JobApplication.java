package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "job_applications", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"positionId", "userId"})
})
public class JobApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String applicationId;

    @Column(nullable = false, length = 16)
    private String positionId;

    @Column(nullable = false, length = 32)
    private String userId;

    @Column(length = 16)
    private String resumeId;

    @Column(nullable = false, length = 20)
    private String status = "applied";

    @Column(columnDefinition = "TEXT")
    private String greeting;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        if (this.applicationId == null) {
            this.applicationId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public JobApplication() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getApplicationId() { return applicationId; }
    public void setApplicationId(String applicationId) { this.applicationId = applicationId; }

    public String getPositionId() { return positionId; }
    public void setPositionId(String positionId) { this.positionId = positionId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getResumeId() { return resumeId; }
    public void setResumeId(String resumeId) { this.resumeId = resumeId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getGreeting() { return greeting; }
    public void setGreeting(String greeting) { this.greeting = greeting; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
