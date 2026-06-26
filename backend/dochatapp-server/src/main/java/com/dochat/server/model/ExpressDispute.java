package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_disputes")
public class ExpressDispute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String disputeId;

    @Column(nullable = false, length = 16)
    private String orderId;

    @Column(nullable = false, length = 32)
    private String initiatorId;

    @Column(nullable = false, length = 500)
    private String reason;

    @Column(columnDefinition = "TEXT")
    private String evidence;

    @Column(nullable = false)
    private Integer juryVotesFor = 0;

    @Column(nullable = false)
    private Integer juryVotesAgainst = 0;

    @Column(nullable = false)
    private Integer totalJurors = 17;

    @Column(length = 20)
    private String verdict;

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.disputeId == null) {
            this.disputeId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public ExpressDispute() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDisputeId() { return disputeId; }
    public void setDisputeId(String disputeId) { this.disputeId = disputeId; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getInitiatorId() { return initiatorId; }
    public void setInitiatorId(String initiatorId) { this.initiatorId = initiatorId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getEvidence() { return evidence; }
    public void setEvidence(String evidence) { this.evidence = evidence; }

    public Integer getJuryVotesFor() { return juryVotesFor; }
    public void setJuryVotesFor(Integer juryVotesFor) { this.juryVotesFor = juryVotesFor; }

    public Integer getJuryVotesAgainst() { return juryVotesAgainst; }
    public void setJuryVotesAgainst(Integer juryVotesAgainst) { this.juryVotesAgainst = juryVotesAgainst; }

    public Integer getTotalJurors() { return totalJurors; }
    public void setTotalJurors(Integer totalJurors) { this.totalJurors = totalJurors; }

    public String getVerdict() { return verdict; }
    public void setVerdict(String verdict) { this.verdict = verdict; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
