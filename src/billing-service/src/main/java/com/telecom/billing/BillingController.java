package com.telecom.billing;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class BillingController {

    @GetMapping("/api/billing")
    public Map<String, Object> billing() {
        return Map.of(
                "service", "billing-service",
                "status", "UP",
                "message", "Telecom billing service is running"
        );
    }
}