package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "dating_profiles")
public class DatingProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String profileId;

    @Column(nullable = false, unique = true)
    private String userId;

    @Column(length = 10)
    private String gender;

    private LocalDate birthday;

    private Integer height;

    @Column(length = 32)
    private String education;

    @Column(length = 32)
    private String income;

    @Column(length = 32)
    private String maritalStatus;

    @Column(length = 512)
    private String avatar;

    @Column(columnDefinition = "TEXT")
    private String photos;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @Column(columnDefinition = "TEXT")
    private String aboutMe;

    @Column(nullable = false)
    private boolean realVerified = false;

    @Column(nullable = false)
    private boolean workVerified = false;

    @Column(nullable = false)
    private boolean eduVerified = false;

    @Column(nullable = false)
    private int charmValue = 0;

    @Column(nullable = false)
    private int loveCoin = 0;

    @Column(nullable = false)
    private int vipLevel = 0;

    private LocalDateTime vipExpiresAt;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public DatingProfile() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getProfileId() { return profileId; }
    public void setProfileId(String profileId) { this.profileId = profileId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public LocalDate getBirthday() { return birthday; }
    public void setBirthday(LocalDate birthday) { this.birthday = birthday; }

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

    public boolean isRealVerified() { return realVerified; }
    public void setRealVerified(boolean realVerified) { this.realVerified = realVerified; }

    public boolean isWorkVerified() { return workVerified; }
    public void setWorkVerified(boolean workVerified) { this.workVerified = workVerified; }

    public boolean isEduVerified() { return eduVerified; }
    public void setEduVerified(boolean eduVerified) { this.eduVerified = eduVerified; }

    public int getCharmValue() { return charmValue; }
    public void setCharmValue(int charmValue) { this.charmValue = charmValue; }

    public int getLoveCoin() { return loveCoin; }
    public void setLoveCoin(int loveCoin) { this.loveCoin = loveCoin; }

    public int getVipLevel() { return vipLevel; }
    public void setVipLevel(int vipLevel) { this.vipLevel = vipLevel; }

    public LocalDateTime getVipExpiresAt() { return vipExpiresAt; }
    public void setVipExpiresAt(LocalDateTime vipExpiresAt) { this.vipExpiresAt = vipExpiresAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
