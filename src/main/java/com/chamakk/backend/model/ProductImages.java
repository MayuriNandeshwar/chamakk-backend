package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.util.UUID;

import java.time.OffsetDateTime;

@Entity
@Table(name = "product_images")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductImages {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "product_image_id", updatable = false, nullable = false)
    private UUID productImageId;

    // MANY DISCOUNTS can belong to ONE PRODUCT
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", referencedColumnName = "product_id", nullable = false)
    private Products product;

    // MANY DISCOUNTS can belong to ONE Variant
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", referencedColumnName = "variant_id", nullable = false)
    private ProductVariants variant;

    @Column(name = "product_image_url", nullable = false, length = 1000)
    private String imageUrl;

    @Column(name = "alt_text", length = 500)
    private String altText;

    @Builder.Default
    @Column(name = "position")
    private Integer position = 0;

    @CreationTimestamp
    private OffsetDateTime createdAt;

    @Builder.Default
    @Column(name = "media_type", length = 20)
    private String mediaType = "image"; // image | video | gif
}
