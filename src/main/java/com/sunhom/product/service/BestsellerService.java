package com.sunhom.product.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.sunhom.product.dto.BestsellerProductDto;
import com.sunhom.product.repository.BestsellerRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class BestsellerService {

    private final BestsellerRepository repository;

    /**
     * Get bestseller products with Redis caching
     * Cache name: bestsellers:v2
     * TTL: 10 minutes
     */
    @Cacheable(value = "bestsellers:v2")
    public List<BestsellerProductDto> getBestsellers() {

        log.info("🔥 CACHE MISS: Fetching bestsellers from database");

        List<Object[]> rows = repository.findBestsellersRaw();

        if (rows == null || rows.isEmpty()) {
            log.info("⚠️ No bestseller data found in database");
            return List.of();
        }

        return rows.stream()
                .map(r -> new BestsellerProductDto(
                        (UUID) r[0], // product_id
                        (String) r[1], // product_name
                        (String) r[2], // slug
                        (String) r[3], // short_description
                        (String) r[4], // sku
                        (BigDecimal) r[5], // price
                        (BigDecimal) r[6], // mrp
                        (BigDecimal) r[7], // discount_percentage
                        (String) r[8], // image_url
                        (String) r[9], // hover_image_url
                        (Boolean) r[10] // in_stock
                ))
                .toList();
    }

    /**
     * Clear bestsellers cache
     */
    @CacheEvict(value = "bestsellers:v2", allEntries = true)
    public void evictBestsellersCache() {
        log.info("🧹 Bestseller cache cleared (v2)");
    }
}