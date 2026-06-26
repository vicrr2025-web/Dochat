package com.dochat.server.dto;

public class ExpressDisputeRequest {

    private String orderId;
    private String reason;

    public ExpressDisputeRequest() {}

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
