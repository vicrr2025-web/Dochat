package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_withdrawals")
public class ExpressWithdrawal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String withdrawalId;

    @Column(nullable = false, length = 16)
    private String driverId;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    @Column(nullable = false, length = 50)
    private String bankAccount;

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.withdrawalId == null) {
            this.withdrawalId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public ExpressWithdrawal() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getWithdrawalId() { return withdrawalId; }
    public void setWithdrawalId(String withdrawalId) { this.withdrawalId = withdrawalId; }

    public String getDriverId() { return driverId; }
    public void setDriverId(String driverId) { this.driverId = driverId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
