package com.telecom.customer;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class CustomerController {

    @GetMapping("/api/customer")
    public Map<String, Object> customer() {

        return Map.of(
                "service", "customer-service",
                "status", "UP",
                "message", "Telecom customer service is running"
        );
    }
}
