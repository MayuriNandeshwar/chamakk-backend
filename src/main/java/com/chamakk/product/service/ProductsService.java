package com.chamakk.product.service;

import com.chamakk.product.dto.ProductRequest;
import com.chamakk.product.dto.ProductResponse;
import com.chamakk.product.entity.*;
import com.chamakk.product.repository.*;
import com.chamakk.order.repository.OrderItemsRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class ProductsService {

    private final ProductsRepository productsRepository;
    private final CategoryRepository categoryRepository;
    private final ProductTypeRepository productTypeRepository;
    private final TagsRepository tagsRepository;
    private final OrderItemsRepository orderItemsRepository;

    // ---------------- CREATE ----------------
    public ProductResponse create(ProductRequest req) {

        if (productsRepository.existsBySlug(req.getSlug())) {
            throw new RuntimeException("Slug already exists");
        }

        Categories category = categoryRepository.findById(req.getCategoryId())
                .orElseThrow(() -> new RuntimeException("Invalid category"));

        ProductTypes productType = productTypeRepository.findById(req.getProductTypeId())
                .orElseThrow(() -> new RuntimeException("Invalid product type"));

        List<Tags> tags = tagsRepository.findAllById(req.getTagIds());

        Products p = Products.builder()
                .skuBase(req.getSkuBase())
                .productName(req.getProductName())
                .slug(req.getSlug())
                .shortDescription(req.getShortDescription())
                .productDescription(req.getProductDescription())
                .brand(req.getBrand())
                .searchKeywords(req.getSearchKeywords())
                .category(category)
                .productType(productType)
                .tags(tags)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .isActive(true)
                .build();

        productsRepository.save(p);

        return toResponse(p);
    }

    // ---------------- GET BY ID ----------------
    public ProductResponse getById(UUID id) {
        Products p = productsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        return toResponse(p);
    }

    // ---------------- MANUAL BESTSELLER SET ----------------
    public ProductResponse updateManualBestSeller(UUID id, boolean status) {

        Products p = productsRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        p.setIsBestsellerManual(status);
        p.setUpdatedAt(LocalDateTime.now());

        productsRepository.save(p);

        return toResponse(p);
    }

    // ---------------- GET BESTSELLERS ----------------
    public List<ProductResponse> getBestSellers() {

        // Manual bestsellers
        List<Products> manual = productsRepository.findByIsBestsellerManualTrue();
        List<Products> auto = productsRepository.findByIsBestsellerAutoTrue();
        

        // Auto bestsellers (from sales)
        List<UUID> bestIds = orderItemsRepository.findTopSellingProductIds();
        

        // Merge without duplicates
        Set<Products> merged = new LinkedHashSet<>();
        merged.addAll(manual);  // show manual first
        merged.addAll(auto);
        System.out.println("BESTSELLERS FOUND: " + merged.size());


        return merged.stream()
                .map(this::toResponse)
                .toList();
    }

    // ---------------- MAPPER ----------------
    private ProductResponse toResponse(Products p) {
        return ProductResponse.builder()
                .productId(p.getProductId())
                .skuBase(p.getSkuBase())
                .productName(p.getProductName())
                .slug(p.getSlug())
                .shortDescription(p.getShortDescription())
                .productDescription(p.getProductDescription())
                .brand(p.getBrand())
                .searchKeywords(p.getSearchKeywords())
                .categoryName(p.getCategory().getCategoryName())
                .productTypeName(p.getProductType().getProductTypeName())
                .tags(p.getTags().stream().map(Tags::getTagName).toList())
                .isActive(p.getIsActive())
                .createdAt(p.getCreatedAt())
                .updatedAt(p.getUpdatedAt())
                .build();
    }
}
