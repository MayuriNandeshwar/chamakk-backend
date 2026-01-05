package com.chamakk.auth.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.auth.dto.LoginRequest;
import com.chamakk.auth.dto.LoginResponse;
import com.chamakk.auth.dto.RefreshResponse;
import com.chamakk.auth.service.AuthService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/auth/admin")
@RequiredArgsConstructor
public class AuthController {

        private final AuthService authService;

        @PostMapping("/login")
        public ResponseEntity<LoginResponse> login(
                        @RequestBody LoginRequest request,
                        HttpServletRequest httpRequest, HttpServletResponse response) {

                LoginResponse loginResponse = authService.login(request, httpRequest);

                ResponseCookie cookie = ResponseCookie.from("ACCESS_TOKEN", loginResponse.getAccessToken())
                                .httpOnly(true)
                                .secure(false) // dev
                                .sameSite("Lax")
                                .path("/")
                                .maxAge(1800)
                                .build();

                // ✅ THIS IS THE ONLY CORRECT WAY
                response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

                return ResponseEntity.ok(
                                loginResponse.withoutToken());
        }

        @PostMapping("/refresh")
        public ResponseEntity<RefreshResponse> refresh(
                        @CookieValue("REFRESH_TOKEN") String refreshToken,
                        HttpServletResponse response) {

                var result = authService.refresh(refreshToken);

                ResponseCookie accessCookie = ResponseCookie.from("ACCESS_TOKEN", result.accessToken())
                                .httpOnly(true)
                                .secure(false)
                                .sameSite("Lax")
                                .path("/")
                                .maxAge(1800)
                                .build();

                response.addHeader(HttpHeaders.SET_COOKIE, accessCookie.toString());

                return ResponseEntity.ok(
                                new RefreshResponse(result.userId(), result.roles()));
        }

        @PostMapping("/logout")
        public ResponseEntity<Void> logout(
                        @CookieValue("REFRESH_TOKEN") String refreshToken,
                        HttpServletResponse response) {

                authService.logout(refreshToken);

                ResponseCookie clearAccess = ResponseCookie.from("ACCESS_TOKEN", "")
                                .path("/")
                                .maxAge(0)
                                .build();

                ResponseCookie clearRefresh = ResponseCookie.from("REFRESH_TOKEN", "")
                                .path("/")
                                .maxAge(0)
                                .build();

                response.addHeader(HttpHeaders.SET_COOKIE, clearAccess.toString());
                response.addHeader(HttpHeaders.SET_COOKIE, clearRefresh.toString());

                return ResponseEntity.noContent().build();
        }

}
