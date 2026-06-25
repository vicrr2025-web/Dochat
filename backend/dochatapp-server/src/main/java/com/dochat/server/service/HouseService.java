package com.dochat.server.service;

import com.dochat.server.dto.AppointmentRequest;
import com.dochat.server.dto.CalculatorRequest;
import com.dochat.server.dto.HouseListResponse;
import com.dochat.server.dto.HouseRequest;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class HouseService {

    private final HouseRepository houseRepository;
    private final HouseAppointmentRepository houseAppointmentRepository;
    private final HouseFavoriteRepository houseFavoriteRepository;
    private final HouseEvaluationRepository houseEvaluationRepository;
    private final HouseVipRepository houseVipRepository;

    public HouseService(HouseRepository houseRepository,
                        HouseAppointmentRepository houseAppointmentRepository,
                        HouseFavoriteRepository houseFavoriteRepository,
                        HouseEvaluationRepository houseEvaluationRepository,
                        HouseVipRepository houseVipRepository) {
        this.houseRepository = houseRepository;
        this.houseAppointmentRepository = houseAppointmentRepository;
        this.houseFavoriteRepository = houseFavoriteRepository;
        this.houseEvaluationRepository = houseEvaluationRepository;
        this.houseVipRepository = houseVipRepository;
    }

    // === 1. getNewHouses ===
    public HouseListResponse getNewHouses(int page, int size, String region) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<House> result;
        if (region != null && !region.isEmpty()) {
            result = houseRepository.findByTypeAndAddressContaining("new", region, pageable);
            if (result.isEmpty()) {
                generateMockHouses(15, "new");
                result = houseRepository.findByTypeAndAddressContaining("new", region, pageable);
            }
        } else {
            result = houseRepository.findByType("new", pageable);
            if (result.isEmpty()) {
                generateMockHouses(15, "new");
                result = houseRepository.findByType("new", pageable);
            }
        }
        return new HouseListResponse(result.getContent(), page, size, result.getTotalElements());
    }

    // === 2. getSecondHouses ===
    public HouseListResponse getSecondHouses(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<House> result = houseRepository.findByType("second", pageable);
        if (result.isEmpty()) {
            generateMockHouses(20, "second");
            result = houseRepository.findByType("second", pageable);
        }
        return new HouseListResponse(result.getContent(), page, size, result.getTotalElements());
    }

    // === 3. getRentHouses ===
    public HouseListResponse getRentHouses(int page, int size, String subType) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<House> result;
        if (subType != null && !subType.isEmpty()) {
            result = houseRepository.findByTypeAndSubType("rent", subType, pageable);
            if (result.isEmpty()) {
                generateMockHouses(20, "rent");
                result = houseRepository.findByTypeAndSubType("rent", subType, pageable);
            }
        } else {
            result = houseRepository.findByType("rent", pageable);
            if (result.isEmpty()) {
                generateMockHouses(20, "rent");
                result = houseRepository.findByType("rent", pageable);
            }
        }
        return new HouseListResponse(result.getContent(), page, size, result.getTotalElements());
    }

    // === 4. getCommercialHouses ===
    public HouseListResponse getCommercialHouses(int page, int size, String subType) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"));
        Page<House> result;
        if (subType != null && !subType.isEmpty()) {
            result = houseRepository.findByTypeAndSubType("commercial", subType, pageable);
            if (result.isEmpty()) {
                generateMockHouses(10, "commercial");
                result = houseRepository.findByTypeAndSubType("commercial", subType, pageable);
            }
        } else {
            result = houseRepository.findByType("commercial", pageable);
            if (result.isEmpty()) {
                generateMockHouses(10, "commercial");
                result = houseRepository.findByType("commercial", pageable);
            }
        }
        return new HouseListResponse(result.getContent(), page, size, result.getTotalElements());
    }

    // === 5. getHouseDetail ===
    public House getHouseDetail(String houseId) {
        House house = houseRepository.findByHouseId(houseId)
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));
        house.setViewCount(house.getViewCount() + 1);
        houseRepository.save(house);
        return house;
    }

    // === 6. publishHouse ===
    public House publishHouse(String userId, HouseRequest req) {
        House house = new House();
        house.setPublisherId(userId);
        house.setType(req.getType());
        house.setSubType(req.getSubType());
        house.setTitle(req.getTitle());
        house.setDescription(req.getDescription());
        house.setPrice(req.getPrice());
        house.setPriceUnit(req.getPriceUnit());
        house.setArea(req.getArea());
        house.setLayout(req.getLayout());
        house.setFloorInfo(req.getFloorInfo());
        house.setDirection(req.getDirection());
        house.setDecoration(req.getDecoration());
        house.setCommunityName(req.getCommunityName());
        house.setAddress(req.getAddress());
        house.setLongitude(req.getLongitude());
        house.setLatitude(req.getLatitude());
        house.setImages(req.getImages());
        house.setTags(req.getTags());
        house.setStatus("pending");
        return houseRepository.save(house);
    }

    // === 7. addFavorite ===
    @Transactional
    public HouseFavorite addFavorite(String userId, String houseId) {
        House house = houseRepository.findByHouseId(houseId)
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));
        if (houseFavoriteRepository.existsByUserIdAndHouseId(userId, houseId)) {
            throw new RuntimeException("7002:已经收藏过该房源");
        }
        HouseFavorite favorite = new HouseFavorite();
        favorite.setUserId(userId);
        favorite.setHouseId(houseId);
        HouseFavorite saved = houseFavoriteRepository.save(favorite);
        house.setFavoriteCount(house.getFavoriteCount() + 1);
        houseRepository.save(house);
        return saved;
    }

    // === 8. removeFavorite ===
    @Transactional
    public void removeFavorite(String userId, String houseId) {
        HouseFavorite favorite = houseFavoriteRepository.findByUserIdAndHouseId(userId, houseId);
        if (favorite == null) {
            throw new RuntimeException("7003:收藏不存在");
        }
        houseFavoriteRepository.deleteByUserIdAndHouseId(userId, houseId);
        House house = houseRepository.findByHouseId(houseId)
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));
        if (house.getFavoriteCount() > 0) {
            house.setFavoriteCount(house.getFavoriteCount() - 1);
            houseRepository.save(house);
        }
    }

    // === 9. createAppointment ===
    public HouseAppointment createAppointment(String userId, AppointmentRequest req) {
        House house = houseRepository.findByHouseId(req.getHouseId())
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));

        if ("sold".equals(house.getStatus())) {
            throw new RuntimeException("7005:房源已售出/已出租");
        }
        if (!"approved".equals(house.getStatus())) {
            throw new RuntimeException("7006:房源未审核通过");
        }

        HouseAppointment appointment = new HouseAppointment();
        appointment.setUserId(userId);
        appointment.setHouseId(req.getHouseId());
        appointment.setContactName(req.getContactName());
        appointment.setContactPhone(req.getContactPhone());
        appointment.setRemark(req.getRemark());
        appointment.setType(req.getType() != null ? req.getType() : "viewing");
        appointment.setStatus("pending");

        if (req.getAppointmentTime() != null) {
            appointment.setAppointmentTime(LocalDateTime.parse(req.getAppointmentTime()));
        }

        return houseAppointmentRepository.save(appointment);
    }

    // === 10. getAppointments ===
    public List<HouseAppointment> getAppointments(String userId, String type) {
        if (type != null && !type.isEmpty()) {
            return houseAppointmentRepository.findByUserIdAndType(userId, type);
        }
        return houseAppointmentRepository.findByUserId(userId);
    }

    // === 11. calculateMortgage ===
    public Map<String, Object> calculateMortgage(CalculatorRequest req) {
        BigDecimal loanAmount = req.getTotalPrice().subtract(req.getDownPayment());
        BigDecimal monthlyRate = req.getLoanRate().divide(new BigDecimal("1200"), 10, RoundingMode.HALF_UP);
        int months = req.getLoanYears() * 12;

        BigDecimal onePlusR = BigDecimal.ONE.add(monthlyRate);
        BigDecimal pow = onePlusR.pow(months);

        BigDecimal monthlyPayment = loanAmount.multiply(monthlyRate).multiply(pow)
                .divide(pow.subtract(BigDecimal.ONE), 2, RoundingMode.HALF_UP);

        BigDecimal totalPayment = monthlyPayment.multiply(new BigDecimal(months));
        BigDecimal totalInterest = totalPayment.subtract(loanAmount);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("monthlyPayment", monthlyPayment);
        result.put("totalPayment", totalPayment);
        result.put("totalInterest", totalInterest);
        result.put("loanAmount", loanAmount);
        result.put("loanYears", req.getLoanYears());
        return result;
    }

    // === 12. calculateTax ===
    public Map<String, Object> calculateTax(CalculatorRequest req) {
        BigDecimal totalPrice = req.getTotalPrice();
        BigDecimal deedTax = totalPrice.multiply(new BigDecimal("0.015")).setScale(2, RoundingMode.HALF_UP);
        BigDecimal incomeTax = totalPrice.multiply(new BigDecimal("0.01")).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = deedTax.add(incomeTax);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("deedTax", deedTax);
        result.put("incomeTax", incomeTax);
        result.put("total", total);
        result.put("totalPrice", totalPrice);
        return result;
    }

    // === 13. evaluateHouse ===
    public HouseEvaluation evaluateHouse(String userId, String houseInfo) {
        HouseEvaluation evaluation = new HouseEvaluation();
        evaluation.setUserId(userId);
        evaluation.setType("valuation");
        evaluation.setHouseInfo(houseInfo);

        Map<String, Object> evalResult = new LinkedHashMap<>();
        evalResult.put("estimatedPriceMin", 1500000);
        evalResult.put("estimatedPriceMax", 2000000);
        evalResult.put("confidence", "medium");
        evalResult.put("trend", "stable");
        evalResult.put("note", "基于周边同类房源和近期成交数据估算");

        evaluation.setResult(evalResult.toString());
        evaluation.setStatus("completed");
        return houseEvaluationRepository.save(evaluation);
    }

    // === 14. upgradeVip ===
    @Transactional
    public HouseVip upgradeVip(String userId) {
        Optional<HouseVip> existingOpt = houseVipRepository.findByUserId(userId);
        LocalDateTime now = LocalDateTime.now();

        if (existingOpt.isPresent()) {
            HouseVip existing = existingOpt.get();
            if (existing.getExpiresAt() != null && existing.getExpiresAt().isAfter(now)) {
                existing.setExpiresAt(existing.getExpiresAt().plusDays(30));
            } else {
                existing.setExpiresAt(now.plusDays(30));
            }
            existing.setLevel(existing.getLevel() + 1);
            return houseVipRepository.save(existing);
        } else {
            HouseVip vip = new HouseVip();
            vip.setUserId(userId);
            vip.setLevel(1);
            vip.setExpiresAt(now.plusDays(30));
            return houseVipRepository.save(vip);
        }
    }

    // === 15. renovationEstimate ===
    public HouseEvaluation renovationEstimate(String userId, String houseInfo) {
        HouseEvaluation evaluation = new HouseEvaluation();
        evaluation.setUserId(userId);
        evaluation.setType("renovation");
        evaluation.setHouseInfo(houseInfo);

        Map<String, Object> estResult = new LinkedHashMap<>();
        estResult.put("estimatedMin", 50000);
        estResult.put("estimatedMax", 120000);
        estResult.put("suggestions", Arrays.asList(
                "建议全屋翻新",
                "厨房和卫生间重点改造",
                "水电管线建议更新"
        ));

        evaluation.setResult(estResult.toString());
        evaluation.setStatus("completed");
        return houseEvaluationRepository.save(evaluation);
    }

    // === 16. getRenovationCompanies ===
    public List<Map<String, Object>> getRenovationCompanies(int page, int size) {
        List<Map<String, Object>> companies = new ArrayList<>();

        companies.add(createCompany("品质家装", "4.8", Arrays.asList("全屋整装", "局部改造", "厨房卫浴")));
        companies.add(createCompany("安心装修", "4.6", Arrays.asList("新房装修", "旧房翻新", "水电改造")));
        companies.add(createCompany("创意空间", "4.7", Arrays.asList("设计施工", "软装搭配", "智能家居")));
        companies.add(createCompany("瑞家装饰", "4.5", Arrays.asList("经济实惠", "快速施工", "质保服务")));
        companies.add(createCompany("精工装潢", "4.9", Arrays.asList("高端定制", "别墅装修", "商业空间")));

        return companies;
    }

    // === 17. getCommunityInfo ===
    public Map<String, Object> getCommunityInfo(String houseId) {
        House house = houseRepository.findByHouseId(houseId)
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));

        Map<String, Object> info = new LinkedHashMap<>();
        info.put("communityName", house.getCommunityName() != null ? house.getCommunityName() : "未知小区");
        info.put("builtYear", 2015);
        info.put("greenRate", "35%");
        info.put("propertyFee", "2.8元/㎡/月");
        info.put("totalBuildings", 12);
        info.put("totalHouses", 1800);
        info.put("parkingRate", "1:1.2");
        info.put("facilities", Arrays.asList("健身房", "游泳池", "儿童乐园", "篮球场"));
        info.put("nearby", Arrays.asList("地铁站500m", "大型商超300m", "三甲医院1km", "重点小学800m"));
        return info;
    }

    // === 18. sendChatMessage ===
    public Map<String, Object> sendChatMessage(String userId, String houseId, String content) {
        House house = houseRepository.findByHouseId(houseId)
                .orElseThrow(() -> new RuntimeException("7001:房源不存在"));

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("sessionId", "mock-sid-" + UUID.randomUUID().toString().substring(0, 8));
        result.put("messageId", "mock-mid-" + UUID.randomUUID().toString().substring(0, 8));
        result.put("content", content);
        result.put("from", userId);
        result.put("to", house.getPublisherId());
        return result;
    }

    // === Mock data generators ===
    private void generateMockHouses(int count, String type) {
        String[][] mockData;
        switch (type) {
            case "new":
                mockData = new String[][]{
                    {"碧桂园翡翠湾", "3室2厅", "南", "精装修", "1800000"},
                    {"万科城市花园", "2室1厅", "南", "简装修", "1200000"},
                    {"恒大绿洲", "4室2厅", "南北", "毛坯", "2500000"},
                    {"保利天悦", "3室2厅", "南北", "精装修", "3200000"},
                    {"中海国际社区", "2室2厅", "南", "精装修", "1500000"},
                };
                break;
            case "second":
                mockData = new String[][]{
                    {"老城区花园小区", "2室1厅", "南", "简装修", "800000"},
                    {"学府雅苑", "3室2厅", "南北", "精装修", "1600000"},
                    {"阳光新都", "1室1厅", "东", "精装修", "550000"},
                    {"翠苑新村", "2室2厅", "南", "简装修", "950000"},
                };
                break;
            case "rent":
                mockData = new String[][]{
                    {"青年公寓", "1室0厅", "南", "精装修", "2500"},
                    {"温馨家园", "2室1厅", "南北", "简装修", "3500"},
                    {"花园洋房", "3室2厅", "南", "精装修", "6000"},
                    {"城市中心", "1室1厅", "东", "精装修", "3000"},
                };
                break;
            case "commercial":
                mockData = new String[][]{
                    {"中央商务中心", "写字楼", "南", "精装修", "5000000"},
                    {"产业园A区", "厂房", "南", "简装修", "8000000"},
                    {"物流仓库中心", "仓库", "南", "简装修", "3000000"},
                };
                break;
            default:
                mockData = new String[][]{
                    {"默认房源", "2室1厅", "南", "简装修", "1000000"},
                };
        }

        String[] imageUrls = new String[]{
            "https://img.zcool.cn/community/01f5e95e5a0e06a80121985d22a73e.jpg",
            "https://img.zcool.cn/community/0177a65e5a0df6a80121985d0e5df0.jpg",
            "https://img.zcool.cn/community/01f5e95e5a0e06a80121985d22a73e.jpg"
        };

        String[] tags = new String[]{"地铁房", "学区房", "精装修", "满五唯一"};

        for (int i = 0; i < count; i++) {
            String[] data = mockData[i % mockData.length];
            House house = new House();
            house.setPublisherId("system");
            house.setType(type);
            house.setSubType(type.equals("commercial") ? "商铺" : "整租");
            house.setTitle(data[0] + "-" + (i + 1) + "号");
            house.setDescription("优质" + type + "房源，" + data[0] + "，交通便利，周边配套齐全");
            house.setPrice(new BigDecimal(data[4]));
            house.setPriceUnit(type.equals("rent") ? "元/月" : "元");
            house.setArea(new BigDecimal(80 + i * 10));
            house.setLayout(data[1]);
            house.setDirection(data[2]);
            house.setDecoration(data[3]);
            house.setFloorInfo((i % 20 + 1) + "/28层");
            house.setCommunityName(data[0]);
            house.setAddress("XX市XX区XX路" + (100 + i) + "号");
            house.setLongitude(new BigDecimal("116.397" + i));
            house.setLatitude(new BigDecimal("39.908" + i));
            house.setImages(String.join(",", imageUrls));
            house.setTags(String.join(",", tags));
            house.setStatus("approved");
            house.setViewCount(new Random().nextInt(500));
            house.setFavoriteCount(new Random().nextInt(100));
            houseRepository.save(house);
        }
    }

    private Map<String, Object> createCompany(String name, String rating, List<String> services) {
        Map<String, Object> company = new LinkedHashMap<>();
        company.put("name", name);
        company.put("rating", rating);
        company.put("services", services);
        return company;
    }
}
