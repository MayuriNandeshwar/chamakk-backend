package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "product_variants", uniqueConstraints = {
        @UniqueConstraint(name = "product_variants_sku_key", columnNames = "sku")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductVariants {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "variant_id", nullable = false, updatable = false)
    private UUID variantId;

    @Column(name = "sku", nullable = false, length = 100)
    private String sku;

    @Column(name = "variant_title", length = 200)
    private String variantTitle;

    @Column(name = "fragrance", length = 150)
    private String fragrance;

    @Column(name = "weight_grams")
    private Integer weightGrams;

    @Column(name = "size_label", length = 50)
    private String sizeLabel;

    @Column(name = "color", length = 50)
    private String color;

    @Column(name = "burn_time_hours")
    private Integer burnTimeHours;

    @Column(name = "price")
    private Integer price;

    @Column(name = "mrp")
    private Integer mrp;

    @Column(name = "stock")
    private Integer stock;

    @Column(name = "reserved_stock")
    private Integer reservedStock;

    @Column(name = "low_stock_threshold")
    private Integer lowStockThreshold;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "created_by")
    private UUID createdBy;

    @Column(name = "updated_by")
    private UUID updatedBy;

    // Foreign key → product_id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", foreignKey = @ForeignKey(name = "fk_products"))
    private Products product;

    @OneToMany(mappedBy = "variant", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<VariantAttributes> attributes;
}
