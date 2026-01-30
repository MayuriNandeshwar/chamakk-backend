package com.chamakk.product.service.admin;

import com.chamakk.product.dto.admin.*;
import com.chamakk.product.entity.*;
import com.chamakk.product.repository.*;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminProductService {

        private final ProductRepository productRepo;
        private final CategoryRepository categoryRepo;
        private final ProductImageRepository imageRepo;
        private final ProductVariantRepository variantRepo;
        private final ProductEntityAttributeRepository attributeRepo;

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

        /*
         * =========================
         * PRODUCT LIST (TABLE VIEW)
         * =========================
         */
        public List<AdminProductListDto> getAllProducts() {

                return productRepo.findAll().stream()
                                .map(product -> AdminProductListDto.builder()
                                                .productId(product.getProductId())
                                                .name(product.getProductName())
                                                .thumbnail(
                                                                imageRepo.findPrimaryImageUrl(product.getProductId())
                                                                                .orElse(null))
                                                .basePrice(
                                                                variantRepo.findDefaultVariantPrice(
                                                                                product.getProductId())
                                                                                .orElse(null))
                                                .status(product.isActive() ? "PUBLISHED" : "DRAFT")
                                                .updatedAt(product.getUpdatedAt())
                                                .build())
                                .toList();
        }

        /*
         * =========================
         * PRODUCT DETAIL (EDIT PAGE)
         * =========================
         */
        public AdminProductDetailDto getProduct(UUID productId) {

                Products product = productRepo.findById(productId)
                                .orElseThrow(() -> new RuntimeException("Product not found"));

                return AdminProductDetailDto.builder()
                                .productId(product.getProductId())
                                .name(product.getProductName())
                                .slug(product.getSlug())
                                .description(product.getProductDescription())
                                .status(product.isActive() ? "PUBLISHED" : "DRAFT")

                                .variants(
                                                variantRepo.findByProducts_ProductId(productId)
                                                                .stream()
                                                                .map(v -> AdminProductDetailDto.VariantDto.builder()
                                                                                .variantId(v.getVariantId())
                                                                                .title(v.getVariantTitle())
                                                                                .price(v.getPrice())
                                                                                .mrp(v.getMrp())
                                                                                .weightGrams(v.getWeightGrams())
                                                                                .isDefault(v.isDefault())
                                                                                .build())
                                                                .toList())

                                .attributes(
                                                attributeRepo.findByProducts_ProductId(productId)
                                                                .stream()
                                                                .map(a -> new AdminProductDetailDto.AttributeDto(
                                                                                a.getAttribute().getName(),
                                                                                a.getValueText()))
                                                                .toList())

                                .images(
                                                imageRepo.findByProducts_ProductIdOrderByPositionAsc(productId)
                                                                .stream()
                                                                .map(img -> AdminProductDetailDto.ImageDto.builder()
                                                                                .imageId(img.getProductImageId())
                                                                                .url(img.getProductImageUrl())
                                                                                .position(img.getPosition())
                                                                                .isPrimary(img.isPrimary())
                                                                                .build())
                                                                .toList())
                                .build();
        }
}
