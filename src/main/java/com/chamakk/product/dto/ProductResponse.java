package com.chamakk.product.dto;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Builder
public class ProductResponse {

    private UUID productId;

    private String skuBase;
    private String productName;
    private String slug;
    private String shortDescription;
    private String productDescription;
    private String brand;
    private String searchKeywords;

    private String categoryName;
    private String productTypeName;

    private List<String> tags;

    private Boolean isActive;
    private Boolean isBestsellerManual;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
