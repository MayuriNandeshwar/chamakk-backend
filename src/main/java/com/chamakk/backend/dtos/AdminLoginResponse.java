package com.chamakk.backend.dtos;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class AdminLoginResponse {

    private String fullName;
    private String accessToken;
    private String refreshToken;
    private String tokenType; // Bearer
    private long expiresIn; // seconds
}
