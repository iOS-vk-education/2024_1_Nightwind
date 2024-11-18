package com.nightwind.wp;

import com.nightwind.wp.config.PropertiesConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties(PropertiesConfig.class)
public class WpApplication {

    public static void main(String[] args) {
        SpringApplication.run(WpApplication.class, args);
    }

}
