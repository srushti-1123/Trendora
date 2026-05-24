package com.trendora.model;

public class Product {

    private int productId;
    private int categoryId;
    private String productName;
    private String description;
    private double price;
    private double discountPercent;
    private String imageUrl;
    private boolean isActive;

    public Product() {
    }

    public Product(int productId, int categoryId, String productName, String description, double price, double discountPercent, String imageUrl, boolean isActive) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.description = description;
        this.price = price;
        this.discountPercent = discountPercent;
        this.imageUrl = imageUrl;
        this.isActive = isActive;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public double getDiscountedPrice() {
        double discounted = price - (price * discountPercent / 100);
        return Math.round(discounted * 100.0) / 100.0;
    }
}