package com.trendora.dao;

import com.trendora.model.Order;
import com.trendora.model.OrderItem;
import java.util.List;

public interface OrderDAO {

    // Place a new order
    int placeOrder(Order order);

    // Add item to order
    boolean addOrderItem(OrderItem orderItem);

    // Get order by ID
    Order getOrderById(int orderId);

    // Get all orders by user ID
    List<Order> getOrdersByUserId(int userId);

    // Get order items by order ID
    List<OrderItem> getOrderItemsByOrderId(int orderId);

    // Get latest order by user ID
    Order getLatestOrderByUserId(int userId);

    // Update order status
    boolean updateOrderStatus(int orderId, String orderStatus);

    // Update payment status
    boolean updatePaymentStatus(int orderId, String paymentStatus);

    // Cancel order
    boolean cancelOrder(int orderId);

    // Get orders by status
    List<Order> getOrdersByStatus(String orderStatus);

    // Get orders by payment method
    List<Order> getOrdersByPaymentMethod(String paymentMethod);

    // Check if order belongs to user
    boolean isOrderOwnedByUser(int orderId, int userId);
}