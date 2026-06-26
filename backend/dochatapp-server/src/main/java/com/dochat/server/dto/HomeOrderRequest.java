package com.dochat.server.dto;

import java.math.BigDecimal;

public class HomeOrderRequest {

    private String serviceId;
    private String workerId;
    private String address;
    private String appointmentTime;
    private BigDecimal price;

    public String getServiceId() { return serviceId; }
    public void setServiceId(String serviceId) { this.serviceId = serviceId; }

    public String getWorkerId() { return workerId; }
    public void setWorkerId(String workerId) { this.workerId = workerId; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(String appointmentTime) { this.appointmentTime = appointmentTime; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
}
