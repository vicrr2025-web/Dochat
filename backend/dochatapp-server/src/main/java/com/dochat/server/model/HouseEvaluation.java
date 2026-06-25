package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "house_evaluations")
public class HouseEvaluation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, length = 32)
    private String evaluationId;

    @Column(length = 32)
    private String userId;

    @Column(length = 32)
    private String type;

    @Column(columnDefinition = "TEXT")
    private String houseInfo;

    @Column(columnDefinition = "TEXT")
    private String result;

    @Column(length = 16)
    private String status = "completed";

    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (evaluationId == null) {
            evaluationId = UUID.randomUUID().toString().substring(0, 16);
        }
        createdAt = LocalDateTime.now();
    }

    public HouseEvaluation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEvaluationId() { return evaluationId; }
    public void setEvaluationId(String evaluationId) { this.evaluationId = evaluationId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getHouseInfo() { return houseInfo; }
    public void setHouseInfo(String houseInfo) { this.houseInfo = houseInfo; }

    public String getResult() { return result; }
    public void setResult(String result) { this.result = result; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
