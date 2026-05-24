<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.CartItem" %>
<%@ page import="com.trendora.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Checkout</title>
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
        .checkout-container { display: flex; gap: 25px; padding: 30px 40px; }
        .delivery-section { flex: 1; }
        .section-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .section-card-title { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; display: flex; align-items: center; gap: 10px; }
        .section-card-title i { color: #e94560; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; border: 2px solid #eee; border-radius: 10px; padding: 12px 15px; font-size: 14px; outline: none; transition: border-color 0.3s; font-family: inherit; }
        .form-group input:focus, .form-group textarea:focus { border-color: #e94560; }
        .form-group textarea { resize: none; height: 80px; }
        .form-row { display: flex; gap: 15px; }
        .form-row .form-group { flex: 1; }
        .payment-options { display: flex; flex-direction: column; gap: 12px; }
        .payment-option { display: flex; align-items: center; gap: 15px; padding: 15px; border: 2px solid #eee; border-radius: 10px; cursor: pointer; transition: all 0.3s; }
        .payment-option:hover { border-color: #e94560; }
        .payment-option input[type="radio"] { width: 18px; height: 18px; accent-color: #e94560; }
        .payment-option-info { flex: 1; }
        .payment-option-name { font-size: 15px; font-weight: 600; color: #1a1a2e; }
        .payment-option-desc { font-size: 12px; color: #888; margin-top: 2px; }
        .payment-option-icon { font-size: 24px; color: #e94560; }
        .summary-section { width: 320px; flex-shrink: 0; }
        .summary-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); position: sticky; top: 80px; }
        .summary-title { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .summary-item { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; font-size: 13px; color: #555; padding-bottom: 10px; border-bottom: 1px solid #f5f5f5; }
        .summary-item-name { flex: 1; }
        .summary-item-price { font-weight: 600; color: #1a1a2e; }
        .summary-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; font-size: 14px; color: #555; }
        .summary-row.total { font-size: 18px; font-weight: 700; color: #1a1a2e; padding-top: 15px; border-top: 2px solid #f0f0f0; margin-top: 5px; }
        .summary-row.total span:last-child { color: #e94560; }
        .btn-place-order { width: 100%; background-color: #e94560; color: white; border: none; padding: 15px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 20px; transition: background-color 0.3s; }
        .btn-place-order:hover { background-color: #c73652; }
        .btn-back { width: 100%; background-color: #fff; color: #1a1a2e; border: 2px solid #1a1a2e; padding: 12px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 10px; transition: all 0.3s; text-align: center; display: block; }
        .btn-back:hover { background-color: #1a1a2e; color: white; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background-color: #ffe5e9; color: #c73652; border: 1px solid #e94560; }
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
            <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Profile</a>
            <a href="${pageContext.request.contextPath}/orders"><i class="fas fa-box"></i> Orders</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            <a href="${pageContext.request.contextPath}/cart" class="cart-icon">
                <i class="fas fa-shopping-cart"></i> Cart
            </a>
        </div>
    </nav>

    <%
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        Double total = (Double) request.getAttribute("total");
        User user = (User) request.getAttribute("user");
        if(total == null) total = 0.0;
    %>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-error" style="margin: 20px 40px;">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <div class="checkout-container">

        <div class="delivery-section">
            <form id="checkoutForm" action="${pageContext.request.contextPath}/checkout" method="post">
                <input type="hidden" name="action" value="placeOrder"/>

                <div class="section-card">
                    <div class="section-card-title">
                        <i class="fas fa-map-marker-alt"></i>
                        Delivery Address
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullName"
                                   value="<%= user != null ? user.getFullName() : "" %>" required/>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="text" name="phone"
                                   value="<%= user != null ? user.getPhone() : "" %>" required/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Delivery Address</label>
                        <textarea name="deliveryAddress" placeholder="Enter your full delivery address" required><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>City</label>
                            <input type="text" name="city" placeholder="Enter city" required/>
                        </div>
                        <div class="form-group">
                            <label>Pincode</label>
                            <input type="text" name="pincode" placeholder="Enter pincode" required/>
                        </div>
                    </div>
                </div>

                <div class="section-card">
                    <div class="section-card-title">
                        <i class="fas fa-credit-card"></i>
                        Payment Method
                    </div>
                    <div class="payment-options">
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="COD" checked/>
                            <div class="payment-option-info">
                                <div class="payment-option-name">Cash on Delivery</div>
                                <div class="payment-option-desc">Pay when your order arrives</div>
                            </div>
                            <i class="fas fa-money-bill-wave payment-option-icon"></i>
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="UPI"/>
                            <div class="payment-option-info">
                                <div class="payment-option-name">UPI Payment</div>
                                <div class="payment-option-desc">Pay using UPI apps like GPay, PhonePe</div>
                            </div>
                            <i class="fas fa-mobile-alt payment-option-icon"></i>
                        </label>
                        <label class="payment-option">
                            <input type="radio" name="paymentMethod" value="Card"/>
                            <div class="payment-option-info">
                                <div class="payment-option-name">Credit / Debit Card</div>
                                <div class="payment-option-desc">Pay using your card</div>
                            </div>
                            <i class="fas fa-credit-card payment-option-icon"></i>
                        </label>
                    </div>
                </div>

            </form>
        </div>

        <div class="summary-section">
            <div class="summary-card">
                <div class="summary-title">Order Summary</div>
                <% if(cartItems != null) {
                    for(CartItem item : cartItems) { %>
                        <div class="summary-item">
                            <div class="summary-item-name">
                                Product #<%= item.getProductId() %>
                                <br/><small>Size: <%= item.getSizeLabel() %> × <%= item.getQuantity() %></small>
                            </div>
                            <div class="summary-item-price">₹<%= item.getSubTotal() %></div>
                        </div>
                <% } } %>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
                <div class="summary-row">
                    <span>Shipping</span>
                    <span style="color: green;">FREE</span>
                </div>
                <div class="summary-row total">
                    <span>Total</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
                <button type="submit" form="checkoutForm" class="btn-place-order">
                    Place Order
                </button>
                <a href="${pageContext.request.contextPath}/cart" class="btn-back">
                    Back to Cart
                </a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>