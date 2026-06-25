package com.dochat.server.dto;

public class ProfileUpdateRequest {

    private String nickname;
    private String avatar;

    public ProfileUpdateRequest() {}

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
}
