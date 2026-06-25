package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "job_interviews")
public class JobInterview {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String interviewId;

    @Column(nullable = false, length = 16)
    private String applicationId;

    @Column(nullable = false, length = 32)
    private String companyUserId;

    @Column(nullable = false, length = 32)
    private String candidateUserId;

    @Column(nullable = false)
    private LocalDateTime interviewTime;

    @Column(length = 200)
    private String location;

    @Column(nullable = false, length = 20)
    private String type = "offline";

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column(columnDefinition = "TEXT")
    private String remark;

    private Integer candidateRating;

    private Integer companyRating;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.interviewId == null) {
            this.interviewId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public JobInterview() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getInterviewId() { return interviewId; }
    public void setInterviewId(String interviewId) { this.interviewId = interviewId; }

    public String getApplicationId() { return applicationId; }
    public void setApplicationId(String applicationId) { this.applicationId = applicationId; }

    public String getCompanyUserId() { return companyUserId; }
    public void setCompanyUserId(String companyUserId) { this.companyUserId = companyUserId; }

    public String getCandidateUserId() { return candidateUserId; }
    public void setCandidateUserId(String candidateUserId) { this.candidateUserId = candidateUserId; }

    public LocalDateTime getInterviewTime() { return interviewTime; }
    public void setInterviewTime(LocalDateTime interviewTime) { this.interviewTime = interviewTime; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public Integer getCandidateRating() { return candidateRating; }
    public void setCandidateRating(Integer candidateRating) { this.candidateRating = candidateRating; }

    public Integer getCompanyRating() { return companyRating; }
    public void setCompanyRating(Integer companyRating) { this.companyRating = companyRating; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
