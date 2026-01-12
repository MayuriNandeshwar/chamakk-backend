package com.chamakk.product.repository.publicapi;

import com.chamakk.product.entity.ProductVariants;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PublicVariantRepository
        extends JpaRepository<ProductVariants, UUID> {

    List<ProductVariants> findByProducts_ProductIdAndIsActiveTrue(UUID productId);
}
