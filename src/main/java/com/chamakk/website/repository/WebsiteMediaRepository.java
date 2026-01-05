package com.chamakk.website.repository;

import com.chamakk.website.entity.WebsiteMedia;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface WebsiteMediaRepository
        extends JpaRepository<WebsiteMedia, UUID> {

    List<WebsiteMedia> findByPageSectionAndIsActiveOrderByPositionAsc(
            String pageSection,
            Boolean isActive);
}
