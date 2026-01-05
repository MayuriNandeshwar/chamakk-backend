package com.chamakk.product.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_types")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductTypes {

    @Id
    @GeneratedValue
    @Column(name = "product_type_id", columnDefinition = "uuid")
    private UUID productTypeId;

    @Column(name = "product_type_name", nullable = false, unique = true)
    private String productTypeName;

    @Column(name = "product_type_description")
    private String productTypeDescription;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;
}
