package com.chamakk.backend.dtos;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class AdminProfileResponse {
    private String fullName;
    private String email;
    private String role;
}