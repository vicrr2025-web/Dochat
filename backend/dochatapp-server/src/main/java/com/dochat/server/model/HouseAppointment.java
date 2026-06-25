package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "house_appointments")
public class HouseAppointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, length = 32)
    private String appointmentId;

    @Column(length = 32)
    private String houseId;

    @Column(length = 32)
    private String userId;

    private LocalDateTime appointmentTime;

    @Column(length = 64)
    private String contactName;

    @Column(length = 32)
    private String contactPhone;

    @Column(length = 256)
    private String remark;

    @Column(length = 16)
    private String type = "viewing";

    @Column(length = 16)
    private String status = "pending";

    private LocalDateTime createdAt;

    @PrePersist
    void onCreate() {
        if (appointmentId == null) {
            appointmentId = UUID.randomUUID().toString().substring(0, 16);
        }
        createdAt = LocalDateTime.now();
    }

    public HouseAppointment() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getAppointmentId() { return appointmentId; }
    public void setAppointmentId(String appointmentId) { this.appointmentId = appointmentId; }

    public String getHouseId() { return houseId; }
    public void setHouseId(String houseId) { this.houseId = houseId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public LocalDateTime getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(LocalDateTime appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
