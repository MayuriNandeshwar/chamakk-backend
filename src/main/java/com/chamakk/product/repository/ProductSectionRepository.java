package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductSection;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ProductSectionRepository extends JpaRepository<ProductSection, UUID> {

    Optional<ProductSection> findByCode(String code);

    boolean existsByCode(String code);

    List<ProductSection> findByIsActiveTrueOrderByDisplayOrderAsc();
}
