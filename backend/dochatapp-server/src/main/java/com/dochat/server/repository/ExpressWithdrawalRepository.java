package com.dochat.server.repository;

import com.dochat.server.model.ExpressWithdrawal;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ExpressWithdrawalRepository extends JpaRepository<ExpressWithdrawal, Long> {
    List<ExpressWithdrawal> findByDriverId(String driverId);
}
