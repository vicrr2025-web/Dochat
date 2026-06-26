package com.dochat.server.dto;

import java.math.BigDecimal;

public class ExpressOrderRequest {

    private String type;
    private String vehicleType;
    private String originAddress;
    private BigDecimal originLat;
    private BigDecimal originLng;
    private String destAddress;
    private BigDecimal destLat;
    private BigDecimal destLng;
    private String cargoInfo;
    private Boolean insured;

    public ExpressOrderRequest() {}

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }

    public String getOriginAddress() { return originAddress; }
    public void setOriginAddress(String originAddress) { this.originAddress = originAddress; }

    public BigDecimal getOriginLat() { return originLat; }
    public void setOriginLat(BigDecimal originLat) { this.originLat = originLat; }

    public BigDecimal getOriginLng() { return originLng; }
    public void setOriginLng(BigDecimal originLng) { this.originLng = originLng; }

    public String getDestAddress() { return destAddress; }
    public void setDestAddress(String destAddress) { this.destAddress = destAddress; }

    public BigDecimal getDestLat() { return destLat; }
    public void setDestLat(BigDecimal destLat) { this.destLat = destLat; }

    public BigDecimal getDestLng() { return destLng; }
    public void setDestLng(BigDecimal destLng) { this.destLng = destLng; }

    public String getCargoInfo() { return cargoInfo; }
    public void setCargoInfo(String cargoInfo) { this.cargoInfo = cargoInfo; }

    public Boolean getInsured() { return insured; }
    public void setInsured(Boolean insured) { this.insured = insured; }
}
