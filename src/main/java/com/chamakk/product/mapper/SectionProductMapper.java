package com.chamakk.product.mapper;

import com.chamakk.product.dto.SectionProductResponseDto;
import com.chamakk.product.entity.ProductSectionProduct;

public class SectionProductMapper {

    public static SectionProductResponseDto toResponse(ProductSectionProduct entity) {
        return SectionProductResponseDto.builder()
                .id(entity.getProductSectionProductsId())
                .sectionId(entity.getSection().getSectionId())
                .productId(entity.getProducts().getProductId())
                .displayOrder(entity.getDisplayOrder())
                .isActive(entity.getIsActive())
                .build();
    }
}
