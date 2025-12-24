package com.chamakk.product.dto;

import lombok.Builder;
import lombok.Data;

import java.time.OffsetDateTime;
import java.util.UUID;

@Data
@Builder
public class CategoryResponse {

    private UUID categoryId;
    private UUID parentId;
    private String categoryName;
    private String slug;
    private String description;
    private String imageUrl;
    private Boolean active;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}
