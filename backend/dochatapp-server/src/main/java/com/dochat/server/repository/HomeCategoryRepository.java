package com.dochat.server.repository;

import com.dochat.server.model.HomeCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HomeCategoryRepository extends JpaRepository<HomeCategory, Long> {
    List<HomeCategory> findByLevelAndParentId(int level, String parentId);
    List<HomeCategory> findByLevel(int level);
}
