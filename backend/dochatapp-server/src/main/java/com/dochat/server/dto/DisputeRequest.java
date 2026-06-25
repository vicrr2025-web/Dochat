package com.dochat.server.dto;

public class DisputeRequest {

    private String reason;
    private String description;

    public DisputeRequest() {}

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
