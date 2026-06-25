package com.dochat.server.repository;

import com.dochat.server.model.HouseFavorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HouseFavoriteRepository extends JpaRepository<HouseFavorite, Long> {

    List<HouseFavorite> findByUserId(String userId);

    HouseFavorite findByUserIdAndHouseId(String userId, String houseId);

    boolean existsByUserIdAndHouseId(String userId, String houseId);

    void deleteByUserIdAndHouseId(String userId, String houseId);
}
