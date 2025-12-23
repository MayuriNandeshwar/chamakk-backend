package com.chamakk.product.repository;

import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import java.util.UUID;

public interface ProductsRepository extends JpaRepository<Products, UUID> {

    boolean existsBySlug(String slug);
    List<Products> findByIsBestsellerManualTrue();
    List<Products> findByIsBestsellerAutoTrue();

}
