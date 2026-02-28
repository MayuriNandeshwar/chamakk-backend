package com.chamakk.product.controller.admin;

import com.chamakk.product.dto.admin.*;
import com.chamakk.product.service.admin.AdminProductTypeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/admin/product-types")
@RequiredArgsConstructor
public class AdminProductTypeController {

    private final AdminProductTypeService service;

    @PostMapping
    public UUID create(@RequestBody @Valid ProductTypeCreateDto dto) {
        return service.create(dto);
    }

    @GetMapping
    public List<ProductTypeResponseDto> getAll() {
        return service.getAll();
    }

    @GetMapping("/{id}")
    public ProductTypeResponseDto getById(@PathVariable UUID id) {
        return service.getById(id);
    }

    @PutMapping("/{id}")
    public void update(@PathVariable UUID id,
            @RequestBody @Valid ProductTypeUpdateDto dto) {
        service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable UUID id) {
        service.delete(id);
    }
}
