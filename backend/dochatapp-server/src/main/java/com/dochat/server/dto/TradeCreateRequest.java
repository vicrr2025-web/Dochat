package com.dochat.server.dto;

import java.math.BigDecimal;

public class TradeCreateRequest {

    private String productName;
    private String productDesc;
    private BigDecimal amount;
    private String counterpartyId;

    public TradeCreateRequest() {}

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductDesc() { return productDesc; }
    public void setProductDesc(String productDesc) { this.productDesc = productDesc; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getCounterpartyId() { return counterpartyId; }
    public void setCounterpartyId(String counterpartyId) { this.counterpartyId = counterpartyId; }
}
