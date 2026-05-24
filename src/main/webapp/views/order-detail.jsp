<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.Order" %>
<%@ page import="com.trendora.model.OrderItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Order Detail</title>
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

        .detail-container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 25px; }
        .page-title { font-size: 24px; font-weight: 700; color: #1a1a2e; display: flex; align-items: center; gap: 10px; }
        .page-title i { color: #e94560; }
        .btn-back { background-color: #1a1a2e; color: white; padding: 10px 20px; border-radius: 8px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px; transition: background-color 0.3s; }
        .btn-back:hover { background-color: #e94560; }

        .detail-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .card-title { font-size: 17px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; display: flex; align-items: center; gap: 10px; }
        .card-title i { color: #e94560; }

        .detail-row { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px solid #f5f5f5; font-size: 14px; }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: #888; font-weight: 500; }
        .detail-value { font-weight: 600; color: #1a1a2e; text-align: right; max-width: 60%; }

        .status-badge { padding: 5px 15px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .status-pending { background-color: #fff3e0; color: #f57c00; }
        .status-shipped { background-color: #e3f2fd; color: #1976d2; }
        .status-delivered { background-color: #e5ffe9; color: #2e7d32; }
        .status-cancelled { background-color: #ffe5e9; color: #c73652; }

        .order-item { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #f5f5f5; }
        .order-item:last-child { border-bottom: none; }
        .order-item-left { flex: 1; }
        .order-item-name { font-size: 15px; font-weight: 600; color: #1a1a2e; margin-bottom: 5px; }
        .order-item-meta { font-size: 13px; color: #888; }
        .order-item-price { font-size: 16px; font-weight: 700; color: #e94560; }

        .total-section { display: flex; justify-content: space-between; align-items: center; padding: 15px 0 0; font-size: 18px; font-weight: 700; color: #1a1a2e; border-top: 2px solid #f0f0f0; margin-top: 10px; }
        .total-section span:last-child { color: #e94560; }

        .action-buttons { display: flex; gap: 15px; margin-bottom: 40px; }
        .btn-orders { flex: 1; background-color: #1a1a2e; color: white; padding: 14px; border-radius: 10px; font-size: 14px; font-weight: 600; text-align: center; transition: background-color 0.3s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-orders:hover { background-color: #e94560; }
        .btn-shop { flex: 1; background-color: #e94560; color: white; padding: 14px; border-radius: 10px; font-size: 14px; font-weight: 600; text-align: center; transition: background-color 0.3s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-shop:hover { background-color: #c73652; }

        .footer { background-color: #1a1a2e; padding: 20px 40px; text-align: center; font-size: 13px; color: #666; }
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
        Order order = (Order) request.getAttribute("order");
        List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
        String statusClass = "status-pending";
        if(order != null) {
            if("Shipped".equals(order.getOrderStatus())) statusClass = "status-shipped";
            else if("Delivered".equals(order.getOrderStatus())) statusClass = "status-delivered";
            else if("Cancelled".equals(order.getOrderStatus())) statusClass = "status-cancelled";
        }
    %>

    <div class="detail-container">

        <div class="page-header">
            <div class="page-title">
                <i class="fas fa-receipt"></i>
                Order Details
            </div>
            <a href="${pageContext.request.contextPath}/orders" class="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Orders
            </a>
        </div>

        <% if(order != null) { %>

        <!-- ORDER INFO -->
        <div class="detail-card">
            <div class="card-title">
                <i class="fas fa-info-circle"></i>
                Order Information
            </div>
            <div class="detail-row">
                <span class="detail-label">Order ID</span>
                <span class="detail-value">#<%= order.getOrderId() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Order Date</span>
                <span class="detail-value"><%= order.getOrderDate() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Payment Method</span>
                <span class="detail-value"><%= order.getPaymentMethod() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Delivery Address</span>
                <span class="detail-value"><%= order.getDeliveryAddress() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Order Status</span>
                <span class="status-badge <%= statusClass %>"><%= order.getOrderStatus() %></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Total Amount</span>
                <span class="detail-value" style="color: #e94560; font-size: 18px;">
                    ₹<%= String.format("%.2f", order.getTotalAmount()) %>
                </span>
            </div>
        </div>

        <!-- ORDER ITEMS -->
        <div class="detail-card">
            <div class="card-title">
                <i class="fas fa-shopping-bag"></i>
                Items Ordered
            </div>
            <% if(orderItems != null) {
                for(OrderItem item : orderItems) { %>
                    <div class="order-item">
                        <div class="order-item-left">
                            <div class="order-item-name"><%= item.getProductName() %></div>
                            <div class="order-item-meta">
                                Size: <%= item.getSizeLabel() %> &nbsp;|&nbsp;
                                Qty: <%= item.getQuantity() %> &nbsp;|&nbsp;
                                ₹<%= item.getUnitPrice() %> each
                            </div>
                        </div>
                        <div class="order-item-price">₹<%= item.getSubtotal() %></div>
                    </div>
            <% } } %>
            <div class="total-section">
                <span>Total Amount</span>
                <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
            </div>
        </div>

        <% } %>

        <!-- ACTION BUTTONS -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/orders" class="btn-orders">
                <i class="fas fa-box"></i> My Orders
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn-shop">
                <i class="fas fa-shopping-bag"></i> Continue Shopping
            </a>
        </div>

    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>