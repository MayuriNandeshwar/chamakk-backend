package com.sunhom.product.service.publicapi;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.sunhom.product.dto.publicapi.NewArrivalProductDto;
import com.sunhom.product.repository.publicapi.NewArrivalRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class NewArrivalService {

    private final NewArrivalRepository repository;

    /**
     * Homepage → limit 8
     * Full page → limit 24
     */
    @Cacheable(value = "new_arrivals:v1")
    public List<NewArrivalProductDto> getNewArrivals(int limit) {

        log.info("🔥 Fetching New Arrivals from DB (limit={})", limit);

        List<Object[]> rows = repository.findNewArrivalsRaw(limit);

        return rows.stream()
                .map(r -> new NewArrivalProductDto(
                        (UUID) r[0], // productId
                        (String) r[1], // productName
                        (String) r[2], // slug
                        (String) r[3], // shortDescription
                        (String) r[4], // sku
                        (BigDecimal) r[5], // price
                        (BigDecimal) r[6], // mrp
                        new BigDecimal(r[7].toString()), // discount
                        (String) r[8], // primary image
                        (String) r[9], // hover image
                        (Boolean) r[10] // in stock
                ))
                .toList();
    }

    @CacheEvict(value = "new_arrivals:v1", allEntries = true)
    public void evictNewArrivalsCache() {
        log.info("🧹 New Arrivals cache cleared");
    }
}