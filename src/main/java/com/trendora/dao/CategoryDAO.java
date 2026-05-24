package com.trendora.dao;

import com.trendora.model.Category;
import java.util.List;

public interface CategoryDAO {

    // Get all categories
    List<Category> getAllCategories();

    // Get only active categories
    List<Category> getActiveCategories();

    // Get category by ID
    Category getCategoryById(int categoryId);

    // Get category by name
    Category getCategoryByName(String categoryName);

    // Add new category
    boolean addCategory(Category category);

    // Update category
    boolean updateCategory(Category category);

    // Delete category
    boolean deleteCategory(int categoryId);
}