package com.chamakk.model;

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

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;
}
