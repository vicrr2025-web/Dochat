package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "guarantee_disputes")
public class GuaranteeDispute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 32)
    private String disputeId;

    @Column(nullable = false, length = 32)
    private String tradeId;

    @Column(nullable = false, length = 32)
    private String initiatorId;

    @Column(nullable = false, length = 100)
    private String reason;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column(length = 20)
    private String verdict;

    @Column(nullable = false)
    private int juryCount = 0;

    @Column(nullable = false)
    private int votesForBuyer = 0;

    @Column(nullable = false)
    private int votesForSeller = 0;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    private LocalDateTime resolvedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.disputeId == null) {
            this.disputeId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public GuaranteeDispute() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDisputeId() { return disputeId; }
    public void setDisputeId(String disputeId) { this.disputeId = disputeId; }

    public String getTradeId() { return tradeId; }
    public void setTradeId(String tradeId) { this.tradeId = tradeId; }

    public String getInitiatorId() { return initiatorId; }
    public void setInitiatorId(String initiatorId) { this.initiatorId = initiatorId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getVerdict() { return verdict; }
    public void setVerdict(String verdict) { this.verdict = verdict; }

    public int getJuryCount() { return juryCount; }
    public void setJuryCount(int juryCount) { this.juryCount = juryCount; }

    public int getVotesForBuyer() { return votesForBuyer; }
    public void setVotesForBuyer(int votesForBuyer) { this.votesForBuyer = votesForBuyer; }

    public int getVotesForSeller() { return votesForSeller; }
    public void setVotesForSeller(int votesForSeller) { this.votesForSeller = votesForSeller; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(LocalDateTime resolvedAt) { this.resolvedAt = resolvedAt; }
}
