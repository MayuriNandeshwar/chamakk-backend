package com.chamakk.product.service;

import com.chamakk.product.dto.ProductSectionRequestDto;
import com.chamakk.product.dto.ProductSectionResponseDto;

import java.util.List;
import java.util.UUID;

public interface ProductSectionService {

    ProductSectionResponseDto create(ProductSectionRequestDto dto);

    ProductSectionResponseDto update(UUID sectionId, ProductSectionRequestDto dto);

    List<ProductSectionResponseDto> getAll();

    List<ProductSectionResponseDto> getActiveSections();
}
