package com.dochat.server.dto;

import java.math.BigDecimal;

public class CalculatorRequest {

    private BigDecimal totalPrice;
    private BigDecimal downPayment;
    private BigDecimal loanRate;
    private int loanYears;

    public CalculatorRequest() {}

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public BigDecimal getDownPayment() { return downPayment; }
    public void setDownPayment(BigDecimal downPayment) { this.downPayment = downPayment; }

    public BigDecimal getLoanRate() { return loanRate; }
    public void setLoanRate(BigDecimal loanRate) { this.loanRate = loanRate; }

    public int getLoanYears() { return loanYears; }
    public void setLoanYears(int loanYears) { this.loanYears = loanYears; }
}
