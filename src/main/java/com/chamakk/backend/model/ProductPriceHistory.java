package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_price_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductPriceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "product_price_history_id", updatable = false, nullable = false)
    private UUID productPriceHistoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", referencedColumnName = "variant_id", nullable = false)
    private ProductVariants variant;

    @Column(name = "old_price")
    private Integer oldPrice;

    @Column(name = "new_price")
    private Integer newPrice;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", referencedColumnName = "user_id")
    private User changedBy;

    @CreationTimestamp
    private OffsetDateTime changedAt;
}
