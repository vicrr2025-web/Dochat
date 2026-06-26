package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_orders")
public class ExpressOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String orderId;

    @Column(nullable = false, length = 32)
    private String userId;

    @Column(length = 32)
    private String driverId;

    @Column(nullable = false, length = 20)
    private String type;

    @Column(length = 20)
    private String vehicleType;

    @Column(nullable = false, length = 255)
    private String originAddress;

    @Column(precision = 12, scale = 8)
    private BigDecimal originLat;

    @Column(precision = 12, scale = 8)
    private BigDecimal originLng;

    @Column(nullable = false, length = 255)
    private String destAddress;

    @Column(precision = 12, scale = 8)
    private BigDecimal destLat;

    @Column(precision = 12, scale = 8)
    private BigDecimal destLng;

    @Column(columnDefinition = "TEXT")
    private String cargoInfo;

    @Column(precision = 12, scale = 2)
    private BigDecimal estimatedPrice;

    @Column(precision = 12, scale = 2)
    private BigDecimal actualPrice;

    @Column
    private Boolean insured;

    @Column(precision = 12, scale = 2)
    private BigDecimal insuranceFee;

    @Column(nullable = false, length = 20)
    private String status = "pending";

    @Column
    private Integer rating;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        if (this.orderId == null) {
            this.orderId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
        if (this.status == null) {
            this.status = "pending";
        }
    }

    public ExpressOrder() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getDriverId() { return driverId; }
    public void setDriverId(String driverId) { this.driverId = driverId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getOriginAddress() { return originAddress; }
    public void setOriginAddress(String originAddress) { this.originAddress = originAddress; }

    public BigDecimal getOriginLat() { return originLat; }
    public void setOriginLat(BigDecimal originLat) { this.originLat = originLat; }

    public BigDecimal getOriginLng() { return originLng; }
    public void setOriginLng(BigDecimal originLng) { this.originLng = originLng; }

    public String getDestAddress() { return destAddress; }
    public void setDestAddress(String destAddress) { this.destAddress = destAddress; }

    public BigDecimal getDestLat() { return destLat; }
    public void setDestLat(BigDecimal destLat) { this.destLat = destLat; }

    public BigDecimal getDestLng() { return destLng; }
    public void setDestLng(BigDecimal destLng) { this.destLng = destLng; }

    public String getCargoInfo() { return cargoInfo; }
    public void setCargoInfo(String cargoInfo) { this.cargoInfo = cargoInfo; }

    public BigDecimal getEstimatedPrice() { return estimatedPrice; }
    public void setEstimatedPrice(BigDecimal estimatedPrice) { this.estimatedPrice = estimatedPrice; }

    public BigDecimal getActualPrice() { return actualPrice; }
    public void setActualPrice(BigDecimal actualPrice) { this.actualPrice = actualPrice; }

    public Boolean getInsured() { return insured; }
    public void setInsured(Boolean insured) { this.insured = insured; }

    public BigDecimal getInsuranceFee() { return insuranceFee; }
    public void setInsuranceFee(BigDecimal insuranceFee) { this.insuranceFee = insuranceFee; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
