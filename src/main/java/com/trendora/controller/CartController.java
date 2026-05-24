package com.trendora.controller;

import com.trendora.dao.impl.CartDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.model.Cart;
import com.trendora.model.CartItem;
import com.trendora.model.Product;
import com.trendora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CartController extends HttpServlet {

    private CartDAOImpl cartDAO;
    private ProductDAOImpl productDAO;

    @Override
    public void init() {
        cartDAO = new CartDAOImpl();
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        // Get or create cart
        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            cartDAO.createCart(userId);
            cart = cartDAO.getCartByUserId(userId);
        }

        // Get cart items
        List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cart.getCartId());

        // Get product details for each cart item
        List<Product> cartProducts = new ArrayList<>();
        for (CartItem item : cartItems) {
            Product product = productDAO.getProductById(item.getProductId());
            cartProducts.add(product);
        }

        // Calculate total
        double total = cartDAO.getCartTotal(cart.getCartId());

        request.setAttribute("cart", cart);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/views/cart.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        switch (action) {
            case "add":
                handleAddToCart(request, response, userId);
                break;
            case "remove":
                handleRemoveFromCart(request, response, userId);
                break;
            case "update":
                handleUpdateQuantity(request, response, userId);
                break;
            case "clear":
                handleClearCart(request, response, userId);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        int productId = Integer.parseInt(request.getParameter("productId"));
        String sizeLabel = request.getParameter("sizeLabel");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double productPrice = Double.parseDouble(request.getParameter("productPrice"));

        // Get or create cart
        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            cartDAO.createCart(userId);
            cart = cartDAO.getCartByUserId(userId);
        }

        // Check if item already exists in cart
        CartItem existingItem = cartDAO.getCartItemByProductAndSize(
                cart.getCartId(), productId, sizeLabel);

        if (existingItem != null) {
            // Update quantity
            int newQuantity = existingItem.getQuantity() + quantity;
            cartDAO.updateCartItemQuantity(existingItem.getCartItemId(), newQuantity);
        } else {
            // Add new item
            CartItem cartItem = new CartItem();
            cartItem.setCartId(cart.getCartId());
            cartItem.setProductId(productId);
            cartItem.setSizeLabel(sizeLabel);
            cartItem.setQuantity(quantity);
            cartItem.setUnitPrice(productPrice);
            cartDAO.addItemToCart(cartItem);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        cartDAO.removeCartItem(cartItemId);
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleUpdateQuantity(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (quantity > 0) {
            cartDAO.updateCartItemQuantity(cartItemId, quantity);
        } else {
            cartDAO.removeCartItem(cartItemId);
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleClearCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart != null) {
            cartDAO.clearCart(cart.getCartId());
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}