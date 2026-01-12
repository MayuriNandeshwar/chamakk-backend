package com.chamakk.admin.dashboard.controller;

import com.chamakk.admin.dashboard.dto.OrderStatusDistributionDto;
import com.chamakk.admin.dashboard.service.OrderStatusAnalyticsService;

import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/dashboard/analytics")
public class AdminDashboardOrderStatusController {

    private final OrderStatusAnalyticsService service;

    public AdminDashboardOrderStatusController(
            OrderStatusAnalyticsService service) {
        this.service = service;
    }

    @GetMapping("/order-status")
    public List<OrderStatusDistributionDto> getOrderStatusDistribution() {
        return service.getOrderStatusDistribution();
    }
}
