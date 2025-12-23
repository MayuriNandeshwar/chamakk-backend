package com.chamakk.product.repository;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.chamakk.product.entity.ProductTypes;

@Repository
public interface ProductTypeRepository extends JpaRepository<ProductTypes, UUID> {

}
