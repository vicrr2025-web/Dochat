package com.dochat.server.service;

import com.dochat.server.dto.AccountRequest;
import com.dochat.server.dto.MarkRequest;
import com.dochat.server.dto.SendRequest;
import com.dochat.server.model.MailAccount;
import com.dochat.server.model.MailFilter;
import com.dochat.server.model.MailFolder;
import com.dochat.server.model.MailMessage;
import com.dochat.server.model.MailRead;
import com.dochat.server.repository.MailAccountRepository;
import com.dochat.server.repository.MailFilterRepository;
import com.dochat.server.repository.MailFolderRepository;
import com.dochat.server.repository.MailMessageRepository;
import com.dochat.server.repository.MailReadRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class MailService {

    private final MailAccountRepository mailAccountRepository;
    private final MailMessageRepository mailMessageRepository;
    private final MailFolderRepository mailFolderRepository;
    private final MailFilterRepository mailFilterRepository;
    private final MailReadRepository mailReadRepository;

    public MailService(MailAccountRepository mailAccountRepository,
                       MailMessageRepository mailMessageRepository,
                       MailFolderRepository mailFolderRepository,
                       MailFilterRepository mailFilterRepository,
                       MailReadRepository mailReadRepository) {
        this.mailAccountRepository = mailAccountRepository;
        this.mailMessageRepository = mailMessageRepository;
        this.mailFolderRepository = mailFolderRepository;
        this.mailFilterRepository = mailFilterRepository;
        this.mailReadRepository = mailReadRepository;
    }

    public MailAccount addAccount(String userId, AccountRequest request) {
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            throw new IllegalArgumentException("9005");
        }
        MailAccount account = new MailAccount();
        account.setUserId(userId);
        account.setEmail(request.getEmail());
        account.setPassword(request.getPassword());
        account.setProvider(request.getProvider() != null ? request.getProvider() : "custom");
        account.setImapHost(request.getImapHost());
        account.setImapPort(request.getImapPort() != null ? request.getImapPort() : 993);
        account.setSmtpHost(request.getSmtpHost());
        account.setSmtpPort(request.getSmtpPort() != null ? request.getSmtpPort() : 465);
        account.setDisplayName(request.getDisplayName());

        List<MailAccount> existing = mailAccountRepository.findByUserId(userId);
        if (existing.isEmpty()) {
            account.setIsDefault(true);
        }
        return mailAccountRepository.save(account);
    }

    public List<MailAccount> getAccounts(String userId) {
        List<MailAccount> accounts = mailAccountRepository.findByUserId(userId);
        if (accounts.isEmpty()) {
            accounts = generateMockAccounts(userId);
        }
        return accounts;
    }

    private List<MailAccount> generateMockAccounts(String userId) {
        List<MailAccount> accounts = new ArrayList<>();
        String[][] mockAccounts = {
            {"user@gmail.com", "gmail", "imap.gmail.com", "993", "smtp.gmail.com", "465", "Gmail"},
            {"user@outlook.com", "outlook", "imap-mail.outlook.com", "993", "smtp-mail.outlook.com", "587", "Outlook"},
            {"user@qq.com", "qq", "imap.qq.com", "993", "smtp.qq.com", "465", "QQ邮箱"},
            {"user@163.com", "netease", "imap.163.com", "993", "smtp.163.com", "465", "网易邮箱"},
        };
        for (String[] m : mockAccounts) {
            MailAccount account = new MailAccount();
            account.setUserId(userId);
            account.setEmail(m[0]);
            account.setProvider(m[1]);
            account.setImapHost(m[2]);
            account.setImapPort(Integer.parseInt(m[3]));
            account.setSmtpHost(m[4]);
            account.setSmtpPort(Integer.parseInt(m[5]));
            account.setDisplayName(m[6]);
            account.setPassword("******");
            if (accounts.isEmpty()) {
                account.setIsDefault(true);
            }
            accounts.add(mailAccountRepository.save(account));
        }
        return accounts;
    }

    @Transactional
    public void deleteAccount(String userId, String accountId) {
        MailAccount account = mailAccountRepository.findByAccountId(accountId)
                .orElseThrow(() -> new IllegalArgumentException("9001"));
        if (!account.getUserId().equals(userId)) {
            throw new IllegalArgumentException("9001");
        }
        mailAccountRepository.delete(account);
    }

    public List<MailMessage> getMailList(String userId, String accountId, String folder, int page, int size) {
        List<MailMessage> messages = mailMessageRepository.findByAccountIdAndFolder(accountId, folder != null ? folder : "inbox");
        if (messages.isEmpty()) {
            List<MailMessage> mockMessages = generateMockMessages(accountId, folder != null ? folder : "inbox");
            messages = mockMessages;
        }
        int start = Math.min(page * size, messages.size());
        int end = Math.min(start + size, messages.size());
        if (start >= messages.size()) {
            return new ArrayList<>();
        }
        return messages.subList(start, end);
    }

    private List<MailMessage> generateMockMessages(String accountId, String folder) {
        List<MailMessage> messages = new ArrayList<>();
        String[][] mockSubjects = {
                {"meeting@company.com", "会议邀请：2024年度总结大会"},
                {"pm@project.com", "项目更新：新版本发布日期确认"},
                {"weekly@team.com", "周报：本周工作进展与下周计划"},
                {"hr@company.com", "通知：年度绩效考核开始"},
                {"sys@platform.com", "系统提醒：您的订阅即将到期"}
        };
        for (int i = 0; i < 5; i++) {
            MailMessage msg = new MailMessage();
            msg.setAccountId(accountId);
            msg.setFolder(folder);
            msg.setSender(mockSubjects[i][0]);
            msg.setSubject(mockSubjects[i][1]);
            msg.setBody(mockSubjects[i][1] + " 的详细内容...");
            msg.setRecipients("user@example.com");
            msg.setReceivedAt(LocalDateTime.now().minusDays(i));
            msg.setIsRead(i > 0);
            msg.setIsStarred(i == 0);
            msg.setHasAttachments(i % 2 == 0);
            messages.add(msg);
        }
        return messages;
    }

    @Transactional
    public MailMessage getMailDetail(String userId, String messageId) {
        MailMessage message = mailMessageRepository.findByMessageId(messageId)
                .orElseThrow(() -> new IllegalArgumentException("9002"));
        message.setIsRead(true);
        return mailMessageRepository.save(message);
    }

    @Transactional
    public MailMessage sendMail(String userId, SendRequest request) {
        if (request.getTo() == null || request.getTo().isEmpty()) {
            throw new IllegalArgumentException("9003");
        }
        // 9004: 附件总大小检查（Mock：限制10MB）
        if (request.getAttachments() != null && request.getAttachments().length() > 10 * 1024 * 1024) {
            throw new IllegalArgumentException("9004");
        }
        MailMessage message = new MailMessage();
        message.setAccountId(request.getAccountId());
        message.setFolder("sent");
        message.setRecipients(request.getTo());
        message.setSubject(request.getSubject());
        message.setBody(request.getBody());
        message.setSender("user@example.com");
        message.setReceivedAt(LocalDateTime.now());
        // 如有附件则标记
        if (request.getAttachments() != null && !request.getAttachments().isEmpty()) {
            message.setHasAttachments(true);
            message.setAttachments(request.getAttachments());
        }
        return mailMessageRepository.save(message);
    }

    @Transactional
    public MailMessage replyMail(String userId, String messageId, String body, boolean replyAll) {
        MailMessage original = mailMessageRepository.findByMessageId(messageId)
                .orElseThrow(() -> new IllegalArgumentException("9002"));
        MailMessage reply = new MailMessage();
        reply.setAccountId(original.getAccountId());
        reply.setFolder("sent");
        reply.setRecipients(original.getSender());
        reply.setSubject("Re: " + original.getSubject());
        reply.setBody(body);
        reply.setSender("user@example.com");
        reply.setReceivedAt(LocalDateTime.now());
        return mailMessageRepository.save(reply);
    }

    @Transactional
    public void deleteMail(String userId, String messageId) {
        MailMessage message = mailMessageRepository.findByMessageId(messageId)
                .orElseThrow(() -> new IllegalArgumentException("9002"));
        if ("trash".equals(message.getFolder())) {
            throw new IllegalArgumentException("9007");
        }
        message.setFolder("trash");
        mailMessageRepository.save(message);
    }

    @Transactional
    public void markMail(String userId, MarkRequest request) {
        MailMessage message = mailMessageRepository.findByMessageId(request.getMessageId())
                .orElseThrow(() -> new IllegalArgumentException("9002"));
        switch (request.getAction()) {
            case "read":
                message.setIsRead(true);
                break;
            case "unread":
                message.setIsRead(false);
                break;
            case "star":
                message.setIsStarred(true);
                break;
            case "unstar":
                message.setIsStarred(false);
                break;
        }
        mailMessageRepository.save(message);
    }

    @Transactional
    public void moveMail(String userId, String messageId, String targetFolder) {
        MailMessage message = mailMessageRepository.findByMessageId(messageId)
                .orElseThrow(() -> new IllegalArgumentException("9002"));
        if (targetFolder == null || targetFolder.isEmpty()) {
            throw new IllegalArgumentException("9006");
        }
        message.setFolder(targetFolder);
        mailMessageRepository.save(message);
    }

    @Transactional
    public MailFolder createFolder(String userId, String name) {
        if (name == null || name.isEmpty()) {
            throw new IllegalArgumentException("9006");
        }
        MailFolder folder = new MailFolder();
        folder.setUserId(userId);
        folder.setName(name);
        return mailFolderRepository.save(folder);
    }

    @Transactional
    public List<MailFolder> getFolders(String userId) {
        return mailFolderRepository.findByUserId(userId);
    }

    public void deleteFolder(String userId, String folderId) {
        MailFolder folder = mailFolderRepository.findByFolderId(folderId)
                .orElseThrow(() -> new IllegalArgumentException("9006"));
        if (!folder.getUserId().equals(userId)) {
            throw new IllegalArgumentException("9006");
        }
        mailFolderRepository.delete(folder);
    }

    @Transactional
    public List<MailFilter> getFilters(String userId) {
        return mailFilterRepository.findByUserId(userId);
    }

    public MailFilter addFilter(String userId, String type, String addressPattern) {
        mailFilterRepository.findByUserIdAndTypeAndAddressPattern(userId, type, addressPattern)
                .ifPresent(f -> { throw new IllegalArgumentException("9008"); });
        MailFilter filter = new MailFilter();
        filter.setUserId(userId);
        filter.setType(type);
        filter.setAddressPattern(addressPattern);
        return mailFilterRepository.save(filter);
    }

    public List<MailRead> getDailyReads(String userId, int page, int size) {
        List<MailRead> reads = new ArrayList<>();
        String[] titles = {"技术前沿：2024年AI发展趋势", "产品设计：用户增长方法论", "创业故事：从0到1的心路历程", "行业洞察：数字化转型的最佳实践", "读书笔记：思考，快与慢"};
        String[] sources = {"知乎", "公众号", "掘金", "InfoQ", "豆瓣"};
        for (int i = 0; i < 5; i++) {
            MailRead read = new MailRead();
            read.setUserId(userId);
            read.setTitle(titles[i]);
            read.setSource(sources[i]);
            read.setUrl("https://example.com/article/" + i);
            read.setIsFavorited(i == 0);
            read.setReadAt(LocalDateTime.now().minusDays(i));
            reads.add(read);
        }
        int start = Math.min(page * size, reads.size());
        int end = Math.min(start + size, reads.size());
        if (start >= reads.size()) {
            return new ArrayList<>();
        }
        return reads.subList(start, end);
    }
}
