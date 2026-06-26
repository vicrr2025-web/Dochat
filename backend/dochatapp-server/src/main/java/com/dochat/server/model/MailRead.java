package com.dochat.server.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "mail_reads")
public class MailRead {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "read_id", nullable = false, unique = true, length = 16)
    private String readId;

    @Column(name = "user_id", nullable = false, length = 32)
    private String userId;

    @Column(name = "article_id", length = 64)
    private String articleId;

    @Column(length = 256)
    private String title;

    @Column(length = 64)
    private String source;

    @Column(length = 512)
    private String url;

    @Column(name = "is_favorited")
    private Boolean isFavorited = false;

    @Column(name = "read_at")
    private LocalDateTime readAt;

    @PrePersist
    protected void onCreate() {
        if (this.readAt == null) {
            this.readAt = LocalDateTime.now();
        }
        if (this.readId == null) {
            this.readId = UUID.randomUUID().toString().substring(0, 16);
        }
    }

    public MailRead() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getReadId() { return readId; }
    public void setReadId(String readId) { this.readId = readId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getArticleId() { return articleId; }
    public void setArticleId(String articleId) { this.articleId = articleId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public Boolean getIsFavorited() { return isFavorited; }
    public void setIsFavorited(Boolean isFavorited) { this.isFavorited = isFavorited; }

    public LocalDateTime getReadAt() { return readAt; }
    public void setReadAt(LocalDateTime readAt) { this.readAt = readAt; }
}
