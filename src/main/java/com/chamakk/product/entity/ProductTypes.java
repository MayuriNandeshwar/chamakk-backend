package com.chamakk.product.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_types")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductTypes {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "product_type_id", updatable = false, nullable = false)
    private UUID productTypeId;

    @Column(name = "product_type_name", nullable = false, unique = true, length = 120)
    private String productTypeName;

    @Column(name = "product_type_description", columnDefinition = "text")
    private String productTypeDescription;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;
}