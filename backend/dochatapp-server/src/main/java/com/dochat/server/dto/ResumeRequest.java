package com.dochat.server.dto;

public class ResumeRequest {
    private String name;
    private String phone;
    private String email;
    private String education;
    private String experience;
    private String skills;
    private String intention;
    private String privacy;
    private String attachment;

    public ResumeRequest() {}

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }

    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getIntention() { return intention; }
    public void setIntention(String intention) { this.intention = intention; }

    public String getPrivacy() { return privacy; }
    public void setPrivacy(String privacy) { this.privacy = privacy; }

    public String getAttachment() { return attachment; }
    public void setAttachment(String attachment) { this.attachment = attachment; }
}
