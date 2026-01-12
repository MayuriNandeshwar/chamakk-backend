package com.chamakk.admin.dashboard.controller;

import com.chamakk.admin.dashboard.dto.DashboardSummaryDto;
import com.chamakk.admin.dashboard.model.DashboardPeriod;
import com.chamakk.admin.dashboard.service.AdminDashboardService;

import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/dashboard")
public class AdminDashboardController {

    private final AdminDashboardService service;

    public AdminDashboardController(AdminDashboardService service) {
        this.service = service;
    }

    @GetMapping("/summary")
    public DashboardSummaryDto getSummary(
            @RequestParam(defaultValue = "OVERALL") DashboardPeriod period) {
        return service.getSummary(period);
    }
}
