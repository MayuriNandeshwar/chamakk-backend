package com.chamakk.auth.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.auth.dto.LoginRequest;
import com.chamakk.auth.dto.LoginResponse;
import com.chamakk.auth.service.AuthService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
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
                System.out.println("LOGIN SUCCESS — RETURNING RESPONSE");
                System.out.println("Password chars:");
                request.getPassword().chars()
                                .forEach(c -> System.out.print("[" + c + "]"));
                System.out.println();

                ResponseCookie cookie = ResponseCookie.from("ACCESS_TOKEN", loginResponse.getAccessToken())
                                .httpOnly(true)
                                .secure(false) // dev
                                .sameSite("Strict")
                                .path("/")
                                .maxAge(1800)
                                .build();

                // ✅ THIS IS THE ONLY CORRECT WAY
                response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

                return ResponseEntity.ok(
                                loginResponse.withoutToken());
        }
}
