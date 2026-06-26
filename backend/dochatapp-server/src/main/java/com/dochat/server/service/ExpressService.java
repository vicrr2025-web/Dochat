package com.dochat.server.service;

import com.dochat.server.dto.*;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.*;

@Service
public class ExpressService {

    private static final Logger log = LoggerFactory.getLogger(ExpressService.class);

    private final ExpressOrderRepository orderRepository;
    private final ExpressDriverRepository driverRepository;
    private final ExpressLocationRepository locationRepository;
    private final ExpressDisputeRepository disputeRepository;
    private final ExpressInsuranceRepository insuranceRepository;
    private final ExpressWithdrawalRepository withdrawalRepository;

    public ExpressService(ExpressOrderRepository orderRepository,
                          ExpressDriverRepository driverRepository,
                          ExpressLocationRepository locationRepository,
                          ExpressDisputeRepository disputeRepository,
                          ExpressInsuranceRepository insuranceRepository,
                          ExpressWithdrawalRepository withdrawalRepository) {
        this.orderRepository = orderRepository;
        this.driverRepository = driverRepository;
        this.locationRepository = locationRepository;
        this.disputeRepository = disputeRepository;
        this.insuranceRepository = insuranceRepository;
        this.withdrawalRepository = withdrawalRepository;
    }

    public ExpressOrder createOrder(String userId, ExpressOrderRequest request) {
        ExpressOrder order = new ExpressOrder();
        order.setUserId(userId);
        order.setType(request.getType());
        order.setVehicleType(request.getVehicleType());
        order.setOriginAddress(request.getOriginAddress());
        order.setOriginLat(request.getOriginLat());
        order.setOriginLng(request.getOriginLng());
        order.setDestAddress(request.getDestAddress());
        order.setDestLat(request.getDestLat());
        order.setDestLng(request.getDestLng());
        order.setCargoInfo(request.getCargoInfo());
        order.setInsured(request.getInsured());

        double distance = calculateDistance(
                request.getOriginLat(), request.getOriginLng(),
                request.getDestLat(), request.getDestLng());
        BigDecimal price = calculatePriceByType(order.getType(), distance);
        order.setEstimatedPrice(price);

        if (Boolean.TRUE.equals(request.getInsured())) {
            BigDecimal insuranceFee = price.multiply(new BigDecimal("0.05")).setScale(2, RoundingMode.HALF_UP);
            order.setInsuranceFee(insuranceFee);
            ExpressInsurance insurance = new ExpressInsurance();
            insurance.setOrderId(order.getOrderId());
            insurance.setUserId(userId);
            insurance.setFee(insuranceFee);
            insurance.setCoverage(price.multiply(new BigDecimal("10")));
            insuranceRepository.save(insurance);
        }

        order = orderRepository.save(order);

        // Mock: auto-match driver after 2s
        mockAutoMatch(order);

        log.info("Express order created: orderId={}, userId={}, type={}", order.getOrderId(), userId, order.getType());
        return order;
    }

    private void mockAutoMatch(ExpressOrder order) {
        new Thread(() -> {
            try {
                Thread.sleep(2000);
                Optional<ExpressOrder> opt = orderRepository.findByOrderId(order.getOrderId());
                if (opt.isPresent() && "pending".equals(opt.get().getStatus())) {
                    ExpressOrder o = opt.get();
                    o.setDriverId("DRV_AUTO_MATCH");
                    o.setStatus("accepted");
                    orderRepository.save(o);
                    log.info("Mock auto-matched driver for orderId={}", o.getOrderId());
                }
            } catch (InterruptedException ignored) {}
        }).start();
    }

