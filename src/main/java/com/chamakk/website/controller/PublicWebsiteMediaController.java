package com.chamakk.website.controller;

import com.chamakk.website.entity.WebsiteMedia;
import com.chamakk.website.repository.WebsiteMediaRepository;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/public/website-media")
@RequiredArgsConstructor
public class PublicWebsiteMediaController {

    private final WebsiteMediaRepository repository;

    @GetMapping
    public ResponseEntity<List<WebsiteMedia>> getBySection(
            @RequestParam("pageSection") String pageSection) {

        List<WebsiteMedia> media = repository.findByPageSectionAndIsActiveOrderByPositionAsc(
                pageSection,
                true);

        if (media == null || media.isEmpty()) {
            return ResponseEntity.ok(List.of());
        }

        return ResponseEntity.ok(media);
    }

}
