package com.dochat.server.repository;

import com.dochat.server.model.House;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HouseRepository extends JpaRepository<House, Long> {

    Optional<House> findByHouseId(String houseId);

    Page<House> findByType(String type, Pageable pageable);

    Page<House> findByTypeAndStatus(String type, String status, Pageable pageable);

    Page<House> findByPublisherId(String publisherId, Pageable pageable);

    List<House> findByPublisherId(String publisherId);

    Page<House> findByTypeAndSubType(String type, String subType, Pageable pageable);
    Page<House> findByTypeAndAddressContaining(String type, String address, Pageable pageable);

}
