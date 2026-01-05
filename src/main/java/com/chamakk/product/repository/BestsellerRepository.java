package com.chamakk.product.repository;

import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface BestsellerRepository extends JpaRepository<Products, UUID> {

    @Query(value = """
            SELECT
                p.product_id,
                p.product_name,
                p.slug,
                pv.sku,
                pv.price,
                pv.mrp,
                CAST(
                    ROUND(((pv.mrp - pv.price) * 100 / pv.mrp), 2)
                    AS NUMERIC
                ),
                pi.product_image_url,
                (COALESCE(i.available_quantity, 0) > 0)
            FROM products p
            JOIN product_variants pv ON pv.product_id = p.product_id
            LEFT JOIN inventory i ON i.variant_id = pv.variant_id
            LEFT JOIN product_images pi
                ON pi.variant_id = pv.variant_id AND pi.is_primary = true
            LEFT JOIN order_items oi ON oi.variant_id = pv.variant_id
            LEFT JOIN orders o
                ON o.order_id = oi.order_id AND o.payment_status = 'PAID'
            WHERE p.is_active = true AND pv.is_active = true
            GROUP BY
                p.product_id,
                p.product_name,
                p.slug,
                pv.sku,
                pv.price,
                pv.mrp,
                pi.product_image_url,
                i.available_quantity
            ORDER BY
                p.is_manual_bestseller DESC,
                COALESCE(SUM(oi.quantity), 0) DESC
            LIMIT 10
            """, nativeQuery = true)
    List<Object[]> findBestsellersRaw();
}
