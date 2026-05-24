package com.trendora.controller;

import com.trendora.dao.impl.CategoryDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.model.Category;
import com.trendora.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class HomeController extends HttpServlet {

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

        // Fetch active categories for navigation
        List<Category> categories = categoryDAO.getActiveCategories();

        // Fetch featured products for home page (latest 8 products)
        List<Product> featuredProducts = productDAO.getFeaturedProducts(8);

        // Fetch discounted products for offers section
        List<Product> discountedProducts = productDAO.getDiscountedProducts();

        // Set attributes to be accessed in JSP
        request.setAttribute("categories", categories);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("discountedProducts", discountedProducts);

        // Forward to home page JSP
        request.getRequestDispatcher("/views/index.jsp")
                .forward(request, response);
    }
}