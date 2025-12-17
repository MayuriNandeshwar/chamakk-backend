package com.chamakk.backend.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminLoginRequest {

    private String email;
    private String password;
    private String deviceId;
}
