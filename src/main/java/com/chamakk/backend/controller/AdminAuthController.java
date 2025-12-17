package com.chamakk.backend.controller;

import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.backend.dtos.AdminLoginRequest;
import com.chamakk.backend.dtos.AdminLoginResponse;
import com.chamakk.backend.service.AdminAuthService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("api/auth/admin")
@RequiredArgsConstructor
public class AdminAuthController {

    private final AdminAuthService adminAuthService;

    @PostMapping("/login")
    public ResponseEntity<AdminLoginResponse> login(
            @RequestBody AdminLoginRequest request) {

        AdminLoginResponse response = adminAuthService.login(
                request.getEmail(),
                request.getPassword(),
                request.getDeviceId());

        return ResponseEntity.ok(response);
    }

}
