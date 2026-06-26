package com.dochat.server.dto;

public class HomeWorkerRegisterRequest {

    private String name;
    private String phone;
    private String idCard;
    private String skills;
    private String certificates;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getIdCard() { return idCard; }
    public void setIdCard(String idCard) { this.idCard = idCard; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getCertificates() { return certificates; }
    public void setCertificates(String certificates) { this.certificates = certificates; }
}
