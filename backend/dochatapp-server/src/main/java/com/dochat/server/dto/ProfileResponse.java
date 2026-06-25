package com.dochat.server.dto;

public class ProfileResponse {

    private String userId;
    private String nickname;
    private String avatar;
    private String email;
    private Boolean isVerified;
    private Integer creditScore;
    private String creditLevel;

    public ProfileResponse() {}

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Boolean getIsVerified() { return isVerified; }
    public void setIsVerified(Boolean isVerified) { this.isVerified = isVerified; }

    public Integer getCreditScore() { return creditScore; }
    public void setCreditScore(Integer creditScore) { this.creditScore = creditScore; }

    public String getCreditLevel() { return creditLevel; }
    public void setCreditLevel(String creditLevel) { this.creditLevel = creditLevel; }
}
