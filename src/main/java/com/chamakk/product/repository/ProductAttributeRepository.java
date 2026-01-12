package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductAttribute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ProductAttributeRepository
        extends JpaRepository<ProductAttribute, UUID> {

    Optional<ProductAttribute> findByCode(String code);

    boolean existsByCode(String code);
}
