package com.dochat.server.dto;

public class MarkRequest {

    private String messageId;
    private String action;

    public MarkRequest() {}

    public String getMessageId() { return messageId; }
    public void setMessageId(String messageId) { this.messageId = messageId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
}
