package com.dochat.server.dto;

import java.math.BigDecimal;

public class HouseRequest {

    private String type;
    private String subType;
    private String title;
    private String description;
    private BigDecimal price;
    private String priceUnit;
    private BigDecimal area;
    private String layout;
    private String floorInfo;
    private String direction;
    private String decoration;
    private String communityName;
    private String address;
    private BigDecimal longitude;
    private BigDecimal latitude;
    private String images;
    private String tags;

    public HouseRequest() {}

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getSubType() { return subType; }
    public void setSubType(String subType) { this.subType = subType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getPriceUnit() { return priceUnit; }
    public void setPriceUnit(String priceUnit) { this.priceUnit = priceUnit; }

    public BigDecimal getArea() { return area; }
    public void setArea(BigDecimal area) { this.area = area; }

    public String getLayout() { return layout; }
    public void setLayout(String layout) { this.layout = layout; }

    public String getFloorInfo() { return floorInfo; }
    public void setFloorInfo(String floorInfo) { this.floorInfo = floorInfo; }

    public String getDirection() { return direction; }
    public void setDirection(String direction) { this.direction = direction; }

    public String getDecoration() { return decoration; }
    public void setDecoration(String decoration) { this.decoration = decoration; }

    public String getCommunityName() { return communityName; }
    public void setCommunityName(String communityName) { this.communityName = communityName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }

    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }

    public String getImages() { return images; }
    public void setImages(String images) { this.images = images; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }
}
