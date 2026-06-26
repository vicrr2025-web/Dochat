package com.dochat.server.dto;

import com.dochat.server.model.Post;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;

public class PostResponse {

    private static final Gson gson = new Gson();
    private static final Type LIST_STRING_TYPE = new TypeToken<List<String>>(){}.getType();
    private static final DateTimeFormatter ISO_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    private String postId;
    private String userId;
    private String userNickname;
    private String userAvatar;
    private String content;
    private String mediaType;
    private List<String> mediaUrls;
    private Integer mediaDuration;
    private String location;
    private String visibility;
    private int likeCount;
    private int commentCount;
    private int shareCount;
    private boolean isLiked;
    private boolean isFollowing;
    private String createdAt;

    public static PostResponse fromPost(Post post, String userNickname, String userAvatar, boolean isLiked, boolean isFollowing) {
        PostResponse r = new PostResponse();
        r.postId = post.getPostId();
        r.userId = post.getUserId();
        r.userNickname = userNickname;
        r.userAvatar = userAvatar;
        r.content = post.getContent();
        r.mediaType = post.getMediaType();
        try {
            r.mediaUrls = post.getMediaUrls() != null
                ? gson.fromJson(post.getMediaUrls(), LIST_STRING_TYPE)
                : Collections.emptyList();
        } catch (Exception e) {
            r.mediaUrls = Collections.emptyList();
        }
        r.mediaDuration = post.getMediaDuration();
        r.location = post.getLocation();
        r.visibility = post.getVisibility();
        r.likeCount = post.getLikeCount();
        r.commentCount = post.getCommentCount();
        r.shareCount = post.getShareCount();
        r.isLiked = isLiked;
        r.isFollowing = isFollowing;
        r.createdAt = post.getCreatedAt() != null ? post.getCreatedAt().format(ISO_FORMATTER) : null;
        return r;
    }

    public String getPostId() { return postId; }
    public void setPostId(String postId) { this.postId = postId; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserNickname() { return userNickname; }
    public void setUserNickname(String userNickname) { this.userNickname = userNickname; }

    public String getUserAvatar() { return userAvatar; }
    public void setUserAvatar(String userAvatar) { this.userAvatar = userAvatar; }

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

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public int getShareCount() { return shareCount; }
    public void setShareCount(int shareCount) { this.shareCount = shareCount; }

    public boolean getIsLiked() { return isLiked; }
    public void setIsLiked(boolean isLiked) { this.isLiked = isLiked; }

    public boolean getIsFollowing() { return isFollowing; }
    public void setIsFollowing(boolean isFollowing) { this.isFollowing = isFollowing; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
