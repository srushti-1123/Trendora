package com.trendora.controller;

import com.trendora.dao.impl.CategoryDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.dao.impl.ProductSizeDAOImpl;
import com.trendora.model.Category;
import com.trendora.model.Product;
import com.trendora.model.ProductSize;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class ProductDetailController extends HttpServlet {

    private ProductDAOImpl productDAO;
    private ProductSizeDAOImpl productSizeDAO;
    private CategoryDAOImpl categoryDAO;

    @Override
    public void init() {
        productDAO = new ProductDAOImpl();
        productSizeDAO = new ProductSizeDAOImpl();
        categoryDAO = new CategoryDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdStr);

            // Fetch product details
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Fetch available sizes
            List<ProductSize> sizes = productSizeDAO.getAvailableSizesByProductId(productId);

            // Fetch category
            Category category = categoryDAO.getCategoryById(product.getCategoryId());

            // Fetch related products from same category
            List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategoryId());

            // Remove current product from related products
            relatedProducts.removeIf(p -> p.getProductId() == productId);

            // Limit to 4 related products
            if (relatedProducts.size() > 4) {
                relatedProducts = relatedProducts.subList(0, 4);
            }

            // Set attributes
            request.setAttribute("product", product);
            request.setAttribute("sizes", sizes);
            request.setAttribute("category", category);
            request.setAttribute("relatedProducts", relatedProducts);

            request.getRequestDispatcher("/views/product-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}