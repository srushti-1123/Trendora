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

        .breadcrumb { padding: 15px 50px; font-size: 13px; color: #888; background: #fff; border-bottom: 1px solid #f0f0ff; }
        .breadcrumb a { color: #667eea; }
        .breadcrumb span { margin: 0 8px; color: #ccc; }

        .product-detail-container { display: flex; gap: 50px; padding: 40px 50px; max-width: 1400px; margin: 0 auto; }

        .product-image-section { width: 45%; flex-shrink: 0; }
        .main-image { width: 100%; height: 500px; border-radius: 24px; overflow: hidden; background: #fff; box-shadow: 0 10px 40px rgba(102,126,234,0.15); border: 1px solid #f0f0ff; }
        .main-image img { width: 100%; height: 100%; object-fit: cover; }

        .product-info-section { flex: 1; }
        .product-category { font-size: 12px; color: #667eea; font-weight: 800; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 12px; }
        .product-name { font-size: 30px; font-weight: 900; color: #1a1a2e; margin-bottom: 18px; line-height: 1.3; }
        .product-price-section { display: flex; align-items: center; gap: 15px; margin-bottom: 22px; flex-wrap: wrap; }
        .current-price { font-size: 36px; font-weight: 900; color: #667eea; }
        .old-price { font-size: 20px; color: #bbb; text-decoration: line-through; }
        .discount-tag { background: linear-gradient(135deg, #f953c6, #764ba2); color: white; padding: 5px 14px; border-radius: 20px; font-size: 13px; font-weight: 800; }
        .save-amount { font-size: 13px; color: #4CAF50; font-weight: 700; background: #E8F5E9; padding: 5px 12px; border-radius: 15px; }
        .product-description { font-size: 14px; color: #666; line-height: 1.8; margin-bottom: 28px; padding: 18px; background: #f8f8ff; border-radius: 14px; border-left: 4px solid #667eea; }

        /* SIZE SELECTION - KEY FIX */
        .size-section { margin-bottom: 28px; }
        .size-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; }
        .size-title { font-size: 15px; font-weight: 800; color: #1a1a2e; }
        .size-guide { font-size: 12px; color: #667eea; cursor: pointer; font-weight: 600; }
        .size-options { display: flex; flex-wrap: wrap; gap: 10px; }
        .size-btn {
            padding: 10px 20px;
            border: 2px solid #e8e8ff;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            background: #fff;
            color: #555;
            transition: all 0.3s;
            user-select: none;
        }
        .size-btn:hover {
            border-color: #667eea;
            color: #667eea;
            background: #f0f0ff;
        }
        .size-btn.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102,126,234,0.4);
        }
        .size-error { color: #f953c6; font-size: 13px; font-weight: 600; margin-top: 8px; display: none; }

        .quantity-section { margin-bottom: 28px; }
        .quantity-title { font-size: 15px; font-weight: 800; color: #1a1a2e; margin-bottom: 12px; }
        .quantity-control { display: flex; align-items: center; border: 2px solid #e8e8ff; border-radius: 12px; overflow: hidden; width: fit-content; }
        .qty-btn { background: #f8f8ff; border: none; padding: 12px 20px; font-size: 20px; cursor: pointer; transition: all 0.3s; color: #667eea; font-weight: 700; }
        .qty-btn:hover { background: #667eea; color: white; }
        .qty-input { border: none; outline: none; padding: 12px 20px; font-size: 16px; font-weight: 700; text-align: center; width: 70px; background: white; color: #1a1a2e; }

        .action-buttons { display: flex; gap: 15px; margin-bottom: 28px; }
        .btn-add-cart { flex: 1; background: linear-gradient(135deg, #667eea, #764ba2); color: white; border: none; padding: 16px; border-radius: 14px; font-size: 16px; font-weight: 800; cursor: pointer; transition: all 0.3s; display: flex; align-items: center; justify-content: center; gap: 10px; }
        .btn-add-cart:hover { background: linear-gradient(135deg, #f953c6, #764ba2); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(102,126,234,0.4); }

        .product-meta { background: #fff; border-radius: 16px; padding: 22px; box-shadow: 0 3px 15px rgba(0,0,0,0.06); border: 1px solid #f0f0ff; }
        .meta-item { display: flex; align-items: center; gap: 12px; padding: 10px 0; border-bottom: 1px solid #f0f0ff; font-size: 14px; color: #555; }
        .meta-item:last-child { border-bottom: none; }
        .meta-icon { width: 36px; height: 36px; background: #f0f0ff; border-radius: 10px; display: flex; align-items: center; justify-content: center; color: #667eea; font-size: 16px; flex-shrink: 0; }

        .related-section { padding: 50px; background: #f8f8ff; }
        .section-header { text-align: center; margin-bottom: 35px; }
        .section-tag { display: inline-block; background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 5px 18px; border-radius: 20px; font-size: 11px; font-weight: 800; margin-bottom: 12px; letter-spacing: 2px; }
        .section-title { font-size: 28px; font-weight: 900; color: #1a1a2e; }
        .section-title span { background: linear-gradient(135deg, #667eea, #f953c6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .related-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .product-card { background: #fff; border-radius: 20px; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; box-shadow: 0 3px 15px rgba(0,0,0,0.06); border: 1px solid #f0f0ff; }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 20px 50px rgba(102,126,234,0.2); }
        .product-card-image { height: 220px; overflow: hidden; }
        .product-card-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s; }
        .product-card:hover .product-card-image img { transform: scale(1.08); }
        .product-card-info { padding: 15px; }
        .product-card-info h3 { font-size: 14px; font-weight: 700; color: #1a1a2e; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-card-price { font-size: 16px; font-weight: 800; color: #667eea; }

        .alert { padding: 14px 18px; border-radius: 12px; margin: 0 50px 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background: #ffe5e9; color: #c73652; border: 1px solid #f953c6; }
        .alert-success { background: #e5ffe9; color: #2e7d32; border: 1px solid #4caf50; }

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

    <%
        Product product = (Product) request.getAttribute("product");
        List<ProductSize> sizes = (List<ProductSize>) request.getAttribute("sizes");
        Category category = (Category) request.getAttribute("category");
        List<Product> relatedProducts = (List<Product>) request.getAttribute("relatedProducts");

        String mainImgUrl = product.getImageUrl();
        String mainImgSrc = (mainImgUrl != null && mainImgUrl.startsWith("http")) ? mainImgUrl :
                            request.getContextPath() + "/images/" + mainImgUrl;

        int saving = (int)(product.getPrice() - product.getDiscountedPrice());
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

        <!-- IMAGE -->
        <div class="product-image-section">
            <div class="main-image">
                <img src="<%= mainImgSrc %>"
                     alt="<%= product.getProductName() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600'"/>
            </div>
        </div>

        <!-- INFO -->
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
                    <span class="save-amount">You save ₹<%= saving %></span>
                <% } %>
            </div>

            <div class="product-description">
                <%= product.getDescription() != null ? product.getDescription() : "Premium quality fashion product from Trendora." %>
            </div>

            <!-- SIZE SELECTION - FIXED -->
            <% if(sizes != null && sizes.size() > 0) { %>
                <div class="size-section">
                    <div class="size-header">
                        <div class="size-title">Select Size <span style="color:#f953c6">*</span></div>
                        <div class="size-guide"><i class="fas fa-ruler"></i> Size Guide</div>
                    </div>
                    <div class="size-options" id="sizeOptions">
                        <% for(ProductSize size : sizes) { %>
                            <div class="size-btn"
                                 onclick="selectSize(this, '<%= size.getSizeLabel() %>')">
                                <%= size.getSizeLabel() %>
                            </div>
                        <% } %>
                    </div>
                    <div class="size-error" id="sizeError">
                        <i class="fas fa-exclamation-circle"></i> Please select a size before adding to cart!
                    </div>
                </div>
            <% } %>

            <!-- QUANTITY -->
            <div class="quantity-section">
                <div class="quantity-title">Quantity</div>
                <div class="quantity-control">
                    <button type="button" class="qty-btn" onclick="decreaseQty()">−</button>
                    <input type="number" id="quantity" class="qty-input" value="1" min="1" max="10" readonly/>
                    <button type="button" class="qty-btn" onclick="increaseQty()">+</button>
                </div>
            </div>

            <!-- ADD TO CART FORM - FIXED -->
            <div class="action-buttons">
                <form action="${pageContext.request.contextPath}/cart" method="post" style="flex:1; display:flex;" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>"/>
                    <input type="hidden" name="productPrice" value="<%= product.getDiscountedPrice() %>"/>
                    <input type="hidden" id="selectedSize" name="sizeLabel" value=""/>
                    <input type="hidden" id="selectedQty" name="quantity" value="1"/>
                    <button type="submit" class="btn-add-cart">
                        <i class="fas fa-shopping-cart"></i> Add to Cart
                    </button>
                </form>
            </div>

            <!-- PRODUCT META -->
            <div class="product-meta">
                <div class="meta-item">
                    <div class="meta-icon"><i class="fas fa-truck"></i></div>
                    <span>Free delivery on orders above ₹999</span>
                </div>
                <div class="meta-item">
                    <div class="meta-icon"><i class="fas fa-undo"></i></div>
                    <span>Easy 7 day returns and exchanges</span>
                </div>
                <div class="meta-item">
                    <div class="meta-icon"><i class="fas fa-shield-alt"></i></div>
                    <span>100% Authentic Products guaranteed</span>
                </div>
                <div class="meta-item">
                    <div class="meta-icon"><i class="fas fa-credit-card"></i></div>
                    <span>Secure payments — COD, UPI, Card</span>
                </div>
            </div>
        </div>
    </div>

    <!-- RELATED PRODUCTS -->
    <% if(relatedProducts != null && relatedProducts.size() > 0) { %>
        <div class="related-section">
            <div class="section-header">
                <div class="section-tag">YOU MAY ALSO LIKE</div>
                <h2 class="section-title">Related <span>Products</span></h2>
            </div>
            <div class="related-grid">
                <% for(Product related : relatedProducts) {
                    String relImgUrl = related.getImageUrl();
                    String relImgSrc = (relImgUrl != null && relImgUrl.startsWith("http")) ? relImgUrl :
                                      request.getContextPath() + "/images/" + relImgUrl;
                %>
                    <a href="${pageContext.request.contextPath}/product-detail?productId=<%= related.getProductId() %>">
                        <div class="product-card">
                            <div class="product-card-image">
                                <img src="<%= relImgSrc %>"
                                     alt="<%= related.getProductName() %>"
                                     onerror="this.src='https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400'"/>
                            </div>
                            <div class="product-card-info">
                                <h3><%= related.getProductName() %></h3>
                                <span class="product-card-price">₹<%= String.format("%.0f", related.getDiscountedPrice()) %></span>
                            </div>
                        </div>
                    </a>
                <% } %>
            </div>
        </div>
    <% } %>

    <footer class="footer">
        <p>&copy; 2026 Trendora. All Rights Reserved. Made with ❤️ in India</p>
    </footer>

    <script>
        var selectedSize = '';

        // SIZE SELECTION - FIXED
        function selectSize(element, size) {
            // Remove selected from all size buttons
            var allSizeBtns = document.querySelectorAll('.size-btn');
            allSizeBtns.forEach(function(btn) {
                btn.classList.remove('selected');
            });

            // Add selected to clicked button
            element.classList.add('selected');

            // Update selected size variable
            selectedSize = size;

            // Update hidden input value
            document.getElementById('selectedSize').value = size;

            // Hide error if shown
            document.getElementById('sizeError').style.display = 'none';

            console.log('Size selected: ' + selectedSize);
            console.log('Hidden input value: ' + document.getElementById('selectedSize').value);
        }

        // QUANTITY CONTROLS
        function increaseQty() {
            var qty = document.getElementById('quantity');
            if(parseInt(qty.value) < 10) {
                qty.value = parseInt(qty.value) + 1;
                document.getElementById('selectedQty').value = qty.value;
            }
        }

        function decreaseQty() {
            var qty = document.getElementById('quantity');
            if(parseInt(qty.value) > 1) {
                qty.value = parseInt(qty.value) - 1;
                document.getElementById('selectedQty').value = qty.value;
            }
        }

        // FORM VALIDATION - FIXED
        function validateForm() {
            var sizeInput = document.getElementById('selectedSize').value;

            if(sizeInput === '' || sizeInput === null) {
                // Show error message
                document.getElementById('sizeError').style.display = 'block';

                // Scroll to size section
                document.getElementById('sizeOptions').scrollIntoView({behavior: 'smooth'});

                return false; // prevent form submission
            }

            // Update quantity before submit
            document.getElementById('selectedQty').value = document.getElementById('quantity').value;

            return true; // allow form submission
        }
    </script>
</body>
</html>