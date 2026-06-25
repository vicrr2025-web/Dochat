package com.dochat.server.repository;

import com.dochat.server.model.MallProduct;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MallProductRepository extends JpaRepository<MallProduct, Long> {
    Optional<MallProduct> findByProductId(String productId);
    Page<MallProduct> findByCategory(String category, Pageable pageable);
    Page<MallProduct> findByTitleContaining(String keyword, Pageable pageable);
}
