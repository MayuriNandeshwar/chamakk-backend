package com.chamakk.product.dto;

import lombok.Getter;

import java.util.List;
import java.util.UUID;

@Getter
public class ProductRequest {

    private String skuBase;
    private String productName;
    private String slug;
    private String shortDescription;
    private String productDescription;
    private String brand;
    private String searchKeywords;

    private UUID categoryId;
    private UUID productTypeId;

    private List<UUID> tagIds;
}
