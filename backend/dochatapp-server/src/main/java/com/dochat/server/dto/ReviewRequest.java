package com.dochat.server.dto;

public class ReviewRequest {
    private String orderId;
    private int rating;
    private String content;

    public ReviewRequest() {}

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}
