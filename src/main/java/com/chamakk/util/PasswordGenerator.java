package com.chamakk.util;

import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;

public class PasswordGenerator {

    public static void main(String[] args) {

        PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();

        String hash = passwordEncoder.encode("Admin@123");

        System.out.println("RAW PASSWORD  : Admin@123");
        System.out.println("HASHED PASSWORD : " + hash);
    }
}
