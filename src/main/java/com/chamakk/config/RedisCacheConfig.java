package com.chamakk.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

@Configuration
@EnableCaching
public class RedisCacheConfig {

    /**
     * Custom ObjectMapper for Redis serialization
     * - Supports Java 8 date/time types
     * - No default typing (prevents serialization issues)
     * - Optimized for DTO caching
     */
    @Bean
    public ObjectMapper redisCacheObjectMapper() {
        ObjectMapper mapper = new ObjectMapper();
        
        // Support Java 8 date/time
        mapper.registerModule(new JavaTimeModule());
        mapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        
        // Clean JSON without type metadata
        // DO NOT use activateDefaultTyping() - causes deserialization errors
        
        return mapper;
    }

    /**
     * Redis Cache Manager with versioned cache names and custom TTLs
     */
    @Bean
    public CacheManager cacheManager(
            RedisConnectionFactory connectionFactory,
            ObjectMapper redisCacheObjectMapper) {

        // Create Jackson serializer for clean JSON
        Jackson2JsonRedisSerializer<Object> serializer =
                new Jackson2JsonRedisSerializer<>(redisCacheObjectMapper, Object.class);

        // Default cache configuration (10 minutes TTL)
        RedisCacheConfiguration defaultConfig = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(10))
                .disableCachingNullValues()
                .serializeKeysWith(
                    RedisSerializationContext.SerializationPair
                        .fromSerializer(new StringRedisSerializer())
                )
                .serializeValuesWith(
                    RedisSerializationContext.SerializationPair
                        .fromSerializer(serializer)
                );

        // Custom cache configurations with versioning and specific TTLs
        Map<String, RedisCacheConfiguration> cacheConfigurations = new HashMap<>();
        
        // Bestsellers cache - v1, 10 minutes TTL
        cacheConfigurations.put("bestsellers:v1", 
            defaultConfig.entryTtl(Duration.ofMinutes(10)));
        
        // Product details cache - v1, 30 minutes TTL
        cacheConfigurations.put("products:v1", 
            defaultConfig.entryTtl(Duration.ofMinutes(30)));
        
        // Categories cache - v1, 1 hour TTL (changes rarely)
        cacheConfigurations.put("categories:v1", 
            defaultConfig.entryTtl(Duration.ofHours(1)));
        
        // Featured products cache - v1, 15 minutes TTL
        cacheConfigurations.put("featured:v1", 
            defaultConfig.entryTtl(Duration.ofMinutes(15)));

        return RedisCacheManager.builder(connectionFactory)
                .cacheDefaults(defaultConfig)
                .withInitialCacheConfigurations(cacheConfigurations)
                .build();
    }
}