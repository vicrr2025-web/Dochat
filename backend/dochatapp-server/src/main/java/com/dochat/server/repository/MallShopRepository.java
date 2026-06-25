package com.dochat.server.repository;

import com.dochat.server.model.MallShop;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MallShopRepository extends JpaRepository<MallShop, Long> {
    Optional<MallShop> findByShopId(String shopId);
    Optional<MallShop> findByOwnerId(String ownerId);
}
