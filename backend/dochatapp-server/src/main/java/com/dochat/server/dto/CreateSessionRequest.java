package com.dochat.server.dto;

public class CreateSessionRequest {
    private String targetUserId;

    public CreateSessionRequest() {}

    public String getTargetUserId() { return targetUserId; }
    public void setTargetUserId(String targetUserId) { this.targetUserId = targetUserId; }
}
