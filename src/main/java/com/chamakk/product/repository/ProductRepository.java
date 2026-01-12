package com.chamakk.product.repository;

import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ProductRepository extends JpaRepository<Products, UUID> {

    Optional<Products> findBySlug(String slug);

    boolean existsBySlug(String slug);
}
