package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_insurances")
public class ExpressInsurance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String insuranceId;

    @Column(nullable = false, unique = true, length = 16)
    private String orderId;

    @Column(nullable = false, length = 32)
    private String userId;

    @Column(nullable = false, length = 20)
    private String type = "basic";

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal fee;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal coverage;

    @Column(nullable = false, length = 20)
    private String status = "active";

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.insuranceId == null) {
            this.insuranceId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public ExpressInsurance() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getInsuranceId() { return insuranceId; }
    public void setInsuranceId(String insuranceId) { this.insuranceId = insuranceId; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public BigDecimal getCoverage() { return coverage; }
    public void setCoverage(BigDecimal coverage) { this.coverage = coverage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
