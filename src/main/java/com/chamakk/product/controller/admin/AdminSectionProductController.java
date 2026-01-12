package com.chamakk.product.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import com.chamakk.product.dto.SectionProductRequestDto;
import com.chamakk.product.dto.SectionProductResponseDto;
import com.chamakk.product.service.SectionProductService;

@RestController
@RequestMapping("/api/admin/section-products")
@RequiredArgsConstructor
public class AdminSectionProductController {

    private final SectionProductService service;

    @PostMapping
    public SectionProductResponseDto addProduct(
            @Valid @RequestBody SectionProductRequestDto dto) {
        return service.addProductToSection(dto);
    }

    @GetMapping("/{sectionId}")
    public List<SectionProductResponseDto> getBySection(
            @PathVariable UUID sectionId) {
        return service.getProductsBySection(sectionId);
    }
}
