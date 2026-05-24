<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.trendora.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - My Profile</title>
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

        .profile-container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .page-title { font-size: 24px; font-weight: 700; color: #1a1a2e; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
        .page-title i { color: #e94560; }

        .profile-header { background-color: #1a1a2e; border-radius: 16px; padding: 30px; display: flex; align-items: center; gap: 25px; margin-bottom: 25px; }
        .profile-avatar { width: 80px; height: 80px; background-color: #e94560; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; color: white; font-weight: 700; flex-shrink: 0; }
        .profile-header-info h2 { font-size: 22px; font-weight: 700; color: white; margin-bottom: 5px; }
        .profile-header-info p { font-size: 14px; color: #aaa; }
        .profile-header-info span { font-size: 13px; color: #e94560; background-color: rgba(233,69,96,0.15); padding: 3px 10px; border-radius: 20px; margin-top: 8px; display: inline-block; }

        .profile-card { background-color: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .card-title { font-size: 17px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; display: flex; align-items: center; gap: 10px; }
        .card-title i { color: #e94560; }

        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; border: 2px solid #eee; border-radius: 10px; padding: 12px 15px; font-size: 14px; outline: none; transition: border-color 0.3s; font-family: inherit; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #e94560; }
        .form-group textarea { resize: none; height: 80px; }
        .form-group input[readonly] { background-color: #f9f9f9; color: #888; cursor: not-allowed; }
        .form-row { display: flex; gap: 15px; }
        .form-row .form-group { flex: 1; }

        .btn-update { background-color: #e94560; color: white; border: none; padding: 12px 30px; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background-color 0.3s; }
        .btn-update:hover { background-color: #c73652; }

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background-color: #ffe5e9; color: #c73652; border: 1px solid #e94560; }
        .alert-success { background-color: #e5ffe9; color: #2e7d32; border: 1px solid #4caf50; }

        .quick-links { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 25px; }
        .quick-link-card { background-color: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 15px; transition: transform 0.2s; }
        .quick-link-card:hover { transform: translateY(-3px); }
        .quick-link-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .icon-orders { background-color: #fff3e0; color: #f57c00; }
        .icon-cart { background-color: #e3f2fd; color: #1976d2; }
        .quick-link-info h4 { font-size: 15px; font-weight: 600; color: #1a1a2e; margin-bottom: 3px; }
        .quick-link-info p { font-size: 12px; color: #888; }

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
        User user = (User) request.getAttribute("user");
        String initial = user != null && user.getFullName() != null ?
                String.valueOf(user.getFullName().charAt(0)).toUpperCase() : "U";
    %>

    <div class="profile-container">

        <div class="page-title">
            <i class="fas fa-user-circle"></i>
            My Profile
        </div>

        <!-- ALERTS -->
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

        <!-- PROFILE HEADER -->
        <div class="profile-header">
            <div class="profile-avatar"><%= initial %></div>
            <div class="profile-header-info">
                <h2><%= user != null ? user.getFullName() : "User" %></h2>
                <p><%= user != null ? user.getEmail() : "" %></p>
                <span><i class="fas fa-phone"></i> <%= user != null ? user.getPhone() : "" %></span>
            </div>
        </div>

        <!-- QUICK LINKS -->
        <div class="quick-links">
            <a href="${pageContext.request.contextPath}/orders">
                <div class="quick-link-card">
                    <div class="quick-link-icon icon-orders">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="quick-link-info">
                        <h4>My Orders</h4>
                        <p>View your order history</p>
                    </div>
                </div>
            </a>
            <a href="${pageContext.request.contextPath}/cart">
                <div class="quick-link-card">
                    <div class="quick-link-icon icon-cart">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="quick-link-info">
                        <h4>My Cart</h4>
                        <p>View items in your cart</p>
                    </div>
                </div>
            </a>
        </div>

        <!-- UPDATE PROFILE -->
        <div class="profile-card">
            <div class="card-title">
                <i class="fas fa-user-edit"></i>
                Personal Information
            </div>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="updateProfile"/>
                <div class="form-row">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName"
                               value="<%= user != null ? user.getFullName() : "" %>" required/>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" value="<%= user != null ? user.getEmail() : "" %>" readonly/>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone"
                               value="<%= user != null ? user.getPhone() : "" %>" required/>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="">Select Gender</option>
                            <option value="Male" <%= user != null && "Male".equals(user.getGender()) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= user != null && "Female".equals(user.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= user != null && "Other".equals(user.getGender()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn-update">
                    <i class="fas fa-save"></i> Update Profile
                </button>
            </form>
        </div>

        <!-- UPDATE ADDRESS -->
        <div class="profile-card">
            <div class="card-title">
                <i class="fas fa-map-marker-alt"></i>
                Delivery Address
            </div>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="updateAddress"/>
                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" placeholder="Enter your delivery address"><%= user != null && user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>
                <button type="submit" class="btn-update">
                    <i class="fas fa-save"></i> Update Address
                </button>
            </form>
        </div>

    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>