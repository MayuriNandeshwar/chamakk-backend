package com.chamakk.product.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Bestseller product DTO
 * Version: v1.0
 * Contract frozen - do not change field names without version bump
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BestsellerProductDto {

    @JsonProperty("productId")
    private UUID productId;

    @JsonProperty("productName")
    private String productName;

    @JsonProperty("slug")
    private String slug;

    @JsonProperty("sku")
    private String sku;

    @JsonProperty("price")
    private BigDecimal price;

    @JsonProperty("mrp")
    private BigDecimal mrp;

    @JsonProperty("discountPercentage")
    private BigDecimal discountPercentage;

    @JsonProperty("imageUrl")
    private String imageUrl;

    @JsonProperty("inStock")
    private Boolean inStock;
}