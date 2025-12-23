package com.chamakk.product.repository;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.chamakk.product.entity.Categories;

@Repository
public interface CategoryRepository extends JpaRepository<Categories, UUID> {

}
