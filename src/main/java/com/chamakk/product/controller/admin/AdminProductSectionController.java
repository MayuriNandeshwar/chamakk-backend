package com.chamakk.product.controller.admin;

import com.chamakk.product.dto.ProductSectionRequestDto;
import com.chamakk.product.dto.ProductSectionResponseDto;
import com.chamakk.product.service.ProductSectionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/product-sections")
@RequiredArgsConstructor
public class AdminProductSectionController {

    private final ProductSectionService service;

    @PostMapping
    public ProductSectionResponseDto create(
            @Valid @RequestBody ProductSectionRequestDto dto) {
        return service.create(dto);
    }

    @PutMapping("/{sectionId}")
    public ProductSectionResponseDto update(
            @PathVariable UUID sectionId,
            @Valid @RequestBody ProductSectionRequestDto dto) {
        return service.update(sectionId, dto);
    }

    @GetMapping
    public List<ProductSectionResponseDto> getAll() {
        return service.getAll();
    }
}
