package com.dochat.server.dto;

import jakarta.validation.constraints.Size;
import java.util.List;

public class PostRequest {

    @Size(max = 140, message = "文字内容不能超过140字")
    private String content;

    private String mediaType;

    @Size(max = 9, message = "图片最多9张")
    private List<String> mediaUrls;

    private Integer mediaDuration;

    private String location;

    private String visibility;

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getMediaType() { return mediaType; }
    public void setMediaType(String mediaType) { this.mediaType = mediaType; }

    public List<String> getMediaUrls() { return mediaUrls; }
    public void setMediaUrls(List<String> mediaUrls) { this.mediaUrls = mediaUrls; }

    public Integer getMediaDuration() { return mediaDuration; }
    public void setMediaDuration(Integer mediaDuration) { this.mediaDuration = mediaDuration; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getVisibility() { return visibility; }
    public void setVisibility(String visibility) { this.visibility = visibility; }
}
