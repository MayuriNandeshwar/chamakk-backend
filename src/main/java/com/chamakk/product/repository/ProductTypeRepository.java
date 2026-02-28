package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductTypes;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface ProductTypeRepository extends JpaRepository<ProductTypes, UUID> {

    boolean existsByProductTypeName(String name);

    Optional<ProductTypes> findByProductTypeName(String name);
}
