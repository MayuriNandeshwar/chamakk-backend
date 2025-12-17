package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "products", uniqueConstraints = {
        @UniqueConstraint(name = "products_slug_key", columnNames = { "slug" })
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Products {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "product_id", updatable = false, nullable = false)
    private UUID productId;

    @Column(name = "sku_base")
    private String skuBase;

    @Column(name = "product_name")
    private String productName;

    @Column(name = "slug")
    private String slug;

    @Column(name = "short_description")
    private String shortDescription;

    @Column(name = "product_description", columnDefinition = "text")
    private String productDescription;

    @Column(name = "brand")
    private String brand;

    @Column(name = "search_keywords")
    private String searchKeywords;

    @ManyToMany
    @JoinTable(name = "product_tags", joinColumns = @JoinColumn(name = "product_id"), inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private List<Tags> tags;

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

    // search_vector (tsvector)
    @Column(name = "search_vector", columnDefinition = "tsvector")
    private String searchVector;

    // ---------- RELATIONSHIPS ----------

    // product_type_id → product_types
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_type_id", referencedColumnName = "product_type_id", foreignKey = @ForeignKey(name = "fk_product_types"))
    private ProductTypes productType;

    // category_id → categories

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", referencedColumnName = "category_id", foreignKey = @ForeignKey(name = "fk_products_category"))
    private Categories category;
}
