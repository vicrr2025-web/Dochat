package com.dochat.server.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TradeResponse {

    private Long id;
    private String tradeId;
    private String buyerId;
    private String sellerId;
    private String buyerNickname;
    private String sellerNickname;
    private String productName;
    private String productDesc;
    private BigDecimal amount;
    private String status;
    private String verifyStatus;
    private String verifyReport;
    private String disputeId;
    private String sessionId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TradeResponse() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTradeId() { return tradeId; }
    public void setTradeId(String tradeId) { this.tradeId = tradeId; }

    public String getBuyerId() { return buyerId; }
    public void setBuyerId(String buyerId) { this.buyerId = buyerId; }

    public String getSellerId() { return sellerId; }
    public void setSellerId(String sellerId) { this.sellerId = sellerId; }

    public String getBuyerNickname() { return buyerNickname; }
    public void setBuyerNickname(String buyerNickname) { this.buyerNickname = buyerNickname; }

    public String getSellerNickname() { return sellerNickname; }
    public void setSellerNickname(String sellerNickname) { this.sellerNickname = sellerNickname; }

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
