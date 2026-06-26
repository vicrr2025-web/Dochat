package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_locations")
public class ExpressLocation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String recordId;

    @Column(nullable = false, length = 16)
    private String orderId;

    @Column(nullable = false, precision = 12, scale = 8)
    private BigDecimal lat;

    @Column(nullable = false, precision = 12, scale = 8)
    private BigDecimal lng;

    @Column(nullable = false)
    private LocalDateTime recordedAt;

    @PrePersist
    protected void onCreate() {
        this.recordedAt = LocalDateTime.now();
        if (this.recordId == null) {
            this.recordId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public ExpressLocation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRecordId() { return recordId; }
    public void setRecordId(String recordId) { this.recordId = recordId; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public BigDecimal getLat() { return lat; }
    public void setLat(BigDecimal lat) { this.lat = lat; }

    public BigDecimal getLng() { return lng; }
    public void setLng(BigDecimal lng) { this.lng = lng; }

    public LocalDateTime getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDateTime recordedAt) { this.recordedAt = recordedAt; }
}
