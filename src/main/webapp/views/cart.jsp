<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.CartItem" %>
<%@ page import="com.trendora.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Cart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f5f5; }
        a { text-decoration: none; color: inherit; }

        /* NAVBAR */
        .navbar { display: flex; align-items: center; justify-content: space-between; background-color: #1a1a2e; padding: 15px 40px; position: sticky; top: 0; z-index: 1000; }
        .logo { font-size: 28px; font-weight: 800; color: #e94560; letter-spacing: 2px; }
        .search-bar { display: flex; align-items: center; background-color: #fff; border-radius: 25px; overflow: hidden; width: 400px; }
        .search-bar input { border: none; outline: none; padding: 10px 20px; width: 100%; font-size: 14px; }
        .search-bar button { background-color: #e94560; border: none; padding: 10px 20px; cursor: pointer; color: white; font-size: 14px; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-right a { color: #fff; font-size: 14px; display: flex; align-items: center; gap: 5px; }
        .nav-right a:hover { color: #e94560; }
        .cart-icon { background-color: #e94560; padding: 8px 16px; border-radius: 20px; color: white !important; }

        /* CART PAGE */
        .cart-container { display: flex; gap: 25px; padding: 30px 40px; }

        /* CART ITEMS */
        .cart-items-section { flex: 1; }
        .cart-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .cart-header h2 { font-size: 22px; font-weight: 700; color: #1a1a2e; }
        .btn-clear-cart { background-color: #fff; color: #e94560; border: 2px solid #e94560; padding: 8px 16px; border-radius: 8px; font-size: 13px; cursor: pointer; transition: all 0.3s; }
        .btn-clear-cart:hover { background-color: #e94560; color: white; }

        .cart-item { background-color: #fff; border-radius: 12px; padding: 20px; margin-bottom: 15px; display: flex; gap: 20px; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.06); }
        .cart-item-image { width: 100px; height: 100px; border-radius: 10px; overflow: hidden; flex-shrink: 0; background-color: #f5f5f5; }
        .cart-item-image img { width: 100%; height: 100%; object-fit: cover; }
        .cart-item-details { flex: 1; }
        .cart-item-name { font-size: 16px; font-weight: 600; color: #1a1a2e; margin-bottom: 6px; }
        .cart-item-meta { font-size: 13px; color: #888; margin-bottom: 10px; }
        .cart-item-meta span { margin-right: 15px; }
        .cart-item-price { font-size: 18px; font-weight: 700; color: #e94560; }

        .cart-item-actions { display: flex; flex-direction: column; align-items: flex-end; gap: 15px; }
        .quantity-control { display: flex; align-items: center; border: 2px solid #eee; border-radius: 8px; overflow: hidden; }
        .qty-btn { background-color: #f5f5f5; border: none; padding: 6px 12px; font-size: 16px; cursor: pointer; }
        .qty-btn:hover { background-color: #e94560; color: white; }
        .qty-value { padding: 6px 12px; font-size: 14px; font-weight: 600; border: none; text-align: center; width: 40px; }
        .btn-remove { background-color: #fff; color: #e94560; border: none; cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 5px; }
        .btn-remove:hover { color: #c73652; }

        /* EMPTY CART */
        .empty-cart { text-align: center; padding: 80px 20px; background-color: #fff; border-radius: 12px; }
        .empty-cart i { font-size: 64px; color: #ddd; margin-bottom: 20px; }
        .empty-cart h3 { font-size: 20px; color: #888; margin-bottom: 15px; }
        .btn-shop { background-color: #e94560; color: white; padding: 12px 30px; border-radius: 10px; font-size: 15px; font-weight: 600; display: inline-block; margin-top: 10px; }
        .btn-shop:hover { background-color: #c73652; }

        /* ORDER SUMMARY */
        .order-summary { width: 320px; flex-shrink: 0; }
        .summary-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); position: sticky; top: 80px; }
        .summary-title { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .summary-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; font-size: 14px; color: #555; }
        .summary-row.total { font-size: 18px; font-weight: 700; color: #1a1a2e; padding-top: 15px; border-top: 2px solid #f0f0f0; margin-top: 5px; }
        .summary-row.total span:last-child { color: #e94560; }
        .btn-checkout { width: 100%; background-color: #e94560; color: white; border: none; padding: 15px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; margin-top: 20px; transition: background-color 0.3s; }
        .btn-checkout:hover { background-color: #c73652; }
        .btn-continue { width: 100%; background-color: #fff; color: #1a1a2e; border: 2px solid #1a1a2e; padding: 12px; border-radius: 10px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 10px; transition: all 0.3s; text-align: center; display: block; }
        .btn-continue:hover { background-color: #1a1a2e; color: white; }

        /* FOOTER */
        .footer { background-color: #1a1a2e; padding: 20px 40px; text-align: center; font-size: 13px; color: #666; margin-top: 40px; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
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
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
        Double total = (Double) request.getAttribute("total");
        if(total == null) total = 0.0;
    %>

    <div class="cart-container">

        <!-- CART ITEMS -->
        <div class="cart-items-section">
            <div class="cart-header">
                <h2>Shopping Cart
                    (<%= cartItems != null ? cartItems.size() : 0 %> items)
                </h2>
                <% if(cartItems != null && cartItems.size() > 0) { %>
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="clear"/>
                        <button type="submit" class="btn-clear-cart">
                            <i class="fas fa-trash"></i> Clear Cart
                        </button>
                    </form>
                <% } %>
            </div>

            <% if(cartItems != null && cartItems.size() > 0) { %>
                <% for(int i = 0; i < cartItems.size(); i++) {
                    CartItem item = cartItems.get(i);
                    Product product = cartProducts.get(i);
                %>
                    <div class="cart-item">
                        <div class="cart-item-image">
                            <img src="${pageContext.request.contextPath}/images/<%= product != null ? product.getImageUrl() : "" %>"
                                 alt="<%= product != null ? product.getProductName() : "" %>"
                                 onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'"/>
                        </div>
                        <div class="cart-item-details">
                            <div class="cart-item-name"><%= product != null ? product.getProductName() : "Product" %></div>
                            <div class="cart-item-meta">
                                <span><i class="fas fa-ruler"></i> Size: <%= item.getSizeLabel() %></span>
                                <span><i class="fas fa-tag"></i> ₹<%= item.getUnitPrice() %> each</span>
                            </div>
                            <div class="cart-item-price">₹<%= item.getSubTotal() %></div>
                        </div>
                        <div class="cart-item-actions">
                            <!-- Update Quantity -->
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>"/>
                                <div class="quantity-control">
                                    <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>" class="qty-btn">−</button>
                                    <span class="qty-value"><%= item.getQuantity() %></span>
                                    <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>" class="qty-btn">+</button>
                                </div>
                            </form>
                            <!-- Remove Item -->
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="remove"/>
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>"/>
                                <button type="submit" class="btn-remove">
                                    <i class="fas fa-trash-alt"></i> Remove
                                </button>
                            </form>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your cart is empty!</h3>
                    <p>Add some products to your cart</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-shop">
                        Start Shopping
                    </a>
                </div>
            <% } %>
        </div>

        <!-- ORDER SUMMARY -->
        <% if(cartItems != null && cartItems.size() > 0) { %>
            <div class="order-summary">
                <div class="summary-card">
                    <div class="summary-title">Order Summary</div>
                    <div class="summary-row">
                        <span>Subtotal (<%= cartItems.size() %> items)</span>
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
                    <form action="${pageContext.request.contextPath}/checkout" method="get">
                        <button type="submit" class="btn-checkout">
                            Proceed to Checkout
                        </button>
                    </form>
                    <a href="${pageContext.request.contextPath}/products" class="btn-continue">
                        Continue Shopping
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>