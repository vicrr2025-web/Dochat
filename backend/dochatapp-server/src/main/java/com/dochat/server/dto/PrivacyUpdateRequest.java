package com.dochat.server.dto;

public class PrivacyUpdateRequest {

    private String onlineVisibility;
    private String avatarVisibility;
    private String bioVisibility;
    private String messagePermission;

    public PrivacyUpdateRequest() {}

    public String getOnlineVisibility() { return onlineVisibility; }
    public void setOnlineVisibility(String onlineVisibility) { this.onlineVisibility = onlineVisibility; }

    public String getAvatarVisibility() { return avatarVisibility; }
    public void setAvatarVisibility(String avatarVisibility) { this.avatarVisibility = avatarVisibility; }

    public String getBioVisibility() { return bioVisibility; }
    public void setBioVisibility(String bioVisibility) { this.bioVisibility = bioVisibility; }

    public String getMessagePermission() { return messagePermission; }
    public void setMessagePermission(String messagePermission) { this.messagePermission = messagePermission; }
}
