package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "website_media")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WebsiteMedia {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "website_media_id", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "website_media_title", length = 150)
    private String title;

    @Column(name = "website_media_type", length = 20, nullable = false)
    private String mediaType; // image, video, banner, slider, etc.

    @Column(name = "website_media_url", length = 1000, nullable = false)
    private String mediaUrl;

    @Column(name = "page_section", length = 100)
    private String pageSection;

    @Column(name = "alt_text", length = 300)
    private String altText;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "position")
    private Integer position;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private OffsetDateTime createdAt;
}
