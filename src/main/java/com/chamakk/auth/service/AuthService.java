package com.chamakk.auth.service;

import java.net.InetAddress;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.AccessDeniedException;

import com.chamakk.auth.dto.LoginRequest;
import com.chamakk.auth.dto.LoginResponse;
import com.chamakk.auth.entity.User;
import com.chamakk.auth.entity.UserSession;
import com.chamakk.auth.repository.UserRepository;
import com.chamakk.auth.repository.UserSessionRepository;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class AuthService {

        private final UserRepository userRepository;
        private final UserSessionRepository userSessionRepository;
        private final PasswordEncoder passwordEncoder;
        private final JwtService jwtService;

        public LoginResponse login(LoginRequest request, HttpServletRequest httpRequest) {

                User user = userRepository
                                .findByEmailOrMobile(request.getIdentifier(), request.getIdentifier())
                                .orElseThrow(() -> new BadCredentialsException("Invalid credentials"));

                if (!user.isActive()) {
                        throw new AccessDeniedException("User is inactive");
                }

                if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {

                        throw new BadCredentialsException("Invalid credentials");
                }

                List<String> roles = user.getUserRoles()
                                .stream()
                                .map(ur -> ur.getRole().getRoleName())
                                .toList();

                String accessToken = jwtService.generateAccessToken(
                                user.getUserId(),
                                roles);
                InetAddress ipAddress = resolveClientIp(httpRequest);

                UserSession session = UserSession.builder()
                                .user(user)
                                .status("ACTIVE")
                                .deviceType("WEB")
                                .deviceId("WEB-" + UUID.randomUUID())
                                .refreshToken(UUID.randomUUID().toString())
                                .createdAt(OffsetDateTime.now())
                                .expiresAt(OffsetDateTime.now().plusDays(7))
                                .ipAddress(ipAddress) // ✅ inet-compatible
                                .userAgent(httpRequest.getHeader("User-Agent"))
                                .build();

                userSessionRepository.save(session);

                return new LoginResponse(
                                user.getUserId(),
                                roles,
                                accessToken);
        }

        private InetAddress resolveClientIp(HttpServletRequest request) {
                try {
                        String forwarded = request.getHeader("X-Forwarded-For");
                        String ip = (forwarded != null && !forwarded.isBlank())
                                        ? forwarded.split(",")[0].trim()
                                        : request.getRemoteAddr();

                        return InetAddress.getByName(ip);
                } catch (Exception ex) {
                        return null; // NEVER break login due to IP resolution
                }
        }

}
