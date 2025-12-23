package com.chamakk.product.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "variant_attributes")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VariantAttributes {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "attribute_id", nullable = false, updatable = false)
    private UUID attributeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariants variant;

    @Column(name = "attribute_name", nullable = false, length = 120)
    private String attributeName;

    @Column(name = "attribute_value", length = 500)
    private String attributeValue;

    @CreationTimestamp
    @Column(name = "created_at")
    private OffsetDateTime createdAt;
}
