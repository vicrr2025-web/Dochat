package com.dochat.server.dto;

import com.dochat.server.model.Comment;

import java.time.format.DateTimeFormatter;

public class CommentResponse {

    private static final DateTimeFormatter ISO_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    private String commentId;
    private String userId;
    private String userNickname;
    private String userAvatar;
    private String content;
    private int likeCount;
    private String parentId;
    private String replyToUserId;
    private String createdAt;

    public static CommentResponse fromComment(Comment comment, String userNickname, String userAvatar) {
        CommentResponse r = new CommentResponse();
        r.commentId = comment.getCommentId();
        r.userId = comment.getUserId();
        r.userNickname = userNickname;
        r.userAvatar = userAvatar;
        r.content = comment.getContent();
        r.likeCount = comment.getLikeCount();
        r.parentId = comment.getParentId();
        r.replyToUserId = comment.getReplyToUserId();
        r.createdAt = comment.getCreatedAt() != null ? comment.getCreatedAt().format(ISO_FORMATTER) : null;
        return r;
    }

    public String getCommentId() { return commentId; }
    public void setCommentId(String commentId) { this.commentId = commentId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserNickname() { return userNickname; }
    public void setUserNickname(String userNickname) { this.userNickname = userNickname; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }

    public String getReplyToUserId() { return replyToUserId; }
    public void setReplyToUserId(String replyToUserId) { this.replyToUserId = replyToUserId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
