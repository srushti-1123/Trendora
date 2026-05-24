package com.trendora.dao.impl;

import com.trendora.dao.ProductSizeDAO;
import com.trendora.model.ProductSize;
import com.trendora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductSizeDAOImpl implements ProductSizeDAO {

    @Override
    public List<ProductSize> getSizesByProductId(int productId) {
        List<ProductSize> sizes = new ArrayList<>();
        String query = "SELECT * FROM product_sizes WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sizes.add(mapResultSetToProductSize(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting sizes by product ID: " + e.getMessage());
        }
        return sizes;
    }

    @Override
    public ProductSize getProductSizeById(int productSizeId) {
        String query = "SELECT * FROM product_sizes WHERE product_size_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productSizeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProductSize(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting product size by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public List<ProductSize> getAvailableSizesByProductId(int productId) {
        List<ProductSize> sizes = new ArrayList<>();
        String query = "SELECT * FROM product_sizes WHERE product_id = ? AND is_available = true AND stock_quantity > 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sizes.add(mapResultSetToProductSize(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting available sizes: " + e.getMessage());
        }
        return sizes;
    }

    @Override
    public ProductSize getSizeByProductIdAndLabel(int productId, String sizeLabel) {
        String query = "SELECT * FROM product_sizes WHERE product_id = ? AND size_label = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.setString(2, sizeLabel);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProductSize(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting size by product ID and label: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean isSizeAvailable(int productId, String sizeLabel) {
        String query = "SELECT * FROM product_sizes WHERE product_id = ? AND size_label = ? AND is_available = true AND stock_quantity > 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.setString(2, sizeLabel);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Error checking size availability: " + e.getMessage());
        }
        return false;
    }

    @Override
    public int getStockQuantity(int productId, String sizeLabel) {
        String query = "SELECT stock_quantity FROM product_sizes WHERE product_id = ? AND size_label = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            ps.setString(2, sizeLabel);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }
        } catch (SQLException e) {
            System.out.println("Error getting stock quantity: " + e.getMessage());
        }
        return 0;
    }

    @Override
    public boolean addProductSize(ProductSize productSize) {
        String query = "INSERT INTO product_sizes (product_id, size_label, stock_quantity, sku_code, is_available) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productSize.getProductId());
            ps.setString(2, productSize.getSizeLabel());
            ps.setInt(3, productSize.getStockQuantity());
            ps.setString(4, productSize.getSkuCode());
            ps.setBoolean(5, productSize.isAvailable());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding product size: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateProductSize(ProductSize productSize) {
        String query = "UPDATE product_sizes SET size_label = ?, stock_quantity = ?, sku_code = ?, is_available = ? WHERE product_size_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, productSize.getSizeLabel());
            ps.setInt(2, productSize.getStockQuantity());
            ps.setString(3, productSize.getSkuCode());
            ps.setBoolean(4, productSize.isAvailable());
            ps.setInt(5, productSize.getProductSizeId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating product size: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateStockQuantity(int productSizeId, int quantity) {
        String query = "UPDATE product_sizes SET stock_quantity = ? WHERE product_size_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productSizeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating stock quantity: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean reduceStockQuantity(int productId, String sizeLabel, int quantity) {
        String query = "UPDATE product_sizes SET stock_quantity = stock_quantity - ? WHERE product_id = ? AND size_label = ? AND stock_quantity >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setString(3, sizeLabel);
            ps.setInt(4, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error reducing stock quantity: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteProductSize(int productSizeId) {
        String query = "DELETE FROM product_sizes WHERE product_size_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productSizeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product size: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteAllSizesByProductId(int productId) {
        String query = "DELETE FROM product_sizes WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting all sizes for product: " + e.getMessage());
        }
        return false;
    }

    private ProductSize mapResultSetToProductSize(ResultSet rs) throws SQLException {
        ProductSize productSize = new ProductSize();
        productSize.setProductSizeId(rs.getInt("product_size_id"));
        productSize.setProductId(rs.getInt("product_id"));
        productSize.setSizeLabel(rs.getString("size_label"));
        productSize.setStockQuantity(rs.getInt("stock_quantity"));
        productSize.setSkuCode(rs.getString("sku_code"));
        productSize.setAvailable(rs.getBoolean("is_available"));
        return productSize;
    }
}