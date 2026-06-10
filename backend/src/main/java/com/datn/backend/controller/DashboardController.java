package com.datn.backend.controller;

import com.datn.backend.dto.DashboardSummaryResponse;
import com.datn.backend.dto.LessonDashboardResponse;
import com.datn.backend.dto.UserDashboardResponse;
import com.datn.backend.service.DashboardService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping({"/api/admin/dashboard", "/api/dashboard"})
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/summary")
    public DashboardSummaryResponse getSummary() {
        return dashboardService.getSummary();
    }

    @GetMapping("/users/{userId}")
    public UserDashboardResponse getUserDashboard(@PathVariable Long userId) {
        return dashboardService.getUserDashboard(userId);
    }

    @GetMapping("/lessons/{lessonId}")
    public LessonDashboardResponse getLessonDashboard(@PathVariable Long lessonId) {
        return dashboardService.getLessonDashboard(lessonId);
    }
}
