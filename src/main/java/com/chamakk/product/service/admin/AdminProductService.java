package com.chamakk.product.service.admin;

import com.chamakk.product.dto.admin.*;
import com.chamakk.product.entity.*;
import com.chamakk.product.repository.*;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AdminProductService {

    private final ProductRepository productRepo;
    private final CategoryRepository categoryRepo;

    @Transactional
    public UUID createProduct(AdminProductCreateDto dto) {

        Categories category = categoryRepo.findById(dto.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Category not found"));

        Products product = Products.builder()
                .productName(dto.getProductName())
                .slug(generateSlug(dto.getProductName()))
                .categories(category)
                .brand(dto.getBrand())
                .shortDescription(dto.getShortDescription())
                .productDescription(dto.getDescription())
                .seoTitle(dto.getSeoTitle())
                .seoDescription(dto.getSeoDescription())
                .seoKeywords(dto.getSeoKeywords())
                .isActive(false) // DRAFT
                .createdAt(OffsetDateTime.now())
                .updatedAt(OffsetDateTime.now())
                .build();

        return productRepo.save(product).getProductId();
    }

    private String generateSlug(String name) {
        return name.toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("(^-|-$)", "");
    }
}
