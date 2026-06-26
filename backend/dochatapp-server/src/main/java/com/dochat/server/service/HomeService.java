package com.dochat.server.service;

import com.dochat.server.dto.HomeOrderRequest;
import com.dochat.server.dto.HomeWorkerRegisterRequest;
import com.dochat.server.model.*;
import com.dochat.server.repository.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class HomeService {

    private final HomeServiceRepository homeServiceRepository;
    private final HomeOrderRepository homeOrderRepository;
    private final HomeWorkerRepository homeWorkerRepository;
    private final HomeFavoriteRepository homeFavoriteRepository;
    private final HomeDisputeRepository homeDisputeRepository;
    private final HomeTrainingRepository homeTrainingRepository;
    private final HomeCategoryRepository homeCategoryRepository;

    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public HomeService(HomeServiceRepository homeServiceRepository,
                       HomeOrderRepository homeOrderRepository,
                       HomeWorkerRepository homeWorkerRepository,
                       HomeFavoriteRepository homeFavoriteRepository,
                       HomeDisputeRepository homeDisputeRepository,
                       HomeTrainingRepository homeTrainingRepository,
                       HomeCategoryRepository homeCategoryRepository) {
        this.homeServiceRepository = homeServiceRepository;
        this.homeOrderRepository = homeOrderRepository;
        this.homeWorkerRepository = homeWorkerRepository;
        this.homeFavoriteRepository = homeFavoriteRepository;
        this.homeDisputeRepository = homeDisputeRepository;
        this.homeTrainingRepository = homeTrainingRepository;
        this.homeCategoryRepository = homeCategoryRepository;
    }

    // 1. getServices
    public Page<com.dochat.server.model.HomeService> getServices(int page, int size, String categoryId) {
        Pageable pageable = PageRequest.of(page, size);
        Page<com.dochat.server.model.HomeService> services = homeServiceRepository.findByStatus("active", pageable);
        if (services.isEmpty()) {
            mockServices();
            services = homeServiceRepository.findByStatus("active", pageable);
        }
        return services;
    }

    private void mockServices() {
        String[][] mockData = {
            {"管道疏通", "专业疏通下水道、马桶、地漏", "fixed", "80", "次", "管道,疏通"},
            {"空调清洗", "深度清洗空调内机，杀菌消毒", "fixed", "120", "台", "空调,清洗"},
            {"开锁换锁", "专业开锁、换锁芯、安装门锁", "fixed", "100", "次", "开锁,换锁"},
            {"家电维修", "冰箱、洗衣机、热水器维修", "negotiable", "0", "次", "维修,家电"},
            {"墙面翻新", "旧墙翻新、补洞、刷漆", "fixed", "25", "㎡", "翻新,墙面"},
            {"电路维修", "跳闸修复、线路更换、开关安装", "fixed", "60", "次", "电路,维修"},
            {"搬家服务", "居民搬家、公司搬迁", "negotiable", "0", "次", "搬家,搬运"},
            {"家具组装", "宜家家具组装、定制安装", "fixed", "50", "件", "组装,家具"},
            {"清洁保洁", "家庭日常保洁、深度清洁", "hourly", "40", "小时", "清洁,保洁"},
            {"防水补漏", "屋顶、卫生间防水补漏", "fixed", "200", "处", "防水,补漏"},
            {"瓷砖铺贴", "墙地砖铺贴、美缝", "fixed", "45", "㎡", "瓷砖,装修"},
            {"油烟机清洗", "拆机深度清洗油烟机", "fixed", "150", "台", "油烟机,清洗"},
            {"电脑维修", "系统重装、清灰、硬件升级", "fixed", "80", "次", "电脑,维修"},
            {"水龙头维修", "更换水龙头、软管、角阀", "fixed", "50", "个", "水龙头,维修"},
            {"门窗维修", "铝合金门窗调整、更换滑轮", "fixed", "80", "扇", "门窗,维修"},
            {"地板安装", "复合地板、实木地板安装", "fixed", "30", "㎡", "地板,安装"},
            {"热水器安装", "电热水器、燃气热水器安装", "fixed", "200", "台", "热水器,安装"},
            {"灯具安装", "吸顶灯、射灯、吊灯安装", "fixed", "40", "个", "灯具,安装"},
            {"窗帘安装", "窗帘轨道、罗马杆安装", "fixed", "50", "窗", "窗帘,安装"},
            {"衣柜维修", "衣柜门调整、抽屉维修", "fixed", "60", "次", "衣柜,维修"},
        };
        for (String[] d : mockData) {
            com.dochat.server.model.HomeService s = new com.dochat.server.model.HomeService();
            s.setName(d[0]);
            s.setDescription(d[1]);
            s.setPriceType(d[2]);
            s.setBasePrice(new BigDecimal(d[3]));
            s.setUnit(d[4]);
            s.setTags(d[5]);
            s.setStatus("active");
            homeServiceRepository.save(s);
        }
    }

    // 2. getServiceDetail
    public com.dochat.server.model.HomeService getServiceDetail(String serviceId) {
        return homeServiceRepository.findByServiceId(serviceId)
                .orElseThrow(() -> new HomeServiceException(11001, "服务不存在"));
    }

    // 3. createOrder
    public HomeOrder createOrder(String userId, HomeOrderRequest request) {
        HomeOrder order = new HomeOrder();
        order.setUserId(userId);
        order.setServiceId(request.getServiceId());
        order.setWorkerId(request.getWorkerId());
        order.setAddress(request.getAddress());
        if (request.getAppointmentTime() != null) {
            order.setAppointmentTime(LocalDateTime.parse(request.getAppointmentTime(), DT_FMT));
        }
        order.setPrice(request.getPrice());
        order.setStatus("pending");
        return homeOrderRepository.save(order);
    }

    // 4. getOrders
    public Page<HomeOrder> getOrders(String userId, String role, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        if ("worker".equals(role)) {
            return homeOrderRepository.findByWorkerId(userId, pageable);
        }
        return homeOrderRepository.findByUserId(userId, pageable);
    }

    // 5. acceptOrder
    public HomeOrder acceptOrder(String userId, String orderId) {
        HomeOrder order = homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
        HomeWorker worker = homeWorkerRepository.findByUserId(userId)
                .orElseThrow(() -> new HomeServiceException(11002, "工作者未注册"));
        if (!"pending".equals(order.getStatus())) {
            if ("accepted".equals(order.getStatus())) {
                throw new HomeServiceException(11004, "订单已被接单");
            }
            throw new HomeServiceException(11005, "订单状态不允许接单");
        }
        if (!"approved".equals(worker.getAuthStatus())) {
            throw new HomeServiceException(11006, "工作者审核未通过");
        }
        order.setWorkerId(worker.getWorkerId());
        order.setStatus("accepted");
        order.setUpdatedAt(LocalDateTime.now());
        return homeOrderRepository.save(order);
    }

    // 6. startService
    public HomeOrder startService(String userId, String orderId) {
        HomeOrder order = homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
        if (!"accepted".equals(order.getStatus())) {
            throw new HomeServiceException(11004, "订单状态不允许开始服务");
        }
        order.setStatus("serving");
        order.setUpdatedAt(LocalDateTime.now());
        return homeOrderRepository.save(order);
    }

    // 7. completeService
    public HomeOrder completeService(String userId, String orderId) {
        HomeOrder order = homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
        if (!"serving".equals(order.getStatus())) {
            throw new HomeServiceException(11004, "订单状态不允许完成服务");
        }
        order.setStatus("waiting_verify");
        order.setUpdatedAt(LocalDateTime.now());
        return homeOrderRepository.save(order);
    }

    // 8. verifyOrder
    public HomeOrder verifyOrder(String userId, String orderId) {
        HomeOrder order = homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
        if (!"waiting_verify".equals(order.getStatus())) {
            throw new HomeServiceException(11004, "订单状态不允许验收");
        }
        order.setStatus("completed");
        order.setUpdatedAt(LocalDateTime.now());
        homeOrderRepository.save(order);

        // Increment worker stats
        if (order.getWorkerId() != null) {
            homeWorkerRepository.findByWorkerId(order.getWorkerId()).ifPresent(worker -> {
                worker.setCompletedOrders(worker.getCompletedOrders() + 1);
                if (order.getPrice() != null) {
                    worker.setBalance(worker.getBalance().add(order.getPrice()));
                    worker.setTotalIncome(worker.getTotalIncome().add(order.getPrice()));
                }
                homeWorkerRepository.save(worker);
            });
        }
        return order;
    }

    // 9. registerWorker
    public HomeWorker registerWorker(String userId, HomeWorkerRegisterRequest request) {
        homeWorkerRepository.findByUserId(userId).ifPresent(w -> {
            throw new HomeServiceException(11007, "已注册为工作者");
        });
        HomeWorker worker = new HomeWorker();
        worker.setUserId(userId);
        worker.setName(request.getName());
        worker.setPhone(request.getPhone());
        worker.setIdCard(request.getIdCard());
        worker.setSkills(request.getSkills());
        worker.setCertificates(request.getCertificates());
        // Mock: auto approve
        worker.setAuthStatus("approved");
        return homeWorkerRepository.save(worker);
    }

    // 10. getWorkers
    public Page<HomeWorker> getWorkers(int page, int size, String skill) {
        Pageable pageable = PageRequest.of(page, size);
        Page<HomeWorker> workers = homeWorkerRepository.findByAuthStatusAndSkillsContaining("approved", skill, pageable);
        if (workers.isEmpty()) {
            mockWorkers();
            workers = homeWorkerRepository.findByAuthStatusAndSkillsContaining("approved", skill, pageable);
        }
        return workers;
    }

    private void mockWorkers() {
        String[][] mockData = {
            {"张师傅", "13800001111", "110101199001011234", "[{\"skill\":\"管道疏通\",\"level\":\"高级\"},{\"skill\":\"防水补漏\",\"level\":\"中级\"}]", "[{\"name\":\"管工证\",\"issuer\":\"住建委\"}]"},
            {"李师傅", "13800002222", "110101199101011235", "[{\"skill\":\"空调清洗\",\"level\":\"高级\"},{\"skill\":\"家电维修\",\"level\":\"高级\"}]", "[{\"name\":\"电工证\",\"issuer\":\"安监局\"}]"},
            {"王师傅", "13800003333", "110101199201011236", "[{\"skill\":\"开锁换锁\",\"level\":\"特级\"}]", "[{\"name\":\"开锁备案证明\",\"issuer\":\"公安局\"}]"},
            {"赵师傅", "13800004444", "110101199301011237", "[{\"skill\":\"墙面翻新\",\"level\":\"高级\"},{\"skill\":\"瓷砖铺贴\",\"level\":\"中级\"}]", "[{\"name\":\"装修工证\",\"issuer\":\"住建委\"}]"},
            {"陈师傅", "13800005555", "110101199401011238", "[{\"skill\":\"电路维修\",\"level\":\"高级\"}]", "[{\"name\":\"电工证\",\"issuer\":\"安监局\"}]"},
            {"刘师傅", "13800006666", "110101199501011239", "[{\"skill\":\"搬家服务\",\"level\":\"中级\"}]", "[]"},
            {"周师傅", "13800007777", "110101199601011240", "[{\"skill\":\"家具组装\",\"level\":\"高级\"}]", "[{\"name\":\"木工证\",\"issuer\":\"人社局\"}]"},
            {"吴师傅", "13800008888", "110101199701011241", "[{\"skill\":\"清洁保洁\",\"level\":\"高级\"}]", "[{\"name\":\"保洁等级证\",\"issuer\":\"家政协会\"}]"},
            {"郑师傅", "13800009999", "110101199801011242", "[{\"skill\":\"防水补漏\",\"level\":\"特级\"}]", "[{\"name\":\"防水工证\",\"issuer\":\"住建委\"}]"},
            {"马师傅", "13800000001", "110101199901011243", "[{\"skill\":\"油烟机清洗\",\"level\":\"高级\"},{\"skill\":\"热水器安装\",\"level\":\"中级\"}]", "[{\"name\":\"燃气具安装证\",\"issuer\":\"住建委\"}]"},
        };
        for (String[] d : mockData) {
            HomeWorker w = new HomeWorker();
            w.setUserId("MOCK_" + d[0].substring(0, 1) + "_" + System.nanoTime());
            w.setName(d[0]);
            w.setPhone(d[1]);
            w.setIdCard(d[2]);
            w.setSkills(d[3]);
            w.setCertificates(d[4]);
            w.setAuthStatus("approved");
            w.setStatus("online");
            w.setCreditScore(100 + new Random().nextInt(50));
            homeWorkerRepository.save(w);
        }
    }

    // 11. getWorkerCredit
    public Map<String, Object> getWorkerCredit(String workerId) {
        HomeWorker worker = homeWorkerRepository.findByWorkerId(workerId)
                .orElseThrow(() -> new HomeServiceException(11002, "工作者未注册"));
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("creditScore", worker.getCreditScore());
        int score = worker.getCreditScore();
        String level = score >= 140 ? "特级" : score >= 120 ? "高级" : score >= 100 ? "中级" : "初级";
        result.put("level", level);
        result.put("completedOrders", worker.getCompletedOrders());
        return result;
    }

    // 12. createDispute
    public HomeDispute createDispute(String userId, String orderId, String reason) {
        HomeOrder order = homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
        if (!"waiting_verify".equals(order.getStatus()) && !"completed".equals(order.getStatus())) {
            throw new HomeServiceException(11004, "订单状态不允许发起争议");
        }
        HomeDispute dispute = new HomeDispute();
        dispute.setOrderId(orderId);
        dispute.setInitiatorId(userId);
        dispute.setReason(reason);
        dispute.setStatus("pending");
        order.setStatus("disputed");
        order.setUpdatedAt(LocalDateTime.now());
        homeOrderRepository.save(order);
        return homeDisputeRepository.save(dispute);
    }

    // 13. submitEvidence
    public HomeDispute submitEvidence(String userId, String disputeId, String evidence) {
        HomeDispute dispute = homeDisputeRepository.findByDisputeId(disputeId)
                .orElseThrow(() -> new HomeServiceException(11003, "争议订单不存在"));
        dispute.setEvidence(evidence);
        return homeDisputeRepository.save(dispute);
    }

    // 14. getJuryStatus
    public Map<String, Object> getJuryStatus(String disputeId) {
        HomeDispute dispute = homeDisputeRepository.findByDisputeId(disputeId)
                .orElseThrow(() -> new HomeServiceException(11003, "争议订单不存在"));
        // Mock: randomize votes for demo
        Random random = new Random();
        int votesFor = random.nextInt(18);
        int votesAgainst = 17 - votesFor;
        dispute.setJuryVotesFor(votesFor);
        dispute.setJuryVotesAgainst(votesAgainst);
        if (votesFor >= 9) {
            dispute.setVerdict("for_user");
            dispute.setStatus("resolved");
        } else if (votesAgainst >= 9) {
            dispute.setVerdict("for_worker");
            dispute.setStatus("resolved");
        } else {
            dispute.setVerdict("pending");
        }
        homeDisputeRepository.save(dispute);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("juryVotesFor", dispute.getJuryVotesFor());
        result.put("juryVotesAgainst", dispute.getJuryVotesAgainst());
        result.put("totalJurors", dispute.getTotalJurors());
        result.put("verdict", dispute.getVerdict());
        return result;
    }


    // === getOrderDetail ===
    public HomeOrder getOrderDetail(String userId, String orderId) {
        return homeOrderRepository.findByOrderId(orderId)
                .orElseThrow(() -> new HomeServiceException(11003, "订单不存在"));
    }

    // === getWorkerDetail ===
    public HomeWorker getWorkerDetail(String workerId) {
        return homeWorkerRepository.findByWorkerId(workerId)
                .orElseThrow(() -> new HomeServiceException(11002, "师傅不存在"));
    }

    // === updateWorkerStatus ===
    public HomeWorker updateWorkerStatus(String userId, String status) {
        HomeWorker worker = homeWorkerRepository.findByUserId(userId)
                .orElseThrow(() -> new HomeServiceException(11002, "师傅不存在"));
        if (!"approved".equals(worker.getAuthStatus())) {
            throw new HomeServiceException(11007, "师傅入驻审核中");
        }
        worker.setStatus(status);
        return homeWorkerRepository.save(worker);
    }

    // === getWorkerIncome ===
    public Map<String, Object> getWorkerIncome(String userId) {
        HomeWorker worker = homeWorkerRepository.findByUserId(userId)
                .orElseThrow(() -> new HomeServiceException(11002, "师傅不存在"));
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("totalIncome", worker.getTotalIncome());
        result.put("balance", worker.getBalance());
        result.put("completedOrders", worker.getCompletedOrders());
        return result;
    }

    // === withdraw ===
    public Map<String, Object> withdraw(String userId, BigDecimal amount) {
        HomeWorker worker = homeWorkerRepository.findByUserId(userId)
                .orElseThrow(() -> new HomeServiceException(11002, "师傅不存在"));
        if (worker.getBalance().compareTo(amount) < 0) {
            throw new HomeServiceException(11008, "保证金不足");
        }
        worker.setBalance(worker.getBalance().subtract(amount));
        homeWorkerRepository.save(worker);
        Map<String, Object> result = new java.util.HashMap<>();
        result.put("withdrawn", amount);
        result.put("balance", worker.getBalance());
        return result;
    }

    // === getCategories ===
    public List<HomeCategory> getCategories() {
        List<HomeCategory> cats = homeCategoryRepository.findByLevel(1);
        if (cats.isEmpty()) {
            String[][] mockCats = {{"家电维修", "wrench"}, {"房屋装修", "house"}, {"家政保洁", "sparkles"}, {"搬家运输", "cube_box"}, {"管道疏通", "drop"}, {"开锁换锁", "lock"}};
            for (int i = 0; i < mockCats.length; i++) {
                HomeCategory c = new HomeCategory();
                c.setName(mockCats[i][0]);
                c.setLevel(1);
                c.setSortOrder(i);
                c.setIcon(mockCats[i][1]);
                homeCategoryRepository.save(c);
            }
            cats = homeCategoryRepository.findByLevel(1);
        }
        return cats;
    }

    // === getTrainings ===
    public List<HomeTraining> getTrainings() {
        List<HomeTraining> list = homeTrainingRepository.findAll();
        if (list.isEmpty()) {
            String[][] mock = {{"家电维修基础", "skill"}, {"平台服务规范", "rule"}, {"上门安全指南", "safety"}, {"空调维修进阶", "skill"}, {"客户沟通技巧", "rule"}};
            for (int i = 0; i < mock.length; i++) {
                HomeTraining t = new HomeTraining();
                t.setTitle(mock[i][0]);
                t.setCategory(mock[i][1]);
                t.setDuration(30 + i * 10);
                t.setContent("培训内容：" + mock[i][0]);
                homeTrainingRepository.save(t);
            }
            list = homeTrainingRepository.findAll();
        }
        return list;
    }

    // === getFavorites ===
    public List<HomeWorker> getFavorites(String userId) {
        List<HomeFavorite> favs = homeFavoriteRepository.findByUserId(userId);
        if (favs.isEmpty()) return new java.util.ArrayList<>();
        List<HomeWorker> workers = new java.util.ArrayList<>();
        for (HomeFavorite f : favs) {
            homeWorkerRepository.findByWorkerId(f.getWorkerId()).ifPresent(workers::add);
        }
        return workers;
    }

    // === addFavorite ===
    public void addFavorite(String userId, String workerId) {
        if (homeFavoriteRepository.existsByUserIdAndWorkerId(userId, workerId)) return;
        HomeFavorite f = new HomeFavorite();
        f.setUserId(userId);
        f.setWorkerId(workerId);
        homeFavoriteRepository.save(f);
    }

    // === removeFavorite ===
    public void removeFavorite(String userId, String workerId) {
        homeFavoriteRepository.deleteByUserIdAndWorkerId(userId, workerId);
    }

    // === getWorkerMall（Mock） ===
    public java.util.List<Map<String, Object>> getWorkerMall() {
        java.util.List<Map<String, Object>> items = new java.util.ArrayList<>();
        String[][] mock = {{"夏季工装套装", "89"}, {"防滑安全鞋", "129"}, {"工具箱套装", "199"}, {"防护手套", "29"}, {"工作围裙", "49"}, {"安全头盔", "69"}};
        for (String[] m : mock) {
            Map<String, Object> item = new java.util.HashMap<>();
            item.put("name", m[0]);
            item.put("price", Integer.parseInt(m[1]));
            item.put("image", "");
            items.add(item);
        }
        return items;
    }

    public static class HomeServiceException extends RuntimeException {
        private final int code;

        public HomeServiceException(int code, String message) {
            super(message);
            this.code = code;
        }

        public int getCode() { return code; }
    }
}
