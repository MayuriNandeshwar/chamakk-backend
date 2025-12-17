package com.chamakk.backend.service;

import org.springframework.stereotype.Service;

import com.chamakk.backend.dtos.AdminProfileResponse;
import com.chamakk.backend.model.User;
import com.chamakk.backend.model.UserTokens;
import com.chamakk.backend.repository.UserTokenRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminSessionService {

    private final UserTokenRepository tokenRepository;

    public AdminProfileResponse getCurrentAdmin(String jwt) {

        UserTokens token = tokenRepository
                .findByJwtTokenAndStatus(jwt, "ACTIVE")
                .orElseThrow(() -> new RuntimeException("Unauthorized"));

        User user = token.getUser();

        return new AdminProfileResponse(
                user.getFullName(),
                user.getEmail(),
                user.getRole());
    }
}
