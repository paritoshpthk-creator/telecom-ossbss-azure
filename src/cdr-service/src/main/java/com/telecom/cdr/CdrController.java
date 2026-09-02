package com.telecom.cdr;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class CdrController {

    @GetMapping("/api/cdr")
    public Map<String, Object> cdr() {

        return Map.of(
                "service", "cdr-service",
                "status", "UP",
                "message", "Telecom CDR service is running"
        );
    }
}
