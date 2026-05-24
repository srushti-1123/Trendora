package com.trendora.dao.impl;

import com.trendora.dao.OrderDAO;
import com.trendora.model.Order;
import com.trendora.model.OrderItem;
import com.trendora.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int placeOrder(Order order) {
        String query = "INSERT INTO orders (user_id, total_amount, payment_method, order_status, delivery_address) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setString(3, order.getPaymentMethod());
            ps.setString(4, order.getOrderStatus());
            ps.setString(5, order.getDeliveryAddress());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error placing order: " + e.getMessage());
        }
        return -1;
    }

    @Override
    public boolean addOrderItem(OrderItem orderItem) {
        String query = "INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price, subtotal, size_label) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getProductId());
            ps.setString(3, orderItem.getProductName());
            ps.setInt(4, orderItem.getQuantity());
            ps.setDouble(5, orderItem.getUnitPrice());
            ps.setDouble(6, orderItem.getSubtotal());
            ps.setString(7, orderItem.getSizeLabel());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error adding order item: " + e.getMessage());
        }
        return false;
    }

    @Override
    public Order getOrderById(int orderId) {
        String query = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting order by ID: " + e.getMessage());
        }
        return null;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting orders by user ID: " + e.getMessage());
        }
        return orders;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String query = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orderItems.add(mapResultSetToOrderItem(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting order items: " + e.getMessage());
        }
        return orderItems;
    }

    @Override
    public Order getLatestOrderByUserId(int userId) {
        String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToOrder(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting latest order: " + e.getMessage());
        }
        return null;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String orderStatus) {
        String query = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, orderStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating order status: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String query = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating payment status: " + e.getMessage());
        }
        return false;
    }

    @Override
    public boolean cancelOrder(int orderId) {
        String query = "UPDATE orders SET order_status = 'Cancelled' WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error cancelling order: " + e.getMessage());
        }
        return false;
    }

    @Override
    public List<Order> getOrdersByStatus(String orderStatus) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE order_status = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, orderStatus);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting orders by status: " + e.getMessage());
        }
        return orders;
    }

    @Override
    public List<Order> getOrdersByPaymentMethod(String paymentMethod) {
        List<Order> orders = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE payment_method = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, paymentMethod);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting orders by payment method: " + e.getMessage());
        }
        return orders;
    }

    @Override
    public boolean isOrderOwnedByUser(int orderId, int userId) {
        String query = "SELECT order_id FROM orders WHERE order_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("Error checking order ownership: " + e.getMessage());
        }
        return false;
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setDeliveryAddress(rs.getString("delivery_address"));
        return order;
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem orderItem = new OrderItem();
        orderItem.setOrderItemId(rs.getInt("order_item_id"));
        orderItem.setOrderId(rs.getInt("order_id"));
        orderItem.setProductId(rs.getInt("product_id"));
        orderItem.setProductName(rs.getString("product_name"));
        orderItem.setQuantity(rs.getInt("quantity"));
        orderItem.setUnitPrice(rs.getDouble("unit_price"));
        orderItem.setSubtotal(rs.getDouble("subtotal"));
        orderItem.setSizeLabel(rs.getString("size_label"));
        return orderItem;
    }
}