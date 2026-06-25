package com.dochat.server.dto;

public class AuthResponse {
    private String userId;
    private String token;
    private String refreshToken;
    private String userSig;
    private Long expiresIn;

    public AuthResponse() {}

    public AuthResponse(String userId, String token, String refreshToken, String userSig, Long expiresIn) {
        this.userId = userId;
        this.token = token;
        this.refreshToken = refreshToken;
        this.userSig = userSig;
        this.expiresIn = expiresIn;
    }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public String getRefreshToken() { return refreshToken; }
    public void setRefreshToken(String refreshToken) { this.refreshToken = refreshToken; }

    public String getUserSig() { return userSig; }
    public void setUserSig(String userSig) { this.userSig = userSig; }

    public Long getExpiresIn() { return expiresIn; }
    public void setExpiresIn(Long expiresIn) { this.expiresIn = expiresIn; }
}
