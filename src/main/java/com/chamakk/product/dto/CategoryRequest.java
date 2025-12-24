package com.chamakk.product.dto;

import lombok.Data;

import java.util.UUID;

@Data
public class CategoryRequest {

    private String categoryName;
    private String slug;
    private String description;
    private String imageUrl;
    private Boolean active;
    private UUID parentId; // optional parent category
}
