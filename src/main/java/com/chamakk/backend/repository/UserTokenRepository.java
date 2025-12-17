package com.chamakk.backend.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import com.chamakk.backend.model.UserTokens;
import java.util.Optional;

public interface UserTokenRepository extends JpaRepository<UserTokens, UUID> {

    @Modifying
    @Transactional
    @Query("""
                UPDATE UserTokens t
                SET t.status = 'REVOKED'
                WHERE t.user.userId = :userId
                  AND t.status = 'ACTIVE'
            """)
    void revokeAllActiveTokens(UUID userId);

    Optional<UserTokens> findByJwtTokenAndStatus(String jwt, String status);

    Optional<UserTokens> findByUser_UserIdAndDeviceIdAndStatus(
            UUID userId, String deviceId, String status);
}
