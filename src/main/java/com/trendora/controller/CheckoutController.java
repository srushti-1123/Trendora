package com.trendora.controller;

import com.trendora.dao.impl.CartDAOImpl;
import com.trendora.dao.impl.OrderDAOImpl;
import com.trendora.dao.impl.ProductDAOImpl;
import com.trendora.model.Cart;
import com.trendora.model.CartItem;
import com.trendora.model.Order;
import com.trendora.model.OrderItem;
import com.trendora.model.Product;
import com.trendora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class CheckoutController extends HttpServlet {

    private CartDAOImpl cartDAO;
    private OrderDAOImpl orderDAO;
    private ProductDAOImpl productDAO;

    @Override
    public void init() {
        cartDAO = new CartDAOImpl();
        orderDAO = new OrderDAOImpl();
        productDAO = new ProductDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cart.getCartId());
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double total = cartDAO.getCartTotal(cart.getCartId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.setAttribute("user", user);

        String uri = request.getRequestURI();
        if (uri.endsWith("/payment")) {
            request.getRequestDispatcher("/views/payment.jsp")
                    .forward(request, response);
        } else {
            request.getRequestDispatcher("/views/checkout.jsp")
                    .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        if ("placeOrder".equals(action)) {
            handlePlaceOrder(request, response, user);
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    private void handlePlaceOrder(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String deliveryAddress = request.getParameter("deliveryAddress");
        String paymentMethod = request.getParameter("paymentMethod");
        int userId = user.getUserId();

        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItemsByCartId(cart.getCartId());
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double total = cartDAO.getCartTotal(cart.getCartId());

        // Create order
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(total);
        order.setPaymentMethod(paymentMethod);
        order.setOrderStatus("Pending");
        order.setDeliveryAddress(deliveryAddress);

        int orderId = orderDAO.placeOrder(order);

        if (orderId > 0) {
            // Add order items
            for (CartItem cartItem : cartItems) {
                Product product = productDAO.getProductById(cartItem.getProductId());
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(cartItem.getProductId());
                orderItem.setProductName(product != null ? product.getProductName() : "Product");
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setUnitPrice(cartItem.getUnitPrice());
                orderItem.setSubtotal(cartItem.getSubTotal());
                orderItem.setSizeLabel(cartItem.getSizeLabel());
                orderDAO.addOrderItem(orderItem);
            }

            // Clear cart after order
            cartDAO.clearCart(cart.getCartId());

            // Set order details for confirmation page
            Order placedOrder = orderDAO.getOrderById(orderId);
            List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

            request.getSession().setAttribute("lastOrder", placedOrder);
            request.getSession().setAttribute("lastOrderItems", orderItems);

            response.sendRedirect(request.getContextPath() + "/order-confirmation");
        } else {
            request.setAttribute("error", "Order placement failed! Please try again.");
            request.getRequestDispatcher("/views/checkout.jsp")
                    .forward(request, response);
        }
    }
}