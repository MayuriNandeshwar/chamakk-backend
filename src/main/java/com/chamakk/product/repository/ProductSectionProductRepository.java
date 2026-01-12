package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductSectionProduct;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductSectionProductRepository
        extends JpaRepository<ProductSectionProduct, UUID> {

    List<ProductSectionProduct> findBySection_SectionIdAndIsActiveTrueOrderByDisplayOrderAsc(UUID sectionId);

    boolean existsBySection_SectionIdAndProduct_ProductId(UUID sectionId, UUID productId);

    void deleteBySection_SectionId(UUID sectionId);
}
