package com.dochat.server.repository;

import com.dochat.server.model.UserDevice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserDeviceRepository extends JpaRepository<UserDevice, Long> {
    List<UserDevice> findByUserId(String userId);
    Optional<UserDevice> findByDeviceId(String deviceId);
    void deleteByUserIdAndDeviceIdNot(String userId, String deviceId);
}
