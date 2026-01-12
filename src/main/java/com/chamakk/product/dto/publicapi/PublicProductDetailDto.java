package com.chamakk.product.dto.publicapi;

import lombok.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Getter
@Setter
@Builder
public class PublicProductDetailDto {

    private UUID productId;
    private String name;
    private String slug;
    private String brand;
    private String description;

    private SeoDto seo;

    private List<PublicVariantDto> variants;
    private List<PublicAttributeDto> attributes;
    private List<PublicImageDto> images;
}
