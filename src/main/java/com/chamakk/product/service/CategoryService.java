package com.chamakk.product.service;

import com.chamakk.product.dto.CategoryRequest;
import com.chamakk.product.dto.CategoryResponse;
import com.chamakk.product.entity.Categories;
import com.chamakk.product.repository.CategoryRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;

    // CREATE CATEGORY
    public CategoryResponse create(CategoryRequest req) {

        if (categoryRepository.existsBySlug(req.getSlug())) {
            throw new RuntimeException("Category slug already exists");
        }

        Categories c = Categories.builder()
                .categoryName(req.getCategoryName())
                .slug(req.getSlug())
                .description(req.getDescription())
                .imageUrl(req.getImageUrl())
                .active(req.getActive() != null ? req.getActive() : true)
                .parentId(req.getParentId())
                .build();

        categoryRepository.save(c);

        return toResponse(c);
    }

    // UPDATE CATEGORY
    public CategoryResponse update(UUID id, CategoryRequest req) {
        Categories c = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        c.setCategoryName(req.getCategoryName());
        c.setSlug(req.getSlug());
        c.setDescription(req.getDescription());
        c.setImageUrl(req.getImageUrl());
        c.setActive(req.getActive());
        c.setParentId(req.getParentId());

        categoryRepository.save(c);

        return toResponse(c);
    }

    // DELETE CATEGORY
    public void delete(UUID id) {
        if (!categoryRepository.existsById(id)) {
            throw new RuntimeException("Category not found");
        }
        categoryRepository.deleteById(id);
    }

    // GET BY ID
    public CategoryResponse getById(UUID id) {
        Categories c = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));
        return toResponse(c);
    }

    // GET ALL
    public List<CategoryResponse> getAll() {
        return categoryRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    private CategoryResponse toResponse(Categories c) {
        return CategoryResponse.builder()
                .categoryId(c.getCategoryId())
                .parentId(c.getParentId())
                .categoryName(c.getCategoryName())
                .slug(c.getSlug())
                .description(c.getDescription())
                .imageUrl(c.getImageUrl())
                .active(c.getActive())
                .createdAt(c.getCreatedAt())
                .updatedAt(c.getUpdatedAt())
                .build();
    }
}
