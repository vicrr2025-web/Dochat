package com.dochat.server.repository;

import com.dochat.server.model.HouseAppointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HouseAppointmentRepository extends JpaRepository<HouseAppointment, Long> {

    List<HouseAppointment> findByUserId(String userId);

    List<HouseAppointment> findByHouseId(String houseId);

    List<HouseAppointment> findByUserIdAndType(String userId, String type);
}
