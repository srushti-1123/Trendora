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
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f8ff; }
        a { text-decoration: none; color: inherit; }
        .navbar { display: flex; align-items: center; justify-content: space-between; background: #fff; padding: 15px 50px; position: sticky; top: 0; z-index: 1000; box-shadow: 0 2px 20px rgba(102,126,234,0.1); border-bottom: 1px solid #f0f0ff; }
        .logo { font-size: 32px; font-weight: 900; letter-spacing: 2px; background: linear-gradient(135deg, #667eea, #764ba2, #f953c6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .search-bar { display: flex; align-items: center; background: #f8f8ff; border: 2px solid #e8e8ff; border-radius: 30px; overflow: hidden; width: 380px; }
        .search-bar input { border: none; outline: none; padding: 10px 20px; width: 100%; font-size: 14px; background: transparent; }
        .search-bar button { background: linear-gradient(135deg, #667eea, #764ba2); border: none; padding: 10px 20px; cursor: pointer; color: white; font-size: 14px; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-right a { color: #555; font-size: 14px; display: flex; align-items: center; gap: 5px; font-weight: 500; transition: color 0.3s; }
        .nav-right a:hover { color: #667eea; }
        .cart-btn { background: linear-gradient(135deg, #667eea, #764ba2, #f953c6); padding: 9px 20px; border-radius: 25px; color: white !important; font-weight: 700; display: flex; align-items: center; gap: 6px; }

        .page-header { background: linear-gradient(135deg, #0f0c29, #302b63); padding: 30px 50px; color: white; }
        .page-header h1 { font-size: 28px; font-weight: 800; }
        .page-header p { color: rgba(255,255,255,0.6); font-size: 14px; margin-top: 5px; }
        .breadcrumb { font-size: 13px; color: rgba(255,255,255,0.5); margin-bottom: 8px; }
        .breadcrumb a { color: #f953c6; }

        .cart-container { display: flex; gap: 25px; padding: 30px 50px; }
        .cart-items-section { flex: 1; }
        .cart-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .cart-header h2 { font-size: 20px; font-weight: 700; color: #1a1a2e; }
        .btn-clear-cart { background: #fff; color: #f953c6; border: 2px solid #f953c6; padding: 8px 18px; border-radius: 20px; font-size: 13px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
        .btn-clear-cart:hover { background: #f953c6; color: white; }

        .cart-item { background: #fff; border-radius: 16px; padding: 20px; margin-bottom: 15px; display: flex; gap: 20px; align-items: center; box-shadow: 0 3px 15px rgba(0,0,0,0.06); border: 1px solid #f0f0ff; transition: box-shadow 0.3s; }
        .cart-item:hover { box-shadow: 0 8px 25px rgba(102,126,234,0.15); }
        .cart-item-image { width: 110px; height: 110px; border-radius: 12px; overflow: hidden; flex-shrink: 0; background: #f8f8ff; border: 1px solid #eee; }
        .cart-item-image img { width: 100%; height: 100%; object-fit: cover; }
        .cart-item-details { flex: 1; }
        .cart-item-name { font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 6px; }
        .cart-item-meta { display: flex; gap: 10px; margin-bottom: 10px; flex-wrap: wrap; }
        .meta-tag { font-size: 12px; color: #667eea; background: #f0f0ff; padding: 3px 10px; border-radius: 10px; font-weight: 600; }
        .cart-item-price { font-size: 20px; font-weight: 800; color: #667eea; }
        .cart-item-unit { font-size: 12px; color: #888; margin-top: 3px; }

        .cart-item-actions { display: flex; flex-direction: column; align-items: flex-end; gap: 15px; }
        .quantity-control { display: flex; align-items: center; border: 2px solid #e8e8ff; border-radius: 10px; overflow: hidden; }
        .qty-btn { background: #f8f8ff; border: none; padding: 8px 14px; font-size: 16px; cursor: pointer; transition: all 0.3s; color: #667eea; font-weight: 700; }
        .qty-btn:hover { background: #667eea; color: white; }
        .qty-value { padding: 8px 14px; font-size: 15px; font-weight: 700; color: #1a1a2e; border: none; text-align: center; min-width: 40px; }
        .btn-remove { background: none; color: #f953c6; border: none; cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 5px; font-weight: 600; transition: color 0.3s; }
        .btn-remove:hover { color: #c73652; }

        .empty-cart { text-align: center; padding: 80px 20px; background: #fff; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .empty-cart-icon { font-size: 80px; color: #e8e8ff; margin-bottom: 20px; }
        .empty-cart h3 { font-size: 22px; font-weight: 700; color: #888; margin-bottom: 10px; }
        .empty-cart p { font-size: 15px; color: #aaa; margin-bottom: 25px; }
        .btn-shop { background: linear-gradient(135deg, #667eea, #f953c6); color: white; padding: 14px 35px; border-radius: 30px; font-size: 15px; font-weight: 700; display: inline-block; transition: transform 0.3s; }
        .btn-shop:hover { transform: translateY(-3px); }

        .order-summary { width: 340px; flex-shrink: 0; }
        .summary-card { background: #fff; border-radius: 20px; padding: 28px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); position: sticky; top: 90px; border: 1px solid #f0f0ff; }
        .summary-title { font-size: 18px; font-weight: 800; color: #1a1a2e; margin-bottom: 22px; padding-bottom: 15px; border-bottom: 2px solid #f0f0ff; }
        .summary-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; font-size: 14px; color: #555; }
        .summary-row.total { font-size: 20px; font-weight: 800; color: #1a1a2e; padding-top: 15px; border-top: 2px solid #f0f0ff; margin-top: 5px; }
        .summary-row.total span:last-child { color: #667eea; }
        .free-shipping { color: #4CAF50 !important; font-weight: 700; }
        .btn-checkout { width: 100%; background: linear-gradient(135deg, #667eea, #f953c6); color: white; border: none; padding: 16px; border-radius: 14px; font-size: 16px; font-weight: 800; cursor: pointer; margin-top: 20px; transition: transform 0.3s, box-shadow 0.3s; }
        .btn-checkout:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(102,126,234,0.4); }
        .btn-continue { width: 100%; background: #fff; color: #667eea; border: 2px solid #667eea; padding: 13px; border-radius: 14px; font-size: 14px; font-weight: 700; cursor: pointer; margin-top: 12px; transition: all 0.3s; text-align: center; display: block; }
        .btn-continue:hover { background: #667eea; color: white; }
        .promo-box { background: linear-gradient(135deg, #f0f0ff, #fff0ff); border: 2px dashed #667eea; border-radius: 12px; padding: 15px; margin-top: 20px; text-align: center; }
        .promo-box p { font-size: 13px; color: #667eea; font-weight: 600; }

        .footer { background: linear-gradient(135deg, #0f0c29, #302b63); padding: 20px 50px; text-align: center; font-size: 13px; color: rgba(255,255,255,0.4); margin-top: 40px; }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">Trendora</div>
        <form action="${pageContext.request.contextPath}/products" method="get">
            <div class="search-bar">
                <input type="text" name="search" placeholder="Search for clothes, brands..."/>
                <button type="submit"><i class="fas fa-search"></i></button>
            </div>
        </form>
        <div class="nav-right">
            <% if(session.getAttribute("user") != null) { %>
                <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> Profile</a>
                <a href="${pageContext.request.contextPath}/orders"><i class="fas fa-box"></i> Orders</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i> Login</a>
                <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
                <i class="fas fa-shopping-bag"></i> Cart
            </a>
        </div>
    </nav>

    <div class="page-header">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a> › Shopping Cart
        </div>
        <h1><i class="fas fa-shopping-bag"></i> Shopping Cart</h1>
        <p>Review your selected items before checkout</p>
    </div>

    <%
        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
        Double total = (Double) request.getAttribute("total");
        if(total == null) total = 0.0;
    %>

    <div class="cart-container">
        <div class="cart-items-section">
            <div class="cart-header">
                <h2>Your Items (<%= cartItems != null ? cartItems.size() : 0 %> items)</h2>
                <% if(cartItems != null && cartItems.size() > 0) { %>
                    <form action="${pageContext.request.contextPath}/cart" method="post">
                        <input type="hidden" name="action" value="clear"/>
                        <button type="submit" class="btn-clear-cart">
                            <i class="fas fa-trash"></i> Clear All
                        </button>
                    </form>
                <% } %>
            </div>

            <% if(cartItems != null && cartItems.size() > 0) { %>
                <% for(int i = 0; i < cartItems.size(); i++) {
                    CartItem item = cartItems.get(i);
                    Product product = cartProducts.get(i);

                    // ✅ FIX — Check if image URL starts with http
                    String cartImgUrl = product != null ? product.getImageUrl() : "";
                    String cartImgSrc = (cartImgUrl != null && cartImgUrl.startsWith("http")) ? cartImgUrl :
                                        request.getContextPath() + "/images/" + cartImgUrl;
                %>
                    <div class="cart-item">
                        <div class="cart-item-image">
                            <img src="<%=cartImgSrc%>"
                                 alt="<%= product != null ? product.getProductName() : "Product" %>"
                                 onerror="this.src='https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200&q=80'"/>
                        </div>
                        <div class="cart-item-details">
                            <div class="cart-item-name">
                                <%= product != null ? product.getProductName() : "Product" %>
                            </div>
                            <div class="cart-item-meta">
                                <span class="meta-tag">
                                    <i class="fas fa-ruler"></i> Size: <%= item.getSizeLabel() %>
                                </span>
                                <span class="meta-tag">
                                    <i class="fas fa-tag"></i> ₹<%= String.format("%.0f", item.getUnitPrice()) %> each
                                </span>
                            </div>
                            <div class="cart-item-price">
                                ₹<%= String.format("%.0f", item.getSubTotal()) %>
                            </div>
                            <div class="cart-item-unit">
                                <%= item.getQuantity() %> × ₹<%= String.format("%.0f", item.getUnitPrice()) %>
                            </div>
                        </div>
                        <div class="cart-item-actions">
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="update"/>
                                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>"/>
                                <div class="quantity-control">
                                    <button type="submit" name="quantity"
                                            value="<%= item.getQuantity() - 1 %>" class="qty-btn">−</button>
                                    <span class="qty-value"><%= item.getQuantity() %></span>
                                    <button type="submit" name="quantity"
                                            value="<%= item.getQuantity() + 1 %>" class="qty-btn">+</button>
                                </div>
                            </form>
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
                    <div class="empty-cart-icon"><i class="fas fa-shopping-bag"></i></div>
                    <h3>Your cart is empty!</h3>
                    <p>Looks like you haven't added anything yet.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn-shop">
                        <i class="fas fa-shopping-bag"></i> Start Shopping
                    </a>
                </div>
            <% } %>
        </div>

        <% if(cartItems != null && cartItems.size() > 0) { %>
            <div class="order-summary">
                <div class="summary-card">
                    <div class="summary-title">Order Summary</div>
                    <div class="summary-row">
                        <span>Subtotal (<%= cartItems.size() %> items)</span>
                        <span>₹<%= String.format("%.0f", total) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span class="free-shipping">FREE</span>
                    </div>
                    <div class="summary-row">
                        <span>Discount</span>
                        <span style="color:#4CAF50">Already Applied</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span>₹<%= String.format("%.0f", total) %></span>
                    </div>

                    <form action="${pageContext.request.contextPath}/checkout" method="get">
                        <button type="submit" class="btn-checkout">
                            <i class="fas fa-lock"></i> Proceed to Checkout
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/products" class="btn-continue">
                        <i class="fas fa-arrow-left"></i> Continue Shopping
                    </a>

                    <div class="promo-box">
                        <p><i class="fas fa-truck"></i> Free shipping on this order!</p>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Trendora. All Rights Reserved. Made with ❤️ in India</p>
    </footer>

</body>
</html>