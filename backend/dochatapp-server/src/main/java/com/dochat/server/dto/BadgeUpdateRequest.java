package com.dochat.server.dto;

public class BadgeUpdateRequest {

    private String ecosystemKey;
    private int delta;

    public BadgeUpdateRequest() {}

    public BadgeUpdateRequest(String ecosystemKey, int delta) {
        this.ecosystemKey = ecosystemKey;
        this.delta = delta;
    }

    public String getEcosystemKey() { return ecosystemKey; }
    public void setEcosystemKey(String ecosystemKey) { this.ecosystemKey = ecosystemKey; }

    public int getDelta() { return delta; }
    public void setDelta(int delta) { this.delta = delta; }
}
