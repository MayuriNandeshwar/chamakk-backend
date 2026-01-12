package com.chamakk.product.repository.publicapi;

import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PublicProductRepository
        extends JpaRepository<Products, UUID> {

    Optional<Products> findBySlugAndIsActiveTrue(String slug);
}
