<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.Product" %>
<%@ page import="com.trendora.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Products</title>
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
        .products-page { display: flex; gap: 25px; padding: 30px 40px; }
        .sidebar { width: 260px; flex-shrink: 0; }
        .filter-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .filter-title { font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #f0f0f0; }
        .category-item { display: block; padding: 10px 12px; border-radius: 8px; font-size: 14px; color: #555; margin-bottom: 5px; cursor: pointer; transition: all 0.3s; }
        .category-item:hover { background-color: #fff0f2; color: #e94560; }
        .category-item.active { background-color: #e94560; color: white; }
        .price-inputs { display: flex; gap: 10px; margin-bottom: 15px; }
        .price-inputs input { width: 100%; border: 2px solid #eee; border-radius: 8px; padding: 8px 12px; font-size: 13px; outline: none; }
        .price-inputs input:focus { border-color: #e94560; }
        .btn-filter { width: 100%; background-color: #1a1a2e; color: white; border: none; padding: 10px; border-radius: 8px; font-size: 14px; cursor: pointer; transition: background-color 0.3s; }
        .btn-filter:hover { background-color: #e94560; }
        .btn-clear { width: 100%; background-color: #f5f5f5; color: #555; border: none; padding: 10px; border-radius: 8px; font-size: 14px; cursor: pointer; margin-top: 8px; }
        .btn-clear:hover { background-color: #eee; }
        .products-main { flex: 1; }
        .products-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .products-header h2 { font-size: 22px; font-weight: 700; color: #1a1a2e; }
        .products-count { font-size: 14px; color: #888; }
        .products-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }
        .product-card { background-color: #fff; border-radius: 12px; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.15); }
        .product-image { position: relative; height: 250px; overflow: hidden; }
        .product-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .product-card:hover .product-image img { transform: scale(1.05); }
        .discount-badge { position: absolute; top: 10px; left: 10px; background-color: #e94560; color: white; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .product-info { padding: 15px; }
        .product-info h3 { font-size: 14px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-price { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
        .original-price { font-size: 12px; color: #999; text-decoration: line-through; }
        .discounted-price { font-size: 16px; font-weight: 700; color: #e94560; }
        .btn-view { display: block; text-align: center; background-color: #1a1a2e; color: white; padding: 8px; border-radius: 8px; font-size: 13px; font-weight: 600; transition: background-color 0.3s; }
        .btn-view:hover { background-color: #e94560; }
        .no-products { text-align: center; padding: 60px 20px; color: #888; }
        .no-products i { font-size: 48px; margin-bottom: 15px; color: #ddd; }
        .no-products p { font-size: 16px; }
        .footer { background-color: #1a1a2e; color: #ccc; padding: 20px 40px; text-align: center; font-size: 13px; color: #666; margin-top: 40px; }
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
                    <input type="text" name="search" placeholder="Search for clothes, brands..."
                           value="<%= request.getAttribute("search") != null ? request.getAttribute("search") : "" %>"/>
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

    <div class="products-page">

        <div class="sidebar">
            <div class="filter-card">
                <div class="filter-title">Categories</div>
                <a href="${pageContext.request.contextPath}/products"
                   class="category-item <%= request.getAttribute("selectedCategoryId") == null ? "active" : "" %>">
                    All Categories
                </a>
                <%
                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                    Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
                    if(categories != null) {
                        for(Category category : categories) {
                            boolean isActive = selectedCategoryId != null && selectedCategoryId == category.getCategoryId();
                %>
                    <a href="${pageContext.request.contextPath}/products?categoryId=<%= category.getCategoryId() %>"
                       class="category-item <%= isActive ? "active" : "" %>">
                        <%= category.getCategoryName() %>
                    </a>
                <%
                        }
                    }
                %>
            </div>

            <div class="filter-card">
                <div class="filter-title">Price Range</div>
                <form action="${pageContext.request.contextPath}/products" method="get">
                    <% if(request.getAttribute("selectedCategoryId") != null) { %>
                        <input type="hidden" name="categoryId" value="<%= request.getAttribute("selectedCategoryId") %>"/>
                    <% } %>
                    <% if(request.getAttribute("search") != null) { %>
                        <input type="hidden" name="search" value="<%= request.getAttribute("search") %>"/>
                    <% } %>
                    <div class="price-inputs">
                        <input type="number" name="minPrice" placeholder="Min ₹"
                               value="<%= request.getAttribute("minPrice") != null && !request.getAttribute("minPrice").equals(0.0) ? request.getAttribute("minPrice") : "" %>"/>
                        <input type="number" name="maxPrice" placeholder="Max ₹"
                               value="<%= request.getAttribute("maxPrice") != null && !request.getAttribute("maxPrice").equals(100000.0) ? request.getAttribute("maxPrice") : "" %>"/>
                    </div>
                    <button type="submit" class="btn-filter">Apply Filter</button>
                    <a href="${pageContext.request.contextPath}/products">
                        <button type="button" class="btn-clear">Clear Filters</button>
                    </a>
                </form>
            </div>
        </div>

        <div class="products-main">
            <%
                List<Product> products = (List<Product>) request.getAttribute("products");
                String searchKeyword = (String) request.getAttribute("search");
            %>

            <div class="products-header">
                <h2>
                    <% if(searchKeyword != null && !searchKeyword.isEmpty()) { %>
                        Search Results for "<%= searchKeyword %>"
                    <% } else if(selectedCategoryId != null) { %>
                        Category Products
                    <% } else { %>
                        All Products
                    <% } %>
                </h2>
                <span class="products-count">
                    <%= products != null ? products.size() : 0 %> products found
                </span>
            </div>

            <% if(products != null && products.size() > 0) { %>
                <div class="products-grid">
                    <% for(Product product : products) {
                        String imgUrl = product.getImageUrl();
                        String imgSrc = (imgUrl != null && imgUrl.startsWith("http")) ? imgUrl :
                                        request.getContextPath() + "/images/" + imgUrl;
                    %>
                        <div class="product-card">
                            <div class="product-image">
                                <img src="<%= imgSrc %>"
                                     alt="<%= product.getProductName() %>"
                                     onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'"/>
                                <% if(product.getDiscountPercent() > 0) { %>
                                    <span class="discount-badge"><%= product.getDiscountPercent() %>% OFF</span>
                                <% } %>
                            </div>
                            <div class="product-info">
                                <h3><%= product.getProductName() %></h3>
                                <div class="product-price">
                                    <% if(product.getDiscountPercent() > 0) { %>
                                        <span class="original-price">₹<%= product.getPrice() %></span>
                                    <% } %>
                                    <span class="discounted-price">₹<%= product.getDiscountedPrice() %></span>
                                </div>
                                <a href="${pageContext.request.contextPath}/product-detail?productId=<%= product.getProductId() %>"
                                   class="btn-view">View Product</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-products">
                    <i class="fas fa-search"></i>
                    <p>No products found!</p>
                </div>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>