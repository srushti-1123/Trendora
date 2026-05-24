package com.trendora.util;

import com.trendora.dao.impl.CategoryDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.dao.impl.ProductSizeDAOImpl;
import com.trendora.dao.impl.UserDAOImpl;
import com.trendora.model.Category;
import com.trendora.model.Product;
import com.trendora.model.ProductSize;
import com.trendora.model.User;

import java.util.List;

public class DAOTest {

    public static void main(String[] args) {

        System.out.println("=============================");
        System.out.println("   TRENDORA DAO LAYER TEST   ");
        System.out.println("=============================\n");

        testUserDAO();
        testCategoryDAO();
        testProductDAO();
        testProductSizeDAO();
    }

    // =====================
    // USER DAO TEST
    // =====================
    static void testUserDAO() {
        System.out.println("--- USER DAO TEST ---");
        UserDAOImpl userDAO = new UserDAOImpl();

        // Test Register User
        User user = new User();
        user.setFullName("Srushti Reddy");
        user.setEmail("srushti@gmail.com");
        user.setPhone("9876543210");
        user.setPassword("srushti123");
        user.setGender("Female");
        user.setAddress("Bangalore, Karnataka");

        boolean registered = userDAO.registerUser(user);
        System.out.println("Register User: " + (registered ? "SUCCESS" : "FAILED"));

        // Test Email Exists
        boolean emailExists = userDAO.emailExists("srushti@gmail.com");
        System.out.println("Email Exists: " + (emailExists ? "SUCCESS" : "FAILED"));

        // Test Login User
        User loggedIn = userDAO.loginUser("srushti@gmail.com", "srushti123");
        System.out.println("Login User: " + (loggedIn != null ? "SUCCESS - Welcome " + loggedIn.getFullName() : "FAILED"));

        // Test Get User By ID
        if (loggedIn != null) {
            User fetchedUser = userDAO.getUserById(loggedIn.getUserId());
            System.out.println("Get User By ID: " + (fetchedUser != null ? "SUCCESS - " + fetchedUser.getFullName() : "FAILED"));

            // Test Update Profile
            fetchedUser.setPhone("9999999999");
            boolean updated = userDAO.updateUserProfile(fetchedUser);
            System.out.println("Update User Profile: " + (updated ? "SUCCESS" : "FAILED"));

            // Test Update Address
            boolean addressUpdated = userDAO.updateUserAddress(fetchedUser.getUserId(), "Mumbai, Maharashtra");
            System.out.println("Update User Address: " + (addressUpdated ? "SUCCESS" : "FAILED"));
        }

        System.out.println();
    }

    // =====================
    // CATEGORY DAO TEST
    // =====================
    static void testCategoryDAO() {
        System.out.println("--- CATEGORY DAO TEST ---");
        CategoryDAOImpl categoryDAO = new CategoryDAOImpl();

        // Test Get All Categories
        List<Category> categories = categoryDAO.getAllCategories();
        System.out.println("Get All Categories: " + (categories.size() > 0 ? "SUCCESS - Found " + categories.size() + " categories" : "FAILED"));

        // Test Get Active Categories
        List<Category> activeCategories = categoryDAO.getActiveCategories();
        System.out.println("Get Active Categories: " + (activeCategories.size() > 0 ? "SUCCESS - Found " + activeCategories.size() + " active categories" : "FAILED"));

        // Test Get Category By ID
        Category category = categoryDAO.getCategoryById(1);
        System.out.println("Get Category By ID: " + (category != null ? "SUCCESS - " + category.getCategoryName() : "FAILED"));

        // Test Get Category By Name
        Category categoryByName = categoryDAO.getCategoryByName("Women");
        System.out.println("Get Category By Name: " + (categoryByName != null ? "SUCCESS - " + categoryByName.getCategoryName() : "FAILED"));

        // Print all categories
        System.out.println("All Categories:");
        for (Category c : categories) {
            System.out.println("  - " + c.getCategoryId() + " | " + c.getCategoryName() + " | Active: " + c.isActive());
        }

        System.out.println();
    }

