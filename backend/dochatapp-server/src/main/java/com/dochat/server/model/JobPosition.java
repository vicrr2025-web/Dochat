package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "job_positions")
public class JobPosition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String positionId;

    @Column(nullable = false, length = 32)
    private String companyId;

    @Column(length = 128)
    private String companyName;

    @Column(nullable = false, length = 128)
    private String title;

    @Column(length = 32)
    private String industry;

    @Column(length = 32)
    private String city;

    private Integer salaryMin;

    private Integer salaryMax;

    @Column(length = 64)
    private String experienceRequired;

    @Column(length = 64)
    private String educationRequired;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @Column(nullable = false, length = 20)
    private String status = "active";

    @Column(nullable = false)
    private Integer viewCount = 0;

    @Column(nullable = false)
    private Integer applyCount = 0;

    @Column(nullable = false)
    private Boolean isBoosted = false;

    private LocalDateTime boostExpiresAt;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        if (this.positionId == null) {
            this.positionId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public JobPosition() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getPositionId() { return positionId; }
    public void setPositionId(String positionId) { this.positionId = positionId; }

    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Integer getSalaryMin() { return salaryMin; }
    public void setSalaryMin(Integer salaryMin) { this.salaryMin = salaryMin; }

    public Integer getSalaryMax() { return salaryMax; }
    public void setSalaryMax(Integer salaryMax) { this.salaryMax = salaryMax; }

    public String getExperienceRequired() { return experienceRequired; }
    public void setExperienceRequired(String experienceRequired) { this.experienceRequired = experienceRequired; }

    public String getEducationRequired() { return educationRequired; }
    public void setEducationRequired(String educationRequired) { this.educationRequired = educationRequired; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getViewCount() { return viewCount; }
    public void setViewCount(Integer viewCount) { this.viewCount = viewCount; }

    public Integer getApplyCount() { return applyCount; }
    public void setApplyCount(Integer applyCount) { this.applyCount = applyCount; }

    public Boolean getIsBoosted() { return isBoosted; }
    public void setIsBoosted(Boolean isBoosted) { this.isBoosted = isBoosted; }

    public LocalDateTime getBoostExpiresAt() { return boostExpiresAt; }
    public void setBoostExpiresAt(LocalDateTime boostExpiresAt) { this.boostExpiresAt = boostExpiresAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
