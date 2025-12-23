package com.chamakk.auth.service;

import org.springframework.stereotype.Service;

import com.chamakk.auth.dto.AdminProfileResponse;
import com.chamakk.auth.entity.User;
import com.chamakk.auth.entity.UserTokens;
import com.chamakk.auth.repository.UserTokenRepository;

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
