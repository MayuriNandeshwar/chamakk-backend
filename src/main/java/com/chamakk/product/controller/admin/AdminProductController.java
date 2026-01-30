package com.chamakk.product.controller.admin;

import java.util.List;
import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.product.dto.admin.AdminProductCreateDto;
import com.chamakk.product.dto.admin.AdminProductDetailDto;
import com.chamakk.product.dto.admin.AdminProductListDto;
import com.chamakk.product.dto.admin.AdminVariantCreateDto;
import com.chamakk.product.service.admin.AdminProductPublishService;
import com.chamakk.product.service.admin.AdminProductService;
import com.chamakk.product.service.admin.AdminVariantService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/products")
@RequiredArgsConstructor
public class AdminProductController {

    private final AdminProductService productService;
    private final AdminVariantService variantService;
    private final AdminProductPublishService publishService;

    @PostMapping
    public UUID createProduct(
            @RequestBody @Valid AdminProductCreateDto dto) {
        return productService.createProduct(dto);
    }

    @GetMapping
    public List<AdminProductListDto> getAllProducts() {
        return productService.getAllProducts();
    }

    @GetMapping("/{productId}")
    public AdminProductDetailDto getProduct(@PathVariable UUID productId) {
        return productService.getProduct(productId);
    }

    @PostMapping("/{productId}/variants")
    public void addVariant(
            @PathVariable UUID productId,
            @RequestBody @Valid AdminVariantCreateDto dto) {
        variantService.addVariant(productId, dto);
    }

    @PutMapping("/{productId}/publish")
    public void publish(@PathVariable UUID productId) {
        publishService.publish(productId);
    }
}
