package com.dochat.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class DochatApplication {
    public static void main(String[] args) {
        SpringApplication.run(DochatApplication.class, args);
    }
}
