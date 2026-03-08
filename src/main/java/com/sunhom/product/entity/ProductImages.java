package com.sunhom.product.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_images")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductImages {

    @Id
    @GeneratedValue
    @Column(name = "product_image_id", columnDefinition = "uuid")
    private UUID productImageId;

    @ManyToOne(optional = false)
    @JoinColumn(name = "product_id", nullable = false)
    private Products products;

    @ManyToOne
    @JoinColumn(name = "variant_id")
    private ProductVariants productVariants;

    @Column(name = "product_image_url", nullable = false)
    private String productImageUrl;

    @Column(name = "alt_text")
    private String altText;

    private Integer position;

    @Column(name = "media_type")
    private String mediaType;

    @Column(name = "is_primary", nullable = false)
    private boolean isPrimary;

    // 🔥 NEW (Hover Image Support)
    @Column(name = "is_hover_image", nullable = false)
    private boolean isHoverImage;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Column(name = "width")
    private Integer width;

    @Column(name = "height")
    private Integer height;

    @Column(name = "url_thumbnail")
    private String urlThumbnail;

    @Column(name = "url_medium")
    private String urlMedium;

    @Column(name = "url_large")
    private String urlLarge;
}