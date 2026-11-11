package com.refill.boot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
@EntityScan(basePackages = "com.refill.model")
public class RefillApplication {

    public static void main(String[] args) {
        SpringApplication.run(RefillApplication.class, args);
    }
}

