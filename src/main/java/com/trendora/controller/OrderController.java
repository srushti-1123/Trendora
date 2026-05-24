package com.trendora.controller;

import com.trendora.dao.impl.OrderDAOImpl;
import com.trendora.model.Order;
import com.trendora.model.OrderItem;
import com.trendora.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class OrderController extends HttpServlet {

    private OrderDAOImpl orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
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

        String uri = request.getRequestURI();

        if (uri.endsWith("/order-detail")) {
            handleOrderDetail(request, response, userId);
        } else {
            handleMyOrders(request, response, userId);
        }
    }

    private void handleMyOrders(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/views/my-orders.jsp")
                .forward(request, response);
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        int orderId = Integer.parseInt(orderIdStr);

        // Check if order belongs to user
        if (!orderDAO.isOrderOwnedByUser(orderId, userId)) {
            response.sendRedirect(request.getContextPath() + "/orders");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);

        request.getRequestDispatcher("/views/order-detail.jsp")
                .forward(request, response);
    }
}