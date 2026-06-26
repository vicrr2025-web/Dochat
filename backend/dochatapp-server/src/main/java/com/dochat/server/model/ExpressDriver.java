package com.dochat.server.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "express_drivers")
public class ExpressDriver {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String driverId;

    @Column(nullable = false, unique = true, length = 32)
    private String userId;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false, length = 20)
    private String phone;

    @Column(nullable = false, length = 18)
    private String idCard;

    @Column(nullable = false, length = 30)
    private String licenseNo;

    @Column(nullable = false, length = 20)
    private String vehicleType;

    @Column(nullable = false, length = 20)
    private String vehiclePlate;

    @Column(columnDefinition = "TEXT")
    private String vehicleInfo;

    @Column(nullable = false, length = 20)
    private String authStatus = "pending";

    @Column(nullable = false)
    private Integer creditScore = 100;

    @Column(nullable = false, length = 20)
    private String status = "offline";

    @Column(precision = 12, scale = 8)
    private BigDecimal currentLat;

    @Column(precision = 12, scale = 8)
    private BigDecimal currentLng;

    @Column(precision = 15, scale = 2)
    private BigDecimal totalIncome = BigDecimal.ZERO;

    @Column(precision = 15, scale = 2)
    private BigDecimal balance = BigDecimal.ZERO;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.driverId == null) {
            this.driverId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public ExpressDriver() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDriverId() { return driverId; }
    public void setDriverId(String driverId) { this.driverId = driverId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }

    public String getLicenseNo() { return licenseNo; }
    public void setLicenseNo(String licenseNo) { this.licenseNo = licenseNo; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getVehiclePlate() { return vehiclePlate; }
    public void setVehiclePlate(String vehiclePlate) { this.vehiclePlate = vehiclePlate; }

    public String getVehicleInfo() { return vehicleInfo; }
    public void setVehicleInfo(String vehicleInfo) { this.vehicleInfo = vehicleInfo; }

    public String getAuthStatus() { return authStatus; }
    public void setAuthStatus(String authStatus) { this.authStatus = authStatus; }

    public Integer getCreditScore() { return creditScore; }
    public void setCreditScore(Integer creditScore) { this.creditScore = creditScore; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getCurrentLat() { return currentLat; }
    public void setCurrentLat(BigDecimal currentLat) { this.currentLat = currentLat; }

    public BigDecimal getCurrentLng() { return currentLng; }
    public void setCurrentLng(BigDecimal currentLng) { this.currentLng = currentLng; }

    public BigDecimal getTotalIncome() { return totalIncome; }
    public void setTotalIncome(BigDecimal totalIncome) { this.totalIncome = totalIncome; }

    public BigDecimal getBalance() { return balance; }
    public void setBalance(BigDecimal balance) { this.balance = balance; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
