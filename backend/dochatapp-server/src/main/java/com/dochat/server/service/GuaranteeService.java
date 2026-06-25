package com.dochat.server.service;

import com.dochat.server.dto.DisputeRequest;
import com.dochat.server.dto.TradeCreateRequest;
import com.dochat.server.dto.TradeResponse;
import com.dochat.server.model.GuaranteeDispute;
import com.dochat.server.model.GuaranteeTrade;
import com.dochat.server.model.Session;
import com.dochat.server.model.SessionMember;
import com.dochat.server.model.User;
import com.dochat.server.repository.GuaranteeDisputeRepository;
import com.dochat.server.repository.GuaranteeTradeRepository;
import com.dochat.server.repository.SessionMemberRepository;
import com.dochat.server.repository.SessionRepository;
import com.dochat.server.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class GuaranteeService {

    private static final Logger log = LoggerFactory.getLogger(GuaranteeService.class);

    private final GuaranteeTradeRepository tradeRepository;
    private final GuaranteeDisputeRepository disputeRepository;
    private final UserRepository userRepository;
    private final SessionRepository sessionRepository;
    private final SessionMemberRepository sessionMemberRepository;

    public GuaranteeService(GuaranteeTradeRepository tradeRepository,
                            GuaranteeDisputeRepository disputeRepository,
                            UserRepository userRepository,
                            SessionRepository sessionRepository,
                            SessionMemberRepository sessionMemberRepository) {
        this.tradeRepository = tradeRepository;
        this.disputeRepository = disputeRepository;
        this.userRepository = userRepository;
        this.sessionRepository = sessionRepository;
        this.sessionMemberRepository = sessionMemberRepository;
    }

    @Transactional
    public TradeResponse createTrade(String userId, TradeCreateRequest request) {
        GuaranteeTrade trade = new GuaranteeTrade();
        trade.setBuyerId(userId);
        trade.setSellerId(request.getCounterpartyId());
        trade.setProductName(request.getProductName());
        trade.setProductDesc(request.getProductDesc());
        trade.setAmount(request.getAmount());
        trade.setStatus("pending");
        trade = tradeRepository.save(trade);
        log.info("Trade created: {} buyer={} seller={}", trade.getTradeId(), userId, request.getCounterpartyId());
        return toTradeResponse(trade);
    }

    @Transactional
    public TradeResponse confirmTrade(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        validateParticipant(trade, userId);
        if (!"pending".equals(trade.getStatus())) {
            throw new RuntimeException("当前状态不允许确认交易");
        }
        if (trade.getBuyerId().equals(userId)) {
            throw new RuntimeException("买家不能确认交易，请等待卖家确认");
        }
        trade.setStatus("confirmed");
        trade = tradeRepository.save(trade);
        log.info("Trade {} confirmed by {}", tradeId, userId);
        return toTradeResponse(trade);
    }

    @Transactional
    public TradeResponse freezeFunds(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        if (!trade.getBuyerId().equals(userId)) {
            throw new RuntimeException("仅买家可以冻结资金");
        }
        if (!"confirmed".equals(trade.getStatus())) {
            throw new RuntimeException("当前状态不允许冻结资金");
        }
        trade.setStatus("frozen");
        trade = tradeRepository.save(trade);
        log.info("Trade {} funds frozen by {}", tradeId, userId);
        return toTradeResponse(trade);
    }

    @Transactional
    public TradeResponse initiateVerify(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        if (!trade.getBuyerId().equals(userId)) {
            throw new RuntimeException("仅买家可以发起验号");
        }
        if (!"frozen".equals(trade.getStatus())) {
            throw new RuntimeException("当前状态不允许发起验号");
        }
        trade.setStatus("verifying");
        trade = tradeRepository.save(trade);
        log.info("Trade {} verify initiated by {}", tradeId, userId);
        return toTradeResponse(trade);
    }

    @Transactional
    public TradeResponse submitVerify(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        if (!trade.getSellerId().equals(userId)) {
            throw new RuntimeException("仅卖家可以提交验号");
        }
        if (!"verifying".equals(trade.getStatus())) {
            throw new RuntimeException("当前状态不允许提交验号");
        }
        if (trade.getDisputeId() != null) {
            throw new RuntimeException("交易存在争议，暂无法完成验号");
        }
        // MOCK: always pass
        trade.setVerifyStatus("passed");
        trade.setVerifyReport("验号通过：账号信息完整有效");
        trade.setStatus("verified");
        trade = tradeRepository.save(trade);
        log.info("Trade {} verify submitted by {}, mock-passed", tradeId, userId);
        return toTradeResponse(trade);
    }

    @Transactional
    public TradeResponse releaseFunds(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        if (!trade.getBuyerId().equals(userId)) {
            throw new RuntimeException("仅买家可以释放资金");
        }
        if (!"verified".equals(trade.getStatus())) {
            throw new RuntimeException("当前状态不允许释放资金");
        }
        trade.setStatus("completed");
        trade = tradeRepository.save(trade);
        log.info("Trade {} funds released by {}", tradeId, userId);
        return toTradeResponse(trade);
    }

    public Page<TradeResponse> getTradeList(String userId, String status, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<GuaranteeTrade> tradePage;
        if (status != null && !status.isEmpty()) {
            tradePage = tradeRepository.findByStatus(status, pageable);
        } else {
            tradePage = tradeRepository.findByBuyerIdOrSellerId(userId, userId, pageable);
        }
        return tradePage.map(this::toTradeResponse);
    }

    public TradeResponse getTradeDetail(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        validateParticipant(trade, userId);
        return toTradeResponse(trade);
    }

    @Transactional
    public Map<String, Object> createDispute(String tradeId, String userId, DisputeRequest request) {
        GuaranteeTrade trade = getTrade(tradeId);
        if ("completed".equals(trade.getStatus()) || "cancelled".equals(trade.getStatus())) {
            throw new RuntimeException("交易已完成或取消，无法发起争议");
        }
        if (trade.getDisputeId() != null) {
            throw new RuntimeException("交易已存在争议");
        }

        GuaranteeDispute dispute = new GuaranteeDispute();
        dispute.setTradeId(tradeId);
        dispute.setInitiatorId(userId);
        dispute.setReason(request.getReason());
        dispute.setDescription(request.getDescription());

        // MOCK: auto-set jury and verdict
        dispute.setJuryCount(19);
        dispute.setVotesForBuyer(12);
        dispute.setVotesForSeller(7);
        dispute.setVerdict("buyer_win");
        dispute.setStatus("verdict_executed");
        dispute.setResolvedAt(LocalDateTime.now());

        dispute = disputeRepository.save(dispute);

        trade.setDisputeId(dispute.getDisputeId());
        tradeRepository.save(trade);

        log.info("Dispute {} created for trade {}, verdict={}", dispute.getDisputeId(), tradeId, dispute.getVerdict());

        Map<String, Object> result = new HashMap<>();
        result.put("disputeId", dispute.getDisputeId());
        result.put("tradeId", dispute.getTradeId());
        result.put("initiatorId", dispute.getInitiatorId());
        result.put("reason", dispute.getReason());
        result.put("description", dispute.getDescription());
        result.put("status", dispute.getStatus());
        result.put("verdict", dispute.getVerdict());
        result.put("juryCount", dispute.getJuryCount());
        result.put("votesForBuyer", dispute.getVotesForBuyer());
        result.put("votesForSeller", dispute.getVotesForSeller());
        result.put("resolvedAt", dispute.getResolvedAt() != null ? dispute.getResolvedAt().toString() : null);
        return result;
    }

    public Map<String, Object> getDispute(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        validateParticipant(trade, userId);
        if (trade.getDisputeId() == null) {
            throw new RuntimeException("该交易没有争议记录");
        }
        GuaranteeDispute dispute = disputeRepository.findByTradeId(tradeId)
                .orElseThrow(() -> new RuntimeException("争议记录不存在"));

        Map<String, Object> result = new HashMap<>();
        result.put("disputeId", dispute.getDisputeId());
        result.put("tradeId", dispute.getTradeId());
        result.put("initiatorId", dispute.getInitiatorId());
        result.put("reason", dispute.getReason());
        result.put("description", dispute.getDescription());
        result.put("status", dispute.getStatus());
        result.put("verdict", dispute.getVerdict());
        result.put("juryCount", dispute.getJuryCount());
        result.put("votesForBuyer", dispute.getVotesForBuyer());
        result.put("votesForSeller", dispute.getVotesForSeller());
        result.put("resolvedAt", dispute.getResolvedAt() != null ? dispute.getResolvedAt().toString() : null);
        return result;
    }

    @Transactional
    public Map<String, String> getOrCreateChat(String tradeId, String userId) {
        GuaranteeTrade trade = getTrade(tradeId);
        validateParticipant(trade, userId);

        if (trade.getSessionId() != null) {
            Map<String, String> result = new HashMap<>();
            result.put("sessionId", trade.getSessionId());
            return result;
        }

        String buyerId = trade.getBuyerId();
        String sellerId = trade.getSellerId();

        // Check if a single session already exists between these two users
        List<String> commonSessionIds = sessionMemberRepository.findCommonSessionIds(buyerId, sellerId);
        for (String sid : commonSessionIds) {
            Optional<Session> optSession = sessionRepository.findBySessionId(sid);
            if (optSession.isPresent() && "single".equals(optSession.get().getType())) {
                trade.setSessionId(sid);
                tradeRepository.save(trade);
                Map<String, String> result = new HashMap<>();
                result.put("sessionId", sid);
                return result;
            }
        }

        // Create new session
        String sessionId = "s_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16);
        Session session = new Session();
        session.setSessionId(sessionId);
        session.setType("single");
        session.setLastTime(LocalDateTime.now());
        session = sessionRepository.save(session);

        SessionMember member1 = new SessionMember();
        member1.setSessionId(sessionId);
        member1.setUserId(buyerId);
        sessionMemberRepository.save(member1);

        SessionMember member2 = new SessionMember();
        member2.setSessionId(sessionId);
        member2.setUserId(sellerId);
        sessionMemberRepository.save(member2);

        trade.setSessionId(sessionId);
        tradeRepository.save(trade);

        log.info("Created embedded chat session {} for trade {}", sessionId, tradeId);

        Map<String, String> result = new HashMap<>();
        result.put("sessionId", sessionId);
        return result;
    }

    // ---- helpers ----

    private GuaranteeTrade getTrade(String tradeId) {
        return tradeRepository.findByTradeId(tradeId)
                .orElseThrow(() -> new RuntimeException("交易不存在: " + tradeId));
    }

    private void validateParticipant(GuaranteeTrade trade, String userId) {
        if (!trade.getBuyerId().equals(userId) && !trade.getSellerId().equals(userId)) {
            throw new RuntimeException("无权操作该交易");
        }
    }

    private String lookupNickname(String userId) {
        return userRepository.findByUserId(userId)
                .map(User::getNickname)
                .orElse(null);
    }

    private TradeResponse toTradeResponse(GuaranteeTrade trade) {
        TradeResponse r = new TradeResponse();
        r.setId(trade.getId());
        r.setTradeId(trade.getTradeId());
        r.setBuyerId(trade.getBuyerId());
        r.setSellerId(trade.getSellerId());
        r.setBuyerNickname(lookupNickname(trade.getBuyerId()));
        r.setSellerNickname(lookupNickname(trade.getSellerId()));
        r.setProductName(trade.getProductName());
        r.setProductDesc(trade.getProductDesc());
        r.setAmount(trade.getAmount());
        r.setStatus(trade.getStatus());
        r.setVerifyStatus(trade.getVerifyStatus());
        r.setVerifyReport(trade.getVerifyReport());
        r.setDisputeId(trade.getDisputeId());
        r.setSessionId(trade.getSessionId());
        r.setCreatedAt(trade.getCreatedAt());
        r.setUpdatedAt(trade.getUpdatedAt());
        return r;
    }
}
