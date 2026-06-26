package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "home_categories")
public class HomeCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String categoryId;

    @Column(length = 16)
    private String parentId;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false)
    private Integer level = 1;

    @Column(length = 100)
    private String icon;

    @Column(nullable = false)
    private Integer sortOrder = 0;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.categoryId == null) {
            this.categoryId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        }
        if (this.level == null) {
            this.level = 1;
        }
        if (this.sortOrder == null) {
            this.sortOrder = 0;
        }
    }

    public HomeCategory() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }

    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getLevel() { return level; }
    public void setLevel(Integer level) { this.level = level; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
