package com.dochat.server.repository;

import com.dochat.server.model.MallCoupon;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MallCouponRepository extends JpaRepository<MallCoupon, Long> {
    Optional<MallCoupon> findByCouponId(String couponId);
}
