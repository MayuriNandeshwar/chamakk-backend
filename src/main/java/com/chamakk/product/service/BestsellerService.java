package com.chamakk.product.service;

import com.chamakk.product.dto.BestsellerProductDto;
import com.chamakk.product.repository.BestsellerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

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
     * Cache name: bestsellers:v1 (versioned)
     * TTL: 10 minutes
     */
    @Cacheable(value = "bestsellers:v1")
    public List<BestsellerProductDto> getBestsellers() {
        log.info("🔥 CACHE MISS: Fetching bestsellers from database");

        List<Object[]> rows = repository.findBestsellersRaw();

        if (rows == null || rows.isEmpty()) {
            log.info("⚠️ No bestseller data found in database");
            return List.of();
        }

        return rows.stream()
                .map(r -> new BestsellerProductDto(
                        (UUID) r[0],
                        (String) r[1],
                        (String) r[2],
                        (String) r[3],
                        (BigDecimal) r[4],
                        (BigDecimal) r[5],
                        (BigDecimal) r[6],
                        (String) r[7],
                        (Boolean) r[8]))
                .toList();
    }

    /**
     * Clear bestsellers cache (call this when products are updated)
     */
    @CacheEvict(value = "bestsellers:v1", allEntries = true)
    public void evictBestsellersCache() {
        log.info("🧹 Bestseller cache cleared (v1)");
    }
}