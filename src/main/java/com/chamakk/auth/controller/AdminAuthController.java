package com.chamakk.auth.controller;

import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.auth.dto.AdminLoginRequest;
import com.chamakk.auth.dto.AdminLoginResponse;
import com.chamakk.auth.service.AdminAuthService;

@RestController
@RequestMapping("api/auth/admin")
public class AdminAuthController {

    private final AdminAuthService adminAuthService;

    public AdminAuthController(AdminAuthService adminAuthService) {
        this.adminAuthService = adminAuthService;
    }

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
