package com.chamakk.product.controller.publicapi;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.chamakk.product.dto.publicapi.PublicProductDetailDto;
import com.chamakk.product.service.publicapi.PublicProductService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/public/products")
@RequiredArgsConstructor
public class PublicProductController {

    private final PublicProductService service;

    @GetMapping("/{slug}")
    public PublicProductDetailDto getBySlug(
            @PathVariable String slug) {
        return service.getProductBySlug(slug);
    }
}
