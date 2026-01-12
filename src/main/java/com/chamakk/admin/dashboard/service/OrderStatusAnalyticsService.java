package com.chamakk.admin.dashboard.service;

import com.chamakk.admin.dashboard.dto.OrderStatusDistributionDto;
import com.chamakk.admin.dashboard.repository.OrderStatusAnalyticsRepository;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderStatusAnalyticsService {

    private final OrderStatusAnalyticsRepository repository;

    public OrderStatusAnalyticsService(
            OrderStatusAnalyticsRepository repository) {
        this.repository = repository;
    }

    @Cacheable(value = "admin-dashboard-order-status:v1")
    public List<OrderStatusDistributionDto> getOrderStatusDistribution() {

        List<Object[]> rows = repository.fetchOrderStatusDistribution();

        return rows.stream()
                .map(row -> new OrderStatusDistributionDto(
                        (String) row[0],
                        ((Number) row[1]).longValue()))
                .collect(Collectors.toList());
    }
}
