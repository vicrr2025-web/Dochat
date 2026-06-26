package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "mail_filters")
public class MailFilter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "filter_id", nullable = false, unique = true, length = 16)
    private String filterId;

    @Column(name = "user_id", nullable = false, length = 32)
    private String userId;

    @Column(nullable = false, length = 16)
    private String type;

    @Column(name = "address_pattern", nullable = false, length = 128)
    private String addressPattern;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.filterId == null) {
            this.filterId = UUID.randomUUID().toString().substring(0, 16);
        }
    }

    public MailFilter() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFilterId() { return filterId; }
    public void setFilterId(String filterId) { this.filterId = filterId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getAddressPattern() { return addressPattern; }
    public void setAddressPattern(String addressPattern) { this.addressPattern = addressPattern; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
