package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "job_companies")
public class JobCompany {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String companyId;

    @Column(nullable = false, unique = true, length = 32)
    private String userId;

    @Column(nullable = false, length = 128)
    private String name;

    @Column(length = 500)
    private String logo;

    @Column(length = 32)
    private String industry;

    @Column(length = 32)
    private String scale;

    @Column(length = 200)
    private String address;

    @Column(length = 500)
    private String licenseUrl;

    @Column(nullable = false, length = 20)
    private String authStatus = "pending";

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.companyId == null) {
            this.companyId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
    }

    public JobCompany() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }

    public String getScale() { return scale; }
    public void setScale(String scale) { this.scale = scale; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getLicenseUrl() { return licenseUrl; }
    public void setLicenseUrl(String licenseUrl) { this.licenseUrl = licenseUrl; }

    public String getAuthStatus() { return authStatus; }
    public void setAuthStatus(String authStatus) { this.authStatus = authStatus; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
