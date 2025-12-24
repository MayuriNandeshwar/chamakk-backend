package com.chamakk.product.repository;

import com.chamakk.product.entity.Categories;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface CategoryRepository extends JpaRepository<Categories, UUID> {

    boolean existsBySlug(String slug);
}
