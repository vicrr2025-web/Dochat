package com.dochat.server.model;

import jakarta.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "location_records", indexes = {
    @Index(name = "idx_location_user_recorded", columnList = "userId, recordedAt")
})
public class LocationRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 32)
    private String userId;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    private Float accuracy;

    private Integer battery;

    private Boolean isCharging;

    @Column(nullable = false)
    private Timestamp recordedAt;

    @PrePersist
    protected void onCreate() {
        if (recordedAt == null) {
            recordedAt = new Timestamp(System.currentTimeMillis());
        }
    }

    public LocationRecord() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public Float getAccuracy() { return accuracy; }
    public void setAccuracy(Float accuracy) { this.accuracy = accuracy; }

    public Integer getBattery() { return battery; }
    public void setBattery(Integer battery) { this.battery = battery; }

    public Boolean getIsCharging() { return isCharging; }
    public void setIsCharging(Boolean isCharging) { this.isCharging = isCharging; }

    public Timestamp getRecordedAt() { return recordedAt; }
    public void setRecordedAt(Timestamp recordedAt) { this.recordedAt = recordedAt; }
}
