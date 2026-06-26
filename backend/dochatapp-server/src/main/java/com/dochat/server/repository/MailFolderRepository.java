package com.dochat.server.repository;

import com.dochat.server.model.MailFolder;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MailFolderRepository extends JpaRepository<MailFolder, Long> {
    List<MailFolder> findByUserId(String userId);
    Optional<MailFolder> findByFolderId(String folderId);
}
