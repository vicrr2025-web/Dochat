package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "guarantee_trades")
public class GuaranteeTrade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 32)
    private String tradeId;

    @Column(nullable = false, length = 32)
    private String buyerId;

    @Column(nullable = false, length = 32)
    private String sellerId;

    @Column(nullable = false, length = 128)
    private String productName;

    @Column(columnDefinition = "TEXT")
    private String productDesc;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column(length = 20)
    private String verifyStatus;

    @Column(columnDefinition = "TEXT")
    private String verifyReport;

    @Column(length = 32)
    private String disputeId;

    @Column(length = 32)
    private String sessionId;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        if (this.tradeId == null) {
            this.tradeId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public GuaranteeTrade() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTradeId() { return tradeId; }
    public void setTradeId(String tradeId) { this.tradeId = tradeId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getSellerId() { return sellerId; }
    public void setSellerId(String sellerId) { this.sellerId = sellerId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductDesc() { return productDesc; }
    public void setProductDesc(String productDesc) { this.productDesc = productDesc; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getVerifyStatus() { return verifyStatus; }
    public void setVerifyStatus(String verifyStatus) { this.verifyStatus = verifyStatus; }

    public String getVerifyReport() { return verifyReport; }
    public void setVerifyReport(String verifyReport) { this.verifyReport = verifyReport; }

    public String getDisputeId() { return disputeId; }
    public void setDisputeId(String disputeId) { this.disputeId = disputeId; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
