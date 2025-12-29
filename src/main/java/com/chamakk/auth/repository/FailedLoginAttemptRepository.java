package com.chamakk.auth.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.chamakk.auth.entity.FailedLoginAttempt;

public interface FailedLoginAttemptRepository
        extends JpaRepository<FailedLoginAttempt, UUID> {
}
