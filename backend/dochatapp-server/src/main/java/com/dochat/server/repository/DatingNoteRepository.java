package com.dochat.server.repository;

import com.dochat.server.model.DatingNote;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DatingNoteRepository extends JpaRepository<DatingNote, Long> {
    List<DatingNote> findByToUserIdOrderByCreatedAtDesc(String userId);
    List<DatingNote> findByFromUserIdOrderByCreatedAtDesc(String userId);
}
