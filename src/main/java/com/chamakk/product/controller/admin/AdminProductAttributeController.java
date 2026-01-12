package com.chamakk.product.controller.admin;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.product.dto.ProductAttributeCreateDto;
import com.chamakk.product.entity.ProductAttribute;
import com.chamakk.product.service.AdminProductAttributeService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/admin/attributes")
@RequiredArgsConstructor
public class AdminProductAttributeController {

    private final AdminProductAttributeService service;

    @PostMapping
    public ProductAttribute create(
            @Valid @RequestBody ProductAttributeCreateDto dto) {
        return service.create(dto);
    }
}
