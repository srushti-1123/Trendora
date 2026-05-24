package com.trendora.dao.impl;

import com.trendora.dao.ProductDAO;
import com.trendora.model.Product;
import com.trendora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all products: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getActiveProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting active products: " + e.getMessage());
        }
        return products;
    }

    @Override
    public Product getProductById(int productId) {
        String query = "SELECT * FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category_id = ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by category: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getProductsByCategoryAndPriceRange(int categoryId, double minPrice, double maxPrice) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category_id = ? AND price BETWEEN ? AND ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ps.setDouble(2, minPrice);
            ps.setDouble(3, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by category and price: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE (product_name LIKE ? OR description LIKE ?) AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searching products: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> searchProductsWithPriceRange(String keyword, double minPrice, double maxPrice) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE (product_name LIKE ? OR description LIKE ?) AND price BETWEEN ? AND ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setDouble(3, minPrice);
            ps.setDouble(4, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searching products with price range: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getProductsByPriceRange(double minPrice, double maxPrice) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE price BETWEEN ? AND ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDouble(1, minPrice);
            ps.setDouble(2, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by price range: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getProductsByBrand(String brand) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE brand = ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, brand);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by brand: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getProductsByCategoryAndBrand(int categoryId, String brand) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE category_id = ? AND brand = ? AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ps.setString(2, brand);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting products by category and brand: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE is_active = true ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting featured products: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getNewArrivals(int limit) {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE is_active = true ORDER BY created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting new arrivals: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<Product> getDiscountedProducts() {
        List<Product> products = new ArrayList<>();
        String query = "SELECT * FROM products WHERE discount_percent > 0 AND is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting discounted products: " + e.getMessage());
        }
        return products;
    }

    @Override
    public List<String> getAllBrands() {
        List<String> brands = new ArrayList<>();
        String query = "SELECT DISTINCT brand FROM products WHERE is_active = true AND brand IS NOT NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                brands.add(rs.getString("brand"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all brands: " + e.getMessage());
        }
        return brands;
    }

    @Override
    public boolean addProduct(Product product) {
        String query = "INSERT INTO products (category_id, product_name, description, price, discount_percent, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getDiscountPercent());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateProduct(Product product) {
        String query = "UPDATE products SET category_id = ?, product_name = ?, description = ?, price = ?, discount_percent = ?, image_url = ?, is_active = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setDouble(5, product.getDiscountPercent());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            ps.setInt(8, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM products WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
        }
        return false;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setProductName(rs.getString("product_name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getDouble("price"));
        product.setDiscountPercent(rs.getDouble("discount_percent"));
        product.setImageUrl(rs.getString("image_url"));
        product.setActive(rs.getBoolean("is_active"));
        return product;
    }
}