    private double calculateDistance(BigDecimal lat1, BigDecimal lng1, BigDecimal lat2, BigDecimal lng2) {
        if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) return 5.0;
        double dLat = Math.toRadians(lat2.doubleValue() - lat1.doubleValue());
        double dLng = Math.toRadians(lng2.doubleValue() - lng1.doubleValue());
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(lat1.doubleValue())) * Math.cos(Math.toRadians(lat2.doubleValue())) *
                        Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double dist = 6371 * c;
        return Math.max(dist, 0.5);
    }

    private BigDecimal calculatePriceByType(String type, double distanceKm) {
        double unitPrice;
        switch (type != null ? type : "taxi") {
            case "errand": unitPrice = 5.0; break;
            case "freight": unitPrice = 8.0; break;
            default: unitPrice = 2.0; break;
        }
        return new BigDecimal(unitPrice * distanceKm, new MathContext(12, RoundingMode.HALF_UP)).setScale(2, RoundingMode.HALF_UP);
    }

    public Page<ExpressOrder> getOrders(String userId, String role, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<ExpressOrder> result;
        if ("driver".equals(role)) {
            Optional<ExpressDriver> driverOpt = driverRepository.findByUserId(userId);
            if (driverOpt.isPresent()) {
                result = orderRepository.findByDriverId(driverOpt.get().getDriverId(), pageable);
            } else {
                result = Page.empty();
            }
        } else {
            result = orderRepository.findByUserId(userId, pageable);
        }
        if (result.isEmpty()) {
            mockOrders(userId, role);
            if ("driver".equals(role)) {
                Optional<ExpressDriver> driverOpt = driverRepository.findByUserId(userId);
                if (driverOpt.isPresent()) {
                    result = orderRepository.findByDriverId(driverOpt.get().getDriverId(), pageable);
                }
            } else {
                result = orderRepository.findByUserId(userId, pageable);
            }
        }
        return result;
    }

    private void mockOrders(String userId, String role) {
        String[][] mockData = {
            {"express", "small_truck", "北京市朝阳区建国路88号", "39.9087", "116.4714", "北京市海淀区中关村大街1号", "39.9836", "116.3168", "文件资料"},
            {"express", "motorcycle", "上海市浦东新区陆家嘴环路100号", "31.2357", "121.5016", "上海市徐汇区衡山路10号", "31.2086", "121.4447", "外卖餐食"},
            {"freight", "medium_truck", "广州市天河区体育西路111号", "23.1291", "113.3239", "深圳市南山区科技园南路1号", "22.5431", "113.9498", "电子设备一批"},
            {"express", "small_truck", "成都市锦江区春熙路99号", "30.6598", "104.0832", "成都市武侯区天府大道北段1号", "30.5608", "104.0657", "服装包裹"},
            {"freight", "large_truck", "武汉市洪山区珞喻路1037号", "30.5148", "114.4118", "长沙市岳麓区麓山南路932号", "28.1788", "112.9427", "家具大件"},
        };
        for (String[] d : mockData) {
            ExpressOrder order = new ExpressOrder();
            order.setUserId(userId);
            order.setType(d[0]);
            order.setVehicleType(d[1]);
            order.setOriginAddress(d[2]);
            order.setOriginLat(new BigDecimal(d[3]));
            order.setOriginLng(new BigDecimal(d[4]));
            order.setDestAddress(d[5]);
            order.setDestLat(new BigDecimal(d[6]));
            order.setDestLng(new BigDecimal(d[7]));
            order.setCargoInfo(d[8]);
            order.setEstimatedPrice(new BigDecimal("45.00"));
            order.setStatus("pending");
            orderRepository.save(order);
        }
    }

    public Map<String, Object> getOrderDetail(String userId, String orderId) {
        ExpressOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new ExpressServiceException(10001, "订单不存在"));
        List<ExpressLocation> locations = locationRepository.findByOrderIdOrderByRecordedAtDesc(orderId);
        Map<String, Object> detail = new LinkedHashMap<>();
        detail.put("order", order);
        detail.put("locations", locations);
        return detail;
    }

    public ExpressOrder acceptOrder(String userId, String orderId) {
        ExpressDriver driver = driverRepository.findByUserId(userId)
                .orElseThrow(() -> new ExpressServiceException(10002, "司机未注册"));
        ExpressOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new ExpressServiceException(10001, "订单不存在"));
        if (!"pending".equals(order.getStatus())) {
            if ("accepted".equals(order.getStatus())) {
                throw new ExpressServiceException(10004, "司机已接单");
            }
            if ("cancelled".equals(order.getStatus())) {
                throw new ExpressServiceException(10005, "用户已取消");
            }
            throw new ExpressServiceException(10003, "订单状态不允许接单");
        }
        order.setDriverId(driver.getDriverId());
        order.setStatus("accepted");
        return orderRepository.save(order);
    }

    public ExpressLocation updateLocation(String userId, String orderId, BigDecimal lat, BigDecimal lng) {
        ExpressLocation location = new ExpressLocation();
        location.setOrderId(orderId);
        location.setLat(lat);
        location.setLng(lng);
        location = locationRepository.save(location);
        log.info("Location updated for orderId={}, lat={}, lng={}", orderId, lat, lng);
        return location;
    }

    public ExpressOrder completeOrder(String userId, String orderId, BigDecimal actualPrice) {
        ExpressDriver driver = driverRepository.findByUserId(userId)
                .orElseThrow(() -> new ExpressServiceException(10002, "司机未注册"));
        ExpressOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new ExpressServiceException(10001, "订单不存在"));
        if (!driver.getDriverId().equals(order.getDriverId())) {
            throw new ExpressServiceException(10006, "该订单不属于此司机");
        }
        order.setStatus("completed");
        order.setActualPrice(actualPrice);
        order = orderRepository.save(order);

        driver.setTotalIncome(driver.getTotalIncome().add(actualPrice != null ? actualPrice : BigDecimal.ZERO));
        driver.setBalance(driver.getBalance().add(actualPrice != null ? actualPrice : BigDecimal.ZERO));
        driverRepository.save(driver);

        return order;
    }

    public Map<String, Object> estimatePrice(EstimateRequest request) {
        double distance = calculateDistance(
                request.getOriginLat(), request.getOriginLng(),
                request.getDestLat(), request.getDestLng());
        BigDecimal price = calculatePriceByType(request.getType(), distance);
        int durationMinutes = (int) Math.ceil(distance / 30.0 * 60);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("estimatedPrice", price);
        result.put("distance", new BigDecimal(distance).setScale(2, RoundingMode.HALF_UP));
        result.put("duration", durationMinutes);
        return result;
    }

    public ExpressDriver registerDriver(String userId, DriverRegisterRequest request) {
        Optional<ExpressDriver> existing = driverRepository.findByUserId(userId);
        if (existing.isPresent()) {
            throw new ExpressServiceException(10007, "司机已注册");
        }
        ExpressDriver driver = new ExpressDriver();
        driver.setUserId(userId);
        driver.setName(request.getName());
        driver.setPhone(request.getPhone());
        driver.setIdCard(request.getIdCard());
        driver.setLicenseNo(request.getLicenseNo());
        driver.setVehicleType(request.getVehicleType());
        driver.setVehiclePlate(request.getVehiclePlate());
        driver.setVehicleInfo(request.getVehicleInfo());
        // Mock: auto approve
        driver.setAuthStatus("approved");
        driver.setStatus("online");
        return driverRepository.save(driver);
    }

    public Map<String, Object> getDriverIncome(String userId) {
        ExpressDriver driver = driverRepository.findByUserId(userId)
                .orElseThrow(() -> new ExpressServiceException(10002, "司机未注册"));

        // Mock today income
        BigDecimal todayIncome = driver.getTotalIncome().multiply(new BigDecimal("0.15")).setScale(2, RoundingMode.HALF_UP);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("totalIncome", driver.getTotalIncome());
        result.put("balance", driver.getBalance());
        result.put("todayIncome", todayIncome);
        return result;
    }

    public ExpressWithdrawal withdraw(String userId, BigDecimal amount, String bankAccount) {
        ExpressDriver driver = driverRepository.findByUserId(userId)
                .orElseThrow(() -> new ExpressServiceException(10002, "司机未注册"));
        if (driver.getBalance().compareTo(amount) < 0) {
            throw new ExpressServiceException(10009, "余额不足");
        }
        driver.setBalance(driver.getBalance().subtract(amount));
        driverRepository.save(driver);

        ExpressWithdrawal withdrawal = new ExpressWithdrawal();
        withdrawal.setDriverId(driver.getDriverId());
        withdrawal.setAmount(amount);
        withdrawal.setBankAccount(bankAccount);
        // Mock: auto success
        withdrawal.setStatus("success");
        return withdrawalRepository.save(withdrawal);
    }

    public ExpressDriver updateDriverStatus(String userId, String status) {
        ExpressDriver driver = driverRepository.findByUserId(userId)
                .orElseThrow(() -> new ExpressServiceException(10002, "司机未注册"));
        driver.setStatus(status);
        return driverRepository.save(driver);
    }
    
    public ExpressOrder cancelOrder(String userId, String orderId) {
        ExpressOrder order = orderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new ExpressServiceException(10001, "订单不存在"));
        if (!"pending".equals(order.getStatus()) && !"accepted".equals(order.getStatus())) {
            throw new ExpressServiceException(10003, "订单状态不允许取消");
        }
        order.setStatus("cancelled");
        return orderRepository.save(order);
    }

    public ExpressDispute createDispute(String userId, ExpressDisputeRequest request) {
        ExpressOrder order = orderRepository.findByOrderId(request.getOrderId())
                .orElseThrow(() -> new ExpressServiceException(10001, "订单不存在"));

        ExpressDispute dispute = new ExpressDispute();
        dispute.setOrderId(request.getOrderId());
        dispute.setInitiatorId(userId);
        dispute.setReason(request.getReason());

        order.setStatus("disputed");
        orderRepository.save(order);

        return disputeRepository.save(dispute);
    }

    public ExpressDispute submitEvidence(String userId, String disputeId, String evidence) {
        ExpressDispute dispute = disputeRepository.findByDisputeId(disputeId)
                .orElseThrow(() -> new ExpressServiceException(10001, "争议不存在"));
        dispute.setEvidence(evidence);
        return disputeRepository.save(dispute);
    }

    public Map<String, Object> getJuryStatus(String disputeId) {
        ExpressDispute dispute = disputeRepository.findByDisputeId(disputeId)
                .orElseThrow(() -> new ExpressServiceException(10001, "争议不存在"));

        // Mock: randomize votes for demo
        Random random = new Random();
        dispute.setJuryVotesFor(random.nextInt(18));
        dispute.setJuryVotesAgainst(17 - dispute.getJuryVotesFor());

        if (dispute.getJuryVotesFor() > 10) {
            dispute.setVerdict("for_user");
        } else if (dispute.getJuryVotesAgainst() > 10) {
            dispute.setVerdict("for_driver");
        } else {
            dispute.setVerdict("pending");
        }
        disputeRepository.save(dispute);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("juryVotesFor", dispute.getJuryVotesFor());
        result.put("juryVotesAgainst", dispute.getJuryVotesAgainst());
        result.put("totalJurors", dispute.getTotalJurors());
        result.put("verdict", dispute.getVerdict());
        return result;
    }

    public static class ExpressServiceException extends RuntimeException {
        private final int code;

        public ExpressServiceException(int code, String message) {
            super(message);
            this.code = code;
        }

        public int getCode() { return code; }
    }
}
