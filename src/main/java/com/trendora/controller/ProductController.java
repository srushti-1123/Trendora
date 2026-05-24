package com.trendora.controller;

import com.trendora.dao.impl.CategoryDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.model.Category;
import com.trendora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class ProductController extends HttpServlet {

    private ProductDAOImpl productDAO;
    private CategoryDAOImpl categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String categoryIdStr = request.getParameter("categoryId");
        String search = request.getParameter("search");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        List<Product> products = null;
        List<Category> categories = categoryDAO.getActiveCategories();

        int categoryId = 0;
        double minPrice = 0;
        double maxPrice = 100000;

        // Parse parameters safely
        try {
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr);
            }
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
            }
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
            }
        } catch (NumberFormatException e) {
            System.out.println("Error parsing parameters: " + e.getMessage());
        }

        // Apply filters
        if (search != null && !search.isEmpty()) {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                products = productDAO.searchProductsWithPriceRange(search, minPrice, maxPrice);
            } else {
                products = productDAO.searchProducts(search);
            }
            request.setAttribute("search", search);
        } else if (categoryId > 0) {
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                products = productDAO.getProductsByCategoryAndPriceRange(categoryId, minPrice, maxPrice);
            } else {
                products = productDAO.getProductsByCategory(categoryId);
            }
            request.setAttribute("selectedCategoryId", categoryId);
        } else if (minPriceStr != null && !minPriceStr.isEmpty()) {
            products = productDAO.getProductsByPriceRange(minPrice, maxPrice);
        } else {
            products = productDAO.getActiveProducts();
        }

        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);

        request.getRequestDispatcher("/views/products.jsp")
                .forward(request, response);
    }
}