<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.Product" %>
<%@ page import="com.trendora.model.Category" %>
<%@ page import="com.trendora.model.ProductSize" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Product Detail</title>
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
        .breadcrumb { padding: 15px 40px; font-size: 13px; color: #888; }
        .breadcrumb a { color: #e94560; }
        .breadcrumb span { margin: 0 8px; }
        .product-detail-container { display: flex; gap: 40px; padding: 20px 40px 40px; }
        .product-image-section { width: 45%; }
        .main-image { width: 100%; height: 450px; border-radius: 16px; overflow: hidden; background-color: #fff; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .main-image img { width: 100%; height: 100%; object-fit: cover; }
        .product-info-section { flex: 1; }
        .product-category { font-size: 13px; color: #e94560; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px; }
        .product-name { font-size: 28px; font-weight: 700; color: #1a1a2e; margin-bottom: 15px; line-height: 1.3; }
        .product-price-section { display: flex; align-items: center; gap: 15px; margin-bottom: 20px; }
        .current-price { font-size: 32px; font-weight: 800; color: #e94560; }
        .old-price { font-size: 18px; color: #999; text-decoration: line-through; }
        .discount-tag { background-color: #e94560; color: white; padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .product-description { font-size: 14px; color: #666; line-height: 1.7; margin-bottom: 25px; padding: 15px; background-color: #f9f9f9; border-radius: 10px; }
        .size-section { margin-bottom: 25px; }
        .size-title { font-size: 15px; font-weight: 600; color: #1a1a2e; margin-bottom: 12px; }
        .size-options { display: flex; flex-wrap: wrap; gap: 10px; }
        .size-btn { padding: 8px 18px; border: 2px solid #eee; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; background-color: #fff; transition: all 0.3s; }
        .size-btn:hover { border-color: #e94560; color: #e94560; }
        .size-btn.selected { border-color: #e94560; background-color: #e94560; color: white; }
        .quantity-section { margin-bottom: 25px; }
        .quantity-title { font-size: 15px; font-weight: 600; color: #1a1a2e; margin-bottom: 12px; }
        .quantity-control { display: flex; align-items: center; gap: 0; border: 2px solid #eee; border-radius: 10px; overflow: hidden; width: fit-content; }
        .qty-btn { background-color: #f5f5f5; border: none; padding: 10px 18px; font-size: 18px; cursor: pointer; transition: background-color 0.3s; }
        .qty-btn:hover { background-color: #e94560; color: white; }
        .qty-input { border: none; outline: none; padding: 10px 20px; font-size: 16px; font-weight: 600; text-align: center; width: 60px; }
        .action-buttons { display: flex; gap: 15px; margin-bottom: 25px; }
        .btn-add-cart { flex: 1; background-color: #1a1a2e; color: white; border: none; padding: 15px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background-color 0.3s; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-add-cart:hover { background-color: #e94560; }
        .product-meta { background-color: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .meta-item { display: flex; align-items: center; gap: 10px; padding: 8px 0; border-bottom: 1px solid #f0f0f0; font-size: 14px; color: #555; }
        .meta-item:last-child { border-bottom: none; }
        .meta-item i { color: #e94560; width: 20px; }
        .related-section { padding: 40px; }
        .section-title { font-size: 22px; font-weight: 700; color: #1a1a2e; margin-bottom: 25px; position: relative; }
        .section-title::after { content: ''; display: block; width: 50px; height: 3px; background-color: #e94560; margin-top: 8px; border-radius: 2px; }
        .related-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .product-card { background-color: #fff; border-radius: 12px; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.15); }
        .product-card-image { height: 200px; overflow: hidden; position: relative; }
        .product-card-image img { width: 100%; height: 100%; object-fit: cover; }
        .product-card-info { padding: 12px; }
        .product-card-info h3 { font-size: 13px; font-weight: 600; color: #1a1a2e; margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-card-price { font-size: 15px; font-weight: 700; color: #e94560; }
        .alert { padding: 12px 16px; border-radius: 8px; margin: 0 40px 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background-color: #ffe5e9; color: #c73652; border: 1px solid #e94560; }
        .alert-success { background-color: #e5ffe9; color: #2e7d32; border: 1px solid #4caf50; }
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
        Product product = (Product) request.getAttribute("product");
        List<ProductSize> sizes = (List<ProductSize>) request.getAttribute("sizes");
        Category category = (Category) request.getAttribute("category");
        List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");

        // Fix image URL for main product
        String mainImgUrl = product.getImageUrl();
        String mainImgSrc = (mainImgUrl != null && mainImgUrl.startsWith("http")) ? mainImgUrl :
                            request.getContextPath() + "/images/" + mainImgUrl;
    %>

    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <span>›</span>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <% if(category != null) { %>
            <span>›</span>
            <a href="${pageContext.request.contextPath}/products?categoryId=<%= category.getCategoryId() %>"><%= category.getCategoryName() %></a>
        <% } %>
        <span>›</span>
        <%= product.getProductName() %>
    </div>

    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    <% if(request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <%= request.getAttribute("success") %>
        </div>
    <% } %>

    <div class="product-detail-container">

        <!-- IMAGE SECTION -->
        <div class="product-image-section">
            <div class="main-image">
                <img src="<%= mainImgSrc %>"
                     alt="<%= product.getProductName() %>"
                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'"/>
            </div>
        </div>

        <!-- INFO SECTION -->
        <div class="product-info-section">
            <% if(category != null) { %>
                <div class="product-category"><%= category.getCategoryName() %></div>
            <% } %>

            <h1 class="product-name"><%= product.getProductName() %></h1>

            <div class="product-price-section">
                <span class="current-price">₹<%= String.format("%.0f", product.getDiscountedPrice()) %></span>
                <% if(product.getDiscountPercent() > 0) { %>
                    <span class="old-price">₹<%= String.format("%.0f", product.getPrice()) %></span>
                   <span class="discount-tag"><%= String.format("%.0f", product.getDiscountPercent()) %>% OFF</span>
                <% } %>
            </div>

            <div class="product-description">
                <%= product.getDescription() != null ? product.getDescription() : "No description available." %>
            </div>

            <% if(sizes != null && sizes.size() > 0) { %>
                <div class="size-section">
                    <div class="size-title">Select Size:</div>
                    <div class="size-options">
                        <% for(ProductSize size : sizes) { %>
                            <button class="size-btn" onclick="selectSize(this, '<%= size.getSizeLabel() %>')">
                                <%= size.getSizeLabel() %>
                            </button>
                        <% } %>
                    </div>
                </div>
            <% } %>

            <div class="quantity-section">
                <div class="quantity-title">Quantity:</div>
                <div class="quantity-control">
                    <button class="qty-btn" onclick="decreaseQty()">−</button>
                    <input type="number" id="quantity" class="qty-input" value="1" min="1" max="10" readonly/>
                    <button class="qty-btn" onclick="increaseQty()">+</button>
                </div>
            </div>

            <div class="action-buttons">
                <form action="${pageContext.request.contextPath}/cart" method="post" style="flex:1; display:flex;">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>"/>
                    <input type="hidden" name="productPrice" value="<%= product.getDiscountedPrice() %>"/>
                    <input type="hidden" id="selectedSize" name="sizeLabel" value=""/>
                    <input type="hidden" id="selectedQty" name="quantity" value="1"/>
                    <button type="submit" class="btn-add-cart" onclick="return validateForm()">
                        <i class="fas fa-shopping-cart"></i> Add to Cart
                    </button>