package com.chamakk.model;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_variants")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductVariants {

    @Id
    @GeneratedValue
    @Column(name = "variant_id", columnDefinition = "uuid")
    private UUID variantId;

    @ManyToOne(optional = false)
    @JoinColumn(name = "product_id", nullable = false)
    private Products products;

    @Column(nullable = false, unique = true, length = 100)
    private String sku;

    @Column(name = "variant_title")
    private String variantTitle;

    private String fragrance;

    @Column(name = "weight_grams")
    private Integer weightGrams;

    @Column(name = "size_label")
    private String sizeLabel;

    private String color;

    @Column(name = "burn_time_hours")
    private Integer burnTimeHours;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(precision = 10, scale = 2)
    private BigDecimal mrp;

    @Column(name = "is_active", nullable = false)
    private boolean isActive;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @Column(name = "deleted_at")
    private OffsetDateTime deletedAt;

    @Column(name = "created_by")
    private UUID createdBy;

    @Column(name = "updated_by")
    private UUID updatedBy;
}
