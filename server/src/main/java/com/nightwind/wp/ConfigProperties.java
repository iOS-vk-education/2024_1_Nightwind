package com.nightwind.wp;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "config")
public class ConfigProperties {
    private String mediaDir;
    private String jwtSecret;
    private String shaSalt;

    public String getMediaDir() {
        return mediaDir;
    }

    public void setMediaDir(String mediaDir) {
        this.mediaDir = mediaDir;
    }

    public String getJwtSecret() {
        return jwtSecret;
    }

    public void setJwtSecret(String jwtSecret) {
        this.jwtSecret = jwtSecret;
    }

    public String getShaSalt() {
        return shaSalt;
    }

    public void setShaSalt(String shaSalt) {
        this.shaSalt = shaSalt;
    }
}