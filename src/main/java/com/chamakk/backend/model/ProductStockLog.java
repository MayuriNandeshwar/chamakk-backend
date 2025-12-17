package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "product_stock_log")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductStockLog {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "log_id", updatable = false, nullable = false)
    private UUID logId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "variant_id", nullable = false)
    private ProductVariants variant;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", referencedColumnName = "user_id")
    private User changedBy;

    @Column(name = "change_type", length = 60)
    private String changeType;

    @Column(name = "change_amount")
    private Integer changeAmount;

    @Column(columnDefinition = "text")
    private String note;

    @CreationTimestamp
    private OffsetDateTime createdAt;
}
