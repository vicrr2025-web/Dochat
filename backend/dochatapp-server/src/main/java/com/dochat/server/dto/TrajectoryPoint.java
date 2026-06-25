package com.dochat.server.dto;

import java.time.LocalDateTime;

public class TrajectoryPoint {
    private Double latitude;
    private Double longitude;
    private LocalDateTime recordedAt;

    public TrajectoryPoint() {}

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public LocalDateTime getRecordedAt() { return recordedAt; }
    public void setRecordedAt(LocalDateTime recordedAt) { this.recordedAt = recordedAt; }
}
