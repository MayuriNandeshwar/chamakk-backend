package com.chamakk.product.service;

import com.chamakk.product.dto.SectionProductRequestDto;
import com.chamakk.product.dto.SectionProductResponseDto;
import java.util.List;
import java.util.UUID;

public interface SectionProductService {

    SectionProductResponseDto addProductToSection(SectionProductRequestDto dto);

    List<SectionProductResponseDto> getProductsBySection(UUID sectionId);
}
