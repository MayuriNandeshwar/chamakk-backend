package com.chamakk.product.repository.publicapi;

import com.chamakk.product.entity.ProductEntityAttribute;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface PublicAttributeRepository
        extends JpaRepository<ProductEntityAttribute, UUID> {

    List<ProductEntityAttribute> findByProducts_ProductId(UUID productId);
}
