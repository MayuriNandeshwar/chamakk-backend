package com.chamakk.auth.service;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.chamakk.auth.dto.AdminLoginResponse;
import com.chamakk.auth.entity.User;
import com.chamakk.auth.entity.UserTokens;
import com.chamakk.auth.repository.UserRepository;
import com.chamakk.auth.repository.UserTokenRepository;
import com.chamakk.config.JwtUtil;

@Service
@RequiredArgsConstructor



public class AdminAuthService {

        private final UserRepository userRepository;
        private final UserTokenRepository userTokenRepository;
        private final PasswordEncoder passwordEncoder;
        private final JwtUtil jwtUtil;

        public AdminLoginResponse login(String email, String password, String deviceId) {

                User user = userRepository.findByEmail(email)
                                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

                if (!"ROLE_ADMIN".equals(user.getRole())) {
                        throw new RuntimeException("Access denied");
                }

                if (!passwordEncoder.matches(password, user.getPasswordHash())) {
                        throw new RuntimeException("Invalid credentials");
                }

                // 🔒 ONE-DEVICE LOGIN
                userTokenRepository.revokeAllActiveTokens(user.getUserId());

                // 🔐 Generate Tokens
                String accessToken = jwtUtil.generateAccessToken(user.getUserId().toString(), user.getRole());

                String refreshToken = jwtUtil.generateRefreshToken(user.getUserId().toString());

                // 💾 Save Token
                UserTokens token = UserTokens.builder()
                                .user(user)
                                .deviceId(deviceId)
                                .jwtToken(accessToken)
                                .refreshToken(refreshToken)
                                .status("ACTIVE")
                                .createdAt(OffsetDateTime.now())
                                .expiresAt(jwtUtil.extractExpiry(accessToken))
                                .build();

                userTokenRepository.save(token);

                return AdminLoginResponse.builder()
                                .fullName(user.getFullName())
                                .accessToken(accessToken)
                                .refreshToken(refreshToken)
                                .tokenType("Bearer")
                                .expiresIn(jwtUtil.getAccessTokenExpirySeconds())
                                .build();
        }

}
