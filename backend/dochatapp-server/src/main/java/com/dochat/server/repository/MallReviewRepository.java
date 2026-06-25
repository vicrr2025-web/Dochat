package com.dochat.server.repository;

import com.dochat.server.model.MallReview;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface MallReviewRepository extends JpaRepository<MallReview, Long> {
    Optional<MallReview> findByReviewId(String reviewId);
    List<MallReview> findByOrderId(String orderId);
}
