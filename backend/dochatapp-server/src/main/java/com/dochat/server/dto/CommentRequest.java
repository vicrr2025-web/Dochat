package com.dochat.server.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class CommentRequest {

    @NotBlank(message = "评论内容不能为空")
    @Size(max = 280, message = "评论内容不能超过280字")
    private String content;

    private String parentId;
    private String replyToUserId;

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getParentId() { return parentId; }
    public void setParentId(String parentId) { this.parentId = parentId; }

    public String getReplyToUserId() { return replyToUserId; }
    public void setReplyToUserId(String replyToUserId) { this.replyToUserId = replyToUserId; }
}
