package com.dochat.server.dto;

public class LikeRequest {

    private String toUserId;

    public LikeRequest() {}

    public String getToUserId() { return toUserId; }
    public void setToUserId(String toUserId) { this.toUserId = toUserId; }
}
