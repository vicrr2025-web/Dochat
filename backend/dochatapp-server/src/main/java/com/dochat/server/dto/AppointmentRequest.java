package com.dochat.server.dto;

public class AppointmentRequest {

    private String houseId;
    private String appointmentTime;
    private String contactName;
    private String contactPhone;
    private String remark;
    private String type = "viewing";

    public AppointmentRequest() {}

    public String getHouseId() { return houseId; }
    public void setHouseId(String houseId) { this.houseId = houseId; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}
