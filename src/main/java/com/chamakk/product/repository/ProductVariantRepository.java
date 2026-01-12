package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductVariants;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ProductVariantRepository
        extends JpaRepository<ProductVariants, UUID> {

    long countByProducts_ProductIdAndIsActiveTrue(UUID productId);

    long countByProducts_ProductIdAndIsDefaultTrue(UUID productId);
}
