package com.trendora.dao;

import com.trendora.model.Product;
import java.util.List;

public interface ProductDAO {

    // Get all products
    List<Product> getAllProducts();

    // Get only active products
    List<Product> getActiveProducts();

    // Get product by ID
    Product getProductById(int productId);

    // Get products by category
    List<Product> getProductsByCategory(int categoryId);

    // Get products by category with price filter
    List<Product> getProductsByCategoryAndPriceRange(int categoryId, double minPrice, double maxPrice);

    // Search products by keyword
    List<Product> searchProducts(String keyword);

    // Search products by keyword with price filter
    List<Product> searchProductsWithPriceRange(String keyword, double minPrice, double maxPrice);

    // Get products by price range
    List<Product> getProductsByPriceRange(double minPrice, double maxPrice);

    // Get products by brand
    List<Product> getProductsByBrand(String brand);

    // Get products by category and brand
    List<Product> getProductsByCategoryAndBrand(int categoryId, String brand);

    // Get featured products for home page
    List<Product> getFeaturedProducts(int limit);

    // Get new arrivals for home page
    List<Product> getNewArrivals(int limit);

    // Get discounted products
    List<Product> getDiscountedProducts();

    // Get all distinct brands
    List<String> getAllBrands();

    // Add new product
    boolean addProduct(Product product);

    // Update product
    boolean updateProduct(Product product);

    // Delete product
    boolean deleteProduct(int productId);
}