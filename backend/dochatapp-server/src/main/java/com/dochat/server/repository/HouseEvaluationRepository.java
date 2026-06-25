package com.dochat.server.repository;

import com.dochat.server.model.HouseEvaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HouseEvaluationRepository extends JpaRepository<HouseEvaluation, Long> {

    List<HouseEvaluation> findByUserIdAndType(String userId, String type);

    List<HouseEvaluation> findByUserId(String userId);
}
