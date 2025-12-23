package com.chamakk.order.repository;

import com.chamakk.order.entity.OrderItems;
import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.*;

public interface OrderItemsRepository extends JpaRepository<OrderItems, UUID> {

    
    @Query("""
    SELECT oi.product.productId
    FROM OrderItems oi
    GROUP BY oi.product.productId
    ORDER BY SUM(oi.quantity) DESC
    LIMIT 10
""")
List<UUID> findTopSellingProductIds();

}
