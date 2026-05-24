<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Register</title>
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
        .nav-right a { color: #fff; font-size: 14px; display: flex; align-items: center; gap: 5px; transition: color 0.3s; }
        .nav-right a:hover { color: #e94560; }
        .cart-icon { background-color: #e94560; padding: 8px 16px; border-radius: 20px; color: white !important; }

        /* AUTH */
        .auth-container { min-height: calc(100vh - 130px); display: flex; align-items: center; justify-content: center; padding: 40px 20px; background-color: #f5f5f5; }
        .auth-card { background-color: #fff; border-radius: 16px; padding: 40px; width: 100%; max-width: 520px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }
        .auth-header { text-align: center; margin-bottom: 30px; }
        .auth-header h2 { font-size: 28px; font-weight: 700; color: #1a1a2e; margin-bottom: 8px; }
        .auth-header p { color: #666; font-size: 15px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; }
        .input-group { display: flex; align-items: center; border: 2px solid #eee; border-radius: 10px; overflow: hidden; transition: border-color 0.3s; }
        .input-group:focus-within { border-color: #e94560; }
        .input-group i { padding: 12px 15px; color: #999; font-size: 14px; background-color: #f9f9f9; }
        .input-group input,
        .input-group select { border: none; outline: none; padding: 12px 15px; width: 100%; font-size: 14px; background-color: #fff; }
        .input-group select { cursor: pointer; }
        .btn-auth { width: 100%; background-color: #e94560; color: white; border: none; padding: 14px; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background-color 0.3s; margin-top: 10px; }
        .btn-auth:hover { background-color: #c73652; }
        .auth-footer { text-align: center; margin-top: 20px; font-size: 14px; color: #666; }
        .auth-footer a { color: #e94560; font-weight: 600; }
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-error { background-color: #ffe5e9; color: #c73652; border: 1px solid #e94560; }
        .alert-success { background-color: #e5ffe9; color: #2e7d32; border: 1px solid #4caf50; }

        /* FOOTER */
        .footer { background-color: #1a1a2e; color: #ccc; padding: 20px 40px; text-align: center; font-size: 13px; color: #666; }
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
            <a href="${pageContext.request.contextPath}/login"><i class="fas fa-user"></i> Login</a>
            <a href="${pageContext.request.contextPath}/register"><i class="fas fa-user-plus"></i> Register</a>
            <a href="${pageContext.request.contextPath}/cart" class="cart-icon">
                <i class="fas fa-shopping-cart"></i> Cart
            </a>
        </div>
    </nav>

    <!-- REGISTER FORM -->
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Create Account</h2>
                <p>Join Trendora and start shopping!</p>
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

            <form action="${pageContext.request.contextPath}/user" method="post">
                <input type="hidden" name="action" value="register"/>

                <div class="form-group">
                    <label>Full Name</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="fullName" placeholder="Enter your full name" required/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-group">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" placeholder="Enter your email" required/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <div class="input-group">
                        <i class="fas fa-phone"></i>
                        <input type="text" name="phone" placeholder="Enter your phone number" required/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Gender</label>
                    <div class="input-group">
                        <i class="fas fa-venus-mars"></i>
                        <select name="gender">
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Address</label>
                    <div class="input-group">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" name="address" placeholder="Enter your address"/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="password" placeholder="Enter your password" required/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <input type="password" name="confirmPassword" placeholder="Confirm your password" required/>
                    </div>
                </div>

                <button type="submit" class="btn-auth">Create Account</button>

                <div class="auth-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2024 Trendora. All Rights Reserved.</p>
    </footer>

</body>
</html>