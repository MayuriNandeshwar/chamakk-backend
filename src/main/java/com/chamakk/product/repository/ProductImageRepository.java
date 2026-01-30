package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductImages;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ProductImageRepository extends JpaRepository<ProductImages, UUID> {

    @Query("""
                select pi.productImageUrl
                from ProductImages pi
                where pi.products.productId = :productId
                  and pi.isPrimary = true
            """)
    Optional<String> findPrimaryImageUrl(@Param("productId") UUID productId);

    List<ProductImages> findByProducts_ProductIdOrderByPositionAsc(UUID productId);

    long countByProducts_ProductId(UUID productId);
}
