package com.chamakk.product.controller.publicapi;

import com.chamakk.product.dto.ProductSectionResponseDto;
import com.chamakk.product.service.ProductSectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/public/product-sections")
@RequiredArgsConstructor
public class PublicProductSectionController {

    private final ProductSectionService service;

    @GetMapping
    public List<ProductSectionResponseDto> getActiveSections() {
        return service.getActiveSections();
    }
}
