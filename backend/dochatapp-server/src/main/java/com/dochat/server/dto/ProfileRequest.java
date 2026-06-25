package com.dochat.server.dto;

public class ProfileRequest {

    private String gender;
    private String birthday;
    private Integer height;
    private String education;
    private String income;
    private String maritalStatus;
    private String avatar;
    private String photos;
    private String tags;
    private String aboutMe;

    public ProfileRequest() {}

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getBirthday() { return birthday; }
    public void setBirthday(String birthday) { this.birthday = birthday; }

    public Integer getHeight() { return height; }
    public void setHeight(Integer height) { this.height = height; }

    public String getEducation() { return education; }
    public void setEducation(String education) { this.education = education; }

    public String getIncome() { return income; }
    public void setIncome(String income) { this.income = income; }

    public String getMaritalStatus() { return maritalStatus; }
    public void setMaritalStatus(String maritalStatus) { this.maritalStatus = maritalStatus; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getPhotos() { return photos; }
    public void setPhotos(String photos) { this.photos = photos; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getAboutMe() { return aboutMe; }
    public void setAboutMe(String aboutMe) { this.aboutMe = aboutMe; }
}
