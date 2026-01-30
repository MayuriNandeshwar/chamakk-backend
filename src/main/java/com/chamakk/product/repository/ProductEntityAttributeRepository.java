package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductEntityAttribute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductEntityAttributeRepository
        extends JpaRepository<ProductEntityAttribute, UUID> {

    List<ProductEntityAttribute> findByProducts_ProductId(UUID productId);

    List<ProductEntityAttribute> findByVariant_VariantId(UUID variantId);

    void deleteByProducts_ProductId(UUID productId);

    void deleteByVariant_VariantId(UUID variantId);
}
