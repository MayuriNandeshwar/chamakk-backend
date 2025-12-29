package com.chamakk.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "products")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Products {

    @Id
    @GeneratedValue
    @Column(name = "product_id", columnDefinition = "uuid")
    private UUID productId;

    @Column(name = "sku_base", length = 100)
    private String skuBase;

    @Column(name = "product_name", nullable = false)
    private String productName;

    @Column(nullable = false, unique = true)
    private String slug;

    @Column(name = "short_description")
    private String shortDescription;

    @Column(name = "product_description")
    private String productDescription;

    private String brand;

    @Column(name = "search_keywords")
    private String searchKeywords;

    @Column(name = "is_active", nullable = false)
    private boolean isActive;

    @Column(name = "is_featured", nullable = false)
    private boolean isFeatured;

    @Column(name = "is_manual_bestseller", nullable = false)
    private boolean isManualBestseller;

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

    @Column(name = "search_vector", columnDefinition = "tsvector", insertable = false, updatable = false)
    private String searchVector; // mapped as String (read-only usage)

    @ManyToOne(optional = false)
    @JoinColumn(name = "product_type_id", nullable = false)
    private ProductTypes productType;

    @ManyToOne(optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Categories categories;

    @Column(name = "seo_title")
    private String seoTitle;

    @Column(name = "seo_description")
    private String seoDescription;

    @Column(name = "seo_keywords")
    private String seoKeywords;
}
