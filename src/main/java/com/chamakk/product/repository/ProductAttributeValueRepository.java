package com.chamakk.product.repository;

import com.chamakk.product.entity.ProductAttributeValue;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductAttributeValueRepository
        extends JpaRepository<ProductAttributeValue, UUID> {

    List<ProductAttributeValue> findByAttribute_AttributeIdAndIsActiveTrueOrderByDisplayOrderAsc(
            UUID attributeId);
}
