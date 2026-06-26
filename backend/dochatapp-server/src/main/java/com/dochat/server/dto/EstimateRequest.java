package com.dochat.server.dto;

import java.math.BigDecimal;

public class EstimateRequest {

    private BigDecimal originLat;
    private BigDecimal originLng;
    private BigDecimal destLat;
    private BigDecimal destLng;
    private String type;
    private String vehicleType;

    public EstimateRequest() {}

    public BigDecimal getOriginLat() { return originLat; }
    public void setOriginLat(BigDecimal originLat) { this.originLat = originLat; }

    public BigDecimal getOriginLng() { return originLng; }
    public void setOriginLng(BigDecimal originLng) { this.originLng = originLng; }

    public BigDecimal getDestLat() { return destLat; }
    public void setDestLat(BigDecimal destLat) { this.destLat = destLat; }

    public BigDecimal getDestLng() { return destLng; }
    public void setDestLng(BigDecimal destLng) { this.destLng = destLng; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
}
