package com.dochat.server.controller;

import com.dochat.server.dto.AccountRequest;
import com.dochat.server.dto.ApiResponse;
import com.dochat.server.dto.MarkRequest;
import com.dochat.server.dto.SendRequest;
import com.dochat.server.model.MailAccount;
import com.dochat.server.model.MailFilter;
import com.dochat.server.model.MailFolder;
import com.dochat.server.model.MailMessage;
import com.dochat.server.model.MailRead;
import com.dochat.server.service.MailService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/mail")
public class MailController {

    private final MailService mailService;

    public MailController(MailService mailService) {
        this.mailService = mailService;
    }

    @PostMapping("/account")
    public ResponseEntity<ApiResponse<MailAccount>> addAccount(
            @AuthenticationPrincipal String userId,
            @RequestBody AccountRequest request) {
        try {
            MailAccount account = mailService.addAccount(userId, request);
            return ResponseEntity.ok(ApiResponse.success(account));
        } catch (IllegalArgumentException e) {
            String code = e.getMessage();
            if ("9001".equals(code)) {
                return ResponseEntity.badRequest().body(ApiResponse.error(9001, "账户不存在"));
            }
            return ResponseEntity.badRequest().body(ApiResponse.error(9005, "密码不能为空"));
        }
    }

    @GetMapping("/accounts")
    public ResponseEntity<ApiResponse<List<MailAccount>>> getAccounts(
            @AuthenticationPrincipal String userId) {
        List<MailAccount> accounts = mailService.getAccounts(userId);
        return ResponseEntity.ok(ApiResponse.success(accounts));
    }

    @DeleteMapping("/account")
    public ResponseEntity<ApiResponse<Void>> deleteAccount(
            @AuthenticationPrincipal String userId,
            @RequestParam String accountId) {
        try {
            mailService.deleteAccount(userId, accountId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9001, "账户不存在或无权操作"));
        }
    }

    @GetMapping("/list")
    public ResponseEntity<ApiResponse<List<MailMessage>>> getMailList(
            @AuthenticationPrincipal String userId,
            @RequestParam String accountId,
            @RequestParam(defaultValue = "inbox") String folder,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        List<MailMessage> messages = mailService.getMailList(userId, accountId, folder, page, size);
        return ResponseEntity.ok(ApiResponse.success(messages));
    }

    @GetMapping("/detail")
    public ResponseEntity<ApiResponse<MailMessage>> getMailDetail(
            @AuthenticationPrincipal String userId,
            @RequestParam String messageId) {
        try {
            MailMessage message = mailService.getMailDetail(userId, messageId);
            return ResponseEntity.ok(ApiResponse.success(message));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9002, "邮件不存在"));
        }
    }

    @PostMapping("/send")
    public ResponseEntity<ApiResponse<MailMessage>> sendMail(
            @AuthenticationPrincipal String userId,
            @RequestBody SendRequest request) {
        try {
            MailMessage message = mailService.sendMail(userId, request);
            return ResponseEntity.ok(ApiResponse.success(message));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9003, "收件人不能为空"));
        }
    }

    @PostMapping("/reply")
    public ResponseEntity<ApiResponse<MailMessage>> replyMail(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, Object> body) {
        try {
            String messageId = (String) body.get("messageId");
            String replyBody = (String) body.get("body");
            Boolean replyAll = body.get("replyAll") != null ? (Boolean) body.get("replyAll") : false;
            MailMessage message = mailService.replyMail(userId, messageId, replyBody, replyAll);
            return ResponseEntity.ok(ApiResponse.success(message));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9002, "原邮件不存在"));
        }
    }

    @DeleteMapping("/delete")
    public ResponseEntity<ApiResponse<Void>> deleteMail(
            @AuthenticationPrincipal String userId,
            @RequestParam String messageId) {
        try {
            mailService.deleteMail(userId, messageId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (IllegalArgumentException e) {
            String code = e.getMessage();
            if ("9007".equals(code)) {
                return ResponseEntity.badRequest().body(ApiResponse.error(9007, "邮件已在回收站中"));
            }
            return ResponseEntity.badRequest().body(ApiResponse.error(9002, "邮件不存在"));
        }
    }

    @PutMapping("/mark")
    public ResponseEntity<ApiResponse<Void>> markMail(
            @AuthenticationPrincipal String userId,
            @RequestBody MarkRequest request) {
        try {
            mailService.markMail(userId, request);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9002, "邮件不存在"));
        }
    }

    @PutMapping("/move")
    public ResponseEntity<ApiResponse<Void>> moveMail(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String messageId = body.get("messageId");
            String targetFolder = body.get("targetFolder");
            mailService.moveMail(userId, messageId, targetFolder);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (IllegalArgumentException e) {
            String code = e.getMessage();
            if ("9006".equals(code)) {
                return ResponseEntity.badRequest().body(ApiResponse.error(9006, "目标文件夹无效"));
            }
            return ResponseEntity.badRequest().body(ApiResponse.error(9002, "邮件不存在"));
        }
    }

    @PostMapping("/folder")
    public ResponseEntity<ApiResponse<MailFolder>> createFolder(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String name = body.get("name");
            MailFolder folder = mailService.createFolder(userId, name);
            return ResponseEntity.ok(ApiResponse.success(folder));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9006, "文件夹名称不能为空"));
        }
    }

    @GetMapping("/folders")
    public ResponseEntity<ApiResponse<List<MailFolder>>> getFolders(
            @AuthenticationPrincipal String userId) {
        try {
            List<MailFolder> folders = mailService.getFolders(userId);
            return ResponseEntity.ok(ApiResponse.success(folders));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9006, e.getMessage()));
        }
    }

    @DeleteMapping("/folder")
    public ResponseEntity<ApiResponse<Void>> deleteFolder(
            @AuthenticationPrincipal String userId,
            @RequestParam String folderId) {
        try {
            mailService.deleteFolder(userId, folderId);
            return ResponseEntity.ok(ApiResponse.success(null));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9006, "文件夹不存在或无权操作"));
        }
    }

    @GetMapping("/filters")
    public ResponseEntity<ApiResponse<List<MailFilter>>> getFilters(
            @AuthenticationPrincipal String userId) {
        try {
            List<MailFilter> filters = mailService.getFilters(userId);
            return ResponseEntity.ok(ApiResponse.success(filters));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9008, e.getMessage()));
        }
    }

    @PostMapping("/filter")
    public ResponseEntity<ApiResponse<MailFilter>> addFilter(
            @AuthenticationPrincipal String userId,
            @RequestBody Map<String, String> body) {
        try {
            String type = body.get("type");
            String addressPattern = body.get("addressPattern");
            MailFilter filter = mailService.addFilter(userId, type, addressPattern);
            return ResponseEntity.ok(ApiResponse.success(filter));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(9008, "过滤规则已存在"));
        }
    }

    @GetMapping("/reads")
    public ResponseEntity<ApiResponse<List<MailRead>>> getDailyReads(
            @AuthenticationPrincipal String userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        List<MailRead> reads = mailService.getDailyReads(userId, page, size);
        return ResponseEntity.ok(ApiResponse.success(reads));
    }
}
