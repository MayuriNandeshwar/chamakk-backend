package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductImages;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductImageRepository
        extends JpaRepository<ProductImages, UUID> {

    List<ProductImages> findByProducts_ProductIdOrderByPositionAsc(UUID productId);

    long countByProducts_ProductId(UUID productId);

    void deleteByProducts_ProductId(UUID productId);
}
