package com.chamakk.backend.service;

import java.security.Key;
import java.time.OffsetDateTime;
import java.util.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.chamakk.backend.model.User;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

    private final Key signingKey;
    private final long jwtExpirationMinutes;
    private final long refreshExpirationDays;

    public JwtService(
            @Value("${security.jwt.secret}") String secret,
            @Value("${security.jwt.expiration-minutes}") long jwtExpirationMinutes,
            @Value("${security.jwt.refresh-expiration-days}") long refreshExpirationDays) {

        this.signingKey = Keys.hmacShaKeyFor(secret.getBytes());
        this.jwtExpirationMinutes = jwtExpirationMinutes;
        this.refreshExpirationDays = refreshExpirationDays;
    }

    // 🔹 Generate Access Token
    public String generateToken(User user) {
        Date now = new Date();
        Date expiry = Date.from(
                OffsetDateTime.now().plusMinutes(jwtExpirationMinutes).toInstant());

        return Jwts.builder()
                .setSubject(user.getUserId().toString())
                .claim("role", user.getRole())
                .claim("email", user.getEmail())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    // 🔹 Generate Refresh Token
    public String generateRefreshToken(User user) {
        Date expiry = Date.from(
                OffsetDateTime.now().plusDays(refreshExpirationDays).toInstant());

        return Jwts.builder()
                .setSubject(user.getUserId().toString())
                .setExpiration(expiry)
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    // 🔹 Extract Claims
    public Claims extractClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public String extractUserId(String token) {
        return extractClaims(token).getSubject();
    }

    public String extractRole(String token) {
        return extractClaims(token).get("role", String.class);
    }

    public boolean isTokenExpired(String token) {
        return extractClaims(token).getExpiration().before(new Date());
    }
}
