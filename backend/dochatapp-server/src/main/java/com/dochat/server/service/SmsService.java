package com.dochat.server.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class SmsService {

    private static final Logger log = LoggerFactory.getLogger(SmsService.class);

    public void sendSms(String phone, String code) {
        log.info("========== SMS MOCK ==========");
        log.info("To: {}", phone);
        log.info("Code: {}", code);
        log.info("===============================");
    }
}
