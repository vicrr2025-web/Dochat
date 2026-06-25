package com.dochat.server.repository;

import com.dochat.server.model.HouseVip;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface HouseVipRepository extends JpaRepository<HouseVip, Long> {

    Optional<HouseVip> findByUserId(String userId);
}
