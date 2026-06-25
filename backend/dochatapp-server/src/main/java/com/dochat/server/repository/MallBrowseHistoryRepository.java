package com.dochat.server.repository;

import com.dochat.server.model.MallBrowseHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MallBrowseHistoryRepository extends JpaRepository<MallBrowseHistory, Long> {
    List<MallBrowseHistory> findByUserIdOrderByCreatedAtDesc(String userId);
    void deleteByUserId(String userId);
}
