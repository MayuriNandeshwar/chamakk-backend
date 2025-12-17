package com.chamakk.backend.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "tags")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Tags {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "tag_id", updatable = false, nullable = false)
    private UUID tagId;

    @Column(name = "tag_name", unique = true, nullable = false, length = 120)
    private String tagName;

    @CreationTimestamp
    private OffsetDateTime createdAt;

    @ManyToMany(mappedBy = "tags")
    private List<Products> products;
}
