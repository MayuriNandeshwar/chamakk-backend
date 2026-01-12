package com.chamakk.product.dto.publicapi;

import lombok.*;

@Getter
@Setter
@Builder
public class PublicImageDto {

    private String url;
    private Boolean isPrimary;
    private String altText;
}
