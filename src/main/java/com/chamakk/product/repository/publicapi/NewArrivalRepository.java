package com.chamakk.product.repository.publicapi;

import com.chamakk.product.entity.Products;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface NewArrivalRepository extends JpaRepository<Products, UUID> {

    @Query(value = """
            SELECT
                p.product_id,
                p.product_name,
                p.slug,
                p.short_description,
                pv.sku,
                pv.price,
                pv.mrp,
                ROUND(
                    CASE
                        WHEN pv.mrp > 0
                        THEN ((pv.mrp - pv.price) * 100 / pv.mrp)
                        ELSE 0
                    END, 2
                ),
                primary_img.product_image_url,
                hover_img.product_image_url,
                (COALESCE(i.available_quantity, 0) > 0)
            FROM products p
            JOIN product_variants pv
                ON pv.product_id = p.product_id
                AND pv.is_active = true
                AND pv.is_default = true
            LEFT JOIN inventory i
                ON i.variant_id = pv.variant_id
            LEFT JOIN product_images primary_img
                ON primary_img.product_id = p.product_id
                AND primary_img.is_primary = true
            LEFT JOIN product_images hover_img
                ON hover_img.product_id = p.product_id
                AND hover_img.is_hover_image = true
            WHERE p.is_active = true
              AND p.deleted_at IS NULL
              AND (
                    p.is_new_arrival = true
                    OR p.created_at >= NOW() - INTERVAL '30 days'
                  )
              AND (p.launch_at IS NULL OR p.launch_at <= NOW())
            ORDER BY
                p.new_arrival_position ASC NULLS LAST,
                p.created_at DESC
            LIMIT :limit
            """, nativeQuery = true)
    List<Object[]> findNewArrivalsRaw(int limit);
}