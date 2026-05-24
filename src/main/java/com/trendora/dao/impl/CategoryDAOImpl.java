package com.trendora.dao.impl;

import com.trendora.dao.CategoryDAO;
import com.trendora.model.Category;
import com.trendora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAOImpl implements CategoryDAO {

    @Override
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all categories: " + e.getMessage());
        }
        return categories;
    }

    @Override
    public List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT * FROM categories WHERE is_active = true";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting active categories: " + e.getMessage());
        }
        return categories;
    }

    @Override
    public Category getCategoryById(int categoryId) {
        String query = "SELECT * FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting category by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public Category getCategoryByName(String categoryName) {
        String query = "SELECT * FROM categories WHERE category_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, categoryName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCategory(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting category by name: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean addCategory(Category category) {
        String query = "INSERT INTO categories (category_name, description, is_active) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding category: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updateCategory(Category category) {
        String query = "UPDATE categories SET category_name = ?, description = ?, is_active = ? WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setBoolean(3, category.isActive());
            ps.setInt(4, category.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating category: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        String query = "DELETE FROM categories WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting category: " + e.getMessage());
        }
        return false;
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setActive(rs.getBoolean("is_active"));
        return category;
    }
}