    // =====================
    // PRODUCT DAO TEST
    // =====================
    static void testProductDAO() {
        System.out.println("--- PRODUCT DAO TEST ---");
        ProductDAOImpl productDAO = new ProductDAOImpl();

        // Test Get All Products
        List<Product> allProducts = productDAO.getAllProducts();
        System.out.println("Get All Products: " + (allProducts.size() > 0 ? "SUCCESS - Found " + allProducts.size() + " products" : "FAILED"));

        // Test Get Active Products
        List<Product> activeProducts = productDAO.getActiveProducts();
        System.out.println("Get Active Products: " + (activeProducts.size() > 0 ? "SUCCESS - Found " + activeProducts.size() + " active products" : "FAILED"));

        // Test Get Product By ID
        Product product = productDAO.getProductById(1);
        System.out.println("Get Product By ID: " + (product != null ? "SUCCESS - " + product.getProductName() : "FAILED"));

        // Test Get Products By Category
        List<Product> menProducts = productDAO.getProductsByCategory(1);
        System.out.println("Get Products By Category (Men): " + (menProducts.size() > 0 ? "SUCCESS - Found " + menProducts.size() + " products" : "FAILED"));

        // Test Search Products
        List<Product> searchResults = productDAO.searchProducts("shirt");
        System.out.println("Search Products (shirt): " + (searchResults.size() > 0 ? "SUCCESS - Found " + searchResults.size() + " products" : "FAILED"));

        // Test Get Products By Price Range
        List<Product> priceRangeProducts = productDAO.getProductsByPriceRange(500, 1500);
        System.out.println("Get Products By Price Range (500-1500): " + (priceRangeProducts.size() > 0 ? "SUCCESS - Found " + priceRangeProducts.size() + " products" : "FAILED"));

        // Test Get Discounted Products
        List<Product> discountedProducts = productDAO.getDiscountedProducts();
        System.out.println("Get Discounted Products: " + (discountedProducts.size() > 0 ? "SUCCESS - Found " + discountedProducts.size() + " products" : "FAILED"));

        // Test Get Featured Products
        List<Product> featuredProducts = productDAO.getFeaturedProducts(5);
        System.out.println("Get Featured Products: " + (featuredProducts.size() > 0 ? "SUCCESS - Found " + featuredProducts.size() + " products" : "FAILED"));

        // Print all products
        System.out.println("All Products:");
        for (Product p : allProducts) {
            System.out.println("  - " + p.getProductId() + " | " + p.getProductName() + " | Price: " + p.getPrice() + " | Discounted: " + p.getDiscountedPrice());
        }

        System.out.println();
    }

    // =====================
    // PRODUCT SIZE DAO TEST
    // =====================
    static void testProductSizeDAO() {
        System.out.println("--- PRODUCT SIZE DAO TEST ---");
        ProductSizeDAOImpl productSizeDAO = new ProductSizeDAOImpl();

        // Test Get Sizes By Product ID
        List<ProductSize> sizes = productSizeDAO.getSizesByProductId(1);
        System.out.println("Get Sizes By Product ID (1): " + (sizes.size() > 0 ? "SUCCESS - Found " + sizes.size() + " sizes" : "FAILED"));

        // Test Get Available Sizes
        List<ProductSize> availableSizes = productSizeDAO.getAvailableSizesByProductId(1);
        System.out.println("Get Available Sizes (Product 1): " + (availableSizes.size() > 0 ? "SUCCESS - Found " + availableSizes.size() + " available sizes" : "FAILED"));

        // Test Is Size Available
        boolean isSizeAvailable = productSizeDAO.isSizeAvailable(1, "M");
        System.out.println("Is Size Available (Product 1, M): " + (isSizeAvailable ? "SUCCESS - Available" : "FAILED - Not Available"));

        // Test Get Stock Quantity
        int stockQuantity = productSizeDAO.getStockQuantity(1, "M");
        System.out.println("Get Stock Quantity (Product 1, M): " + (stockQuantity > 0 ? "SUCCESS - Stock: " + stockQuantity : "FAILED"));

        // Test Get Size By Product ID And Label
        ProductSize size = productSizeDAO.getSizeByProductIdAndLabel(1, "L");
        System.out.println("Get Size By Product ID And Label (1, L): " + (size != null ? "SUCCESS - " + size.getSizeLabel() + " Stock: " + size.getStockQuantity() : "FAILED"));

        // Print all sizes for product 1
        System.out.println("All Sizes for Product 1:");
        for (ProductSize ps : sizes) {
            System.out.println("  - " + ps.getSizeLabel() + " | Stock: " + ps.getStockQuantity() + " | Available: " + ps.isAvailable());
        }

        System.out.println();
        System.out.println("=============================");
        System.out.println("   DAO LAYER TEST COMPLETE   ");
        System.out.println("=============================");
    }
}