package com.chamakk.product.dto.admin;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.UUID;

@Getter
@Setter
public class AdminProductCreateDto {

    @NotBlank
    private String productName;

    @NotNull
    private UUID categoryId;

    private String brand;
    private String shortDescription;
    private String description;

    private String seoTitle;
    private String seoDescription;
    private String seoKeywords;
}
