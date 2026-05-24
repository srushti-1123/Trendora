package com.trendora.dao;

import com.trendora.model.ProductSize;
import java.util.List;

public interface ProductSizeDAO {

    // Get all sizes for a product
    List<ProductSize> getSizesByProductId(int productId);

    // Get specific size by ID
    ProductSize getProductSizeById(int productSizeId);

    // Get only available sizes for a product
    List<ProductSize> getAvailableSizesByProductId(int productId);

    // Get specific size by product ID and size label
    ProductSize getSizeByProductIdAndLabel(int productId, String sizeLabel);

    // Check if a specific size is available
    boolean isSizeAvailable(int productId, String sizeLabel);

    // Get stock quantity for a specific size
    int getStockQuantity(int productId, String sizeLabel);

    // Add new size for a product
    boolean addProductSize(ProductSize productSize);

    // Update size details
    boolean updateProductSize(ProductSize productSize);

    // Update stock quantity
    boolean updateStockQuantity(int productSizeId, int quantity);

    // Reduce stock quantity after order is placed
    boolean reduceStockQuantity(int productId, String sizeLabel, int quantity);

    // Delete a size
    boolean deleteProductSize(int productSizeId);

    // Delete all sizes for a product
    boolean deleteAllSizesByProductId(int productId);
}