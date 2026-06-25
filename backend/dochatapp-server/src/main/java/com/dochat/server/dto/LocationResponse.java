package com.dochat.server.dto;

import java.time.LocalDateTime;

public class LocationResponse {
    private Double latitude;
    private Double longitude;
    private Float accuracy;
    private Integer battery;
    private Boolean isCharging;
    private LocalDateTime updatedAt;

    public LocationResponse() {}

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

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
