package com.chamakk.auth.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.UUID;
import java.util.List;

@Entity
@Table(name = "users", uniqueConstraints = {
        @UniqueConstraint(name = "users_email_key", columnNames = "email"),
        @UniqueConstraint(name = "users_mobile_key", columnNames = "mobile")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "user_id", nullable = false, updatable = false)
    private UUID userId;

    @Column(name = "full_name", length = 100)
    private String fullName;

    @Column(name = "email", length = 120, nullable = false)
    private String email;

    @Column(name = "mobile", length = 15, nullable = false)
    private String mobile;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "created_at")
    private OffsetDateTime createdAt;

    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;

    @Column(name = "password_hash")
    private String passwordHash; // only ADMIN uses this

    private String role; // ADMIN / CUSTOMER

    // Optional: one user can have many tokens
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<UserTokens> tokens;
}
