package com.chamakk.product.controller;

import com.chamakk.product.dto.ProductRequest;
import com.chamakk.product.dto.ProductResponse;
import com.chamakk.product.service.ProductsService;
import com.chamakk.order.dto.ManualBestSellerRequest;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductsController {

    private final ProductsService productsService;

    // ADD PRODUCT
    @PostMapping("/add")
    public ProductResponse create(@RequestBody ProductRequest req) {
        return productsService.create(req);
    }

    // GET PRODUCT BY ID
   
    @GetMapping("/bestsellers")
    public List<ProductResponse> getBestSellers() {
        return productsService.getBestSellers();
    }
    @PatchMapping("/{id}/bestseller/manual")
public ResponseEntity<?> updateManualBestSeller(
        @PathVariable UUID id,
        @RequestParam boolean status) {
    productsService.updateManualBestSeller(id, status);
    return ResponseEntity.ok("Manual bestseller updated");
}


     @GetMapping("/{id}")
    public ProductResponse getProduct(@PathVariable UUID id) {
        return productsService.getById(id);
    }

}
