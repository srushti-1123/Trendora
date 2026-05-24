<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - My Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        a { text-decoration: none; color: inherit; }
        .navbar { display: flex; align-items: center; justify-content: space-between; background-color: #1a1a2e; padding: 15px 40px; position: sticky; top: 0; z-index: 1000; }
        .logo { font-size: 28px; font-weight: 800; color: #e94560; letter-spacing: 2px; }
        .search-bar { display: flex; align-items: center; background-color: #fff; border-radius: 25px; overflow: hidden; width: 400px; }
        .search-bar input { border: none; outline: none; padding: 10px 20px; width: 100%; font-size: 14px; }
        .search-bar button { background-color: #e94560; border: none; padding: 10px 20px; cursor: pointer; color: white; font-size: 14px; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-right a { color: #fff; font-size: 14px; display: flex; align-items: center; gap: 5px; }
        .nav-right a:hover { color: #e94560; }
        .cart-icon { background-color: #e94560; padding: 8px 16px; border-radius: 20px; color: white !important; }

        .orders-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 24px; font-weight: 700; color: #1a1a2e; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .page-title i { color: #e94560; }

        .order-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; transition: transform 0.2s; }
        .order-card:hover { transform: translateY(-2px); }
        .order-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .order-id { font-size: 16px; font-weight: 700; color: #1a1a2e; }
        .order-id span { color: #e94560; }
        .order-date { font-size: 13px; color: #888; }

        .order-card-body { display: flex; justify-content: space-between; align-items: center; }
        .order-info { display: flex; gap: 30px; }
        .order-info-item { text-align: center; }
        .order-info-label { font-size: 12px; color: #888; margin-bottom: 5px; }
        .order-info-value { font-size: 15px; font-weight: 600; color: #1a1a2e; }

        .status-badge { padding: 5px 15px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .status-pending { background-color: #fff3e0; color: #f57c00; }
        .status-shipped { background-color: #e3f2fd; color: #1976d2; }
        .status-delivered { background-color: #e5ffe9; color: #2e7d32; }
        .status-cancelled { background-color: #ffe5e9; color: #c73652; }

        .btn-view-order { background-color: #1a1a2e; color: white; padding: 10px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; transition: background-color 0.3s; display: inline-block; }
        .btn-view-order:hover { background-color: #e94560; }

        .empty-orders { text-align: center; padding: 80px 20px; background-color: #fff; border-radius: 12px; }
        .empty-orders i { font-size: 64px; color: #ddd; margin-bottom: 20px; }
        .empty-orders h3 { font-size: 20px; color: #888; margin-bottom: 15px; }
        .btn-shop { background-color: #e94560; color: white; padding: 12px 30px; border-radius: 10px; font-size: 15px; font-weight: 600; display: inline-block; margin-top: 10px; }
        .btn-shop:hover { background-color: #c73652; }

        .footer { background-color: #1a1a2e; padding: 20px 40px; text-align: center; font-size: 13px; color: #666; margin-top: 40px; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-left">
            <a href="${pageContext.request.contextPath}/home" class="logo">Trendora</a>
        </div>
        <div class="nav-center">
            <form action="${pageContext.request.contextPath}/products" method="get">
                <div class="search-bar">
                    <input type="text" name="search" placeholder="Search for clothes, brands..."/>
                    <button type="submit"><i class="fas fa-search"></i></button>
                </div>
            </form>
        </div>
        <div class="nav-right">
            <% if(session.getAttribute("user") != null) { %>
                <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/orders"><i class="fas fa-box"></i> Orders</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i> Login</a>
                <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/cart" class="cart-icon">
                <i class="fas fa-shopping-cart"></i> Cart
            </a>
        </div>
    </nav>

    <%
        List<Order> orders = (List<Order>) request.getAttribute("orders");
    %>

    <div class="orders-container">
        <div class="page-title">
            <i class="fas fa-box"></i>
            My Orders
        </div>

        <% if(orders != null && orders.size() > 0) { %>
            <% for(Order order : orders) {
                String statusClass = "status-pending";
                if("Shipped".equals(order.getOrderStatus())) statusClass = "status-shipped";
                else if("Delivered".equals(order.getOrderStatus())) statusClass = "status-delivered";
                else if("Cancelled".equals(order.getOrderStatus())) statusClass = "status-cancelled";
            %>
                <div class="order-card">
                    <div class="order-card-header">
                        <div>
                            <div class="order-id">Order <span>#<%= order.getOrderId() %></span></div>
                            <div class="order-date"><i class="fas fa-calendar"></i> <%= order.getOrderDate() %></div>
                        </div>
                        <span class="status-badge <%= statusClass %>">
                            <%= order.getOrderStatus() %>
                        </span>
                    </div>
                    <div class="order-card-body">
                        <div class="order-info">
                            <div class="order-info-item">
                                <div class="order-info-label">Total Amount</div>
                                <div class="order-info-value">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Payment</div>
                                <div class="order-info-value"><%= order.getPaymentMethod() %></div>
                            </div>
                            <div class="order-info-item">
                                <div class="order-info-label">Delivery Address</div>
                                <div class="order-info-value" style="max-width: 200px; font-size: 13px;">
                                    <%= order.getDeliveryAddress() %>
                                </div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/order-detail?orderId=<%= order.getOrderId() %>"
                           class="btn-view-order">
                            View Details
                        </a>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="empty-orders">
                <i class="fas fa-box-open"></i>
                <h3>No orders yet!</h3>
                <p>You have not placed any orders yet.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn-shop">
                    Start Shopping
                </a>
            </div>
        <% } %>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>