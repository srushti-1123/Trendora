
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.trendora.model.Product" %>
<%@ page import="com.trendora.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trendora - Redefine Your Style</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f8ff; color: #333; }
        a { text-decoration: none; color: inherit; }

        /* NAVBAR */
        .navbar {
            display: flex; align-items: center; justify-content: space-between;
            background: #fff; padding: 15px 60px; position: sticky; top: 0; z-index: 1000;
            box-shadow: 0 2px 20px rgba(102,126,234,0.1);
            border-bottom: 1px solid #f0f0ff;
        }
        .logo {
            font-size: 28px; font-weight: 900; letter-spacing: 2px;
            background: linear-gradient(135deg, #667eea, #764ba2, #f953c6);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .search-bar {
            display: flex; align-items: center;
            background: #f8f8ff; border: 2px solid #e8e8ff;
            border-radius: 30px; overflow: hidden; width: 420px;
            transition: border-color 0.3s;
        }
        .search-bar:focus-within { border-color: #667eea; }
        .search-bar input {
            border: none; outline: none; padding: 10px 18px;
            width: 100%; font-size: 14px; background: transparent; color: #333;
        }
        .search-bar input::placeholder { color: #aaa; }
        .search-bar button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; padding: 10px 18px; cursor: pointer; color: white; font-size: 14px;
        }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .nav-right a {
            color: #555; font-size: 14px; display: flex; align-items: center;
            gap: 6px; transition: color 0.3s; font-weight: 500;
        }
        .nav-right a:hover { color: #667eea; }
        .cart-btn {
            background: linear-gradient(135deg, #667eea, #764ba2, #f953c6);
            padding: 9px 18px; border-radius: 25px; color: white !important;
            font-weight: 700; display: flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 15px rgba(102,126,234,0.4);
        }

        /* MOBILE MENU */
        .hamburger {
            display: none; background: none; border: none;
            font-size: 24px; color: #667eea; cursor: pointer;
        }
        .mobile-menu {
            display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5); z-index: 9999;
        }
        .mobile-menu.active { display: block; }
        .mobile-menu-content {
            position: absolute; top: 0; right: 0; width: 280px; height: 100%;
            background: #fff; padding: 30px 25px;
            box-shadow: -5px 0 30px rgba(0,0,0,0.2);
        }
        .mobile-menu-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;
        }
        .mobile-menu-logo {
            font-size: 24px; font-weight: 900;
            background: linear-gradient(135deg, #667eea, #f953c6);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .mobile-menu-close {
            background: none; border: none; font-size: 24px; cursor: pointer; color: #888;
        }
        .mobile-search {
            display: flex; align-items: center; background: #f8f8ff;
            border: 2px solid #e8e8ff; border-radius: 25px; overflow: hidden; margin-bottom: 25px;
        }
        .mobile-search input {
            border: none; outline: none; padding: 10px 15px;
            width: 100%; font-size: 14px; background: transparent;
        }
        .mobile-search button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; padding: 10px 15px; cursor: pointer; color: white;
        }
        .mobile-nav-links a {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 0; border-bottom: 1px solid #f0f0ff;
            font-size: 15px; color: #333; font-weight: 500;
        }
        .mobile-nav-links a i { color: #667eea; width: 20px; }
        .mobile-nav-links a:last-child { border-bottom: none; }
        .mobile-cart-btn {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            background: linear-gradient(135deg, #667eea, #f953c6);
            color: white; padding: 14px; border-radius: 14px;
            font-size: 15px; font-weight: 700; margin-top: 25px;
        }

        /* MARQUEE */
        .marquee-section {
            background: linear-gradient(90deg, #667eea, #764ba2, #f953c6, #764ba2, #667eea);
            padding: 10px 0; overflow: hidden;
        }
        .marquee-content {
            display: flex; gap: 60px; animation: marquee 25s linear infinite; white-space: nowrap;
        }
        .marquee-content span { color: white; font-size: 13px; font-weight: 700; letter-spacing: 1px; }
        @keyframes marquee { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }

        /* HERO */
        .hero-banner {
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 40%, #1a0533 100%);
            min-height: 600px; display: flex; align-items: center;
            padding: 70px 80px; position: relative; overflow: hidden;
        }
        .hero-banner::before {
            content: ''; position: absolute; top: -100px; right: -100px;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(102,126,234,0.25), transparent 70%);
            border-radius: 50%;
        }
        .hero-content { color: white; max-width: 580px; z-index: 2; }
        .hero-tag {
            display: inline-block; background: rgba(249,83,198,0.2);
            color: #f953c6; padding: 8px 22px; border-radius: 25px;
            font-size: 13px; font-weight: 700; margin-bottom: 25px;
            border: 1px solid rgba(249,83,198,0.4); letter-spacing: 2px;
        }
        .hero-content h1 { font-size: 56px; font-weight: 900; line-height: 1.1; margin-bottom: 20px; }
        .hero-content h1 span {
            background: linear-gradient(90deg, #f953c6, #667eea, #FFD93D);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero-subtitle { font-size: 17px; color: rgba(255,255,255,0.7); margin-bottom: 35px; line-height: 1.7; }
        .hero-buttons { display: flex; gap: 15px; margin-bottom: 45px; flex-wrap: wrap; }
        .btn-primary-hero {
            background: linear-gradient(135deg, #667eea, #f953c6);
            color: white; padding: 14px 32px; border-radius: 35px;
            font-size: 15px; font-weight: 800; transition: transform 0.3s;
            display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 8px 25px rgba(102,126,234,0.5);
        }
        .btn-primary-hero:hover { transform: translateY(-3px); }
        .btn-secondary-hero {
            background: rgba(255,255,255,0.1); color: white;
            padding: 14px 32px; border-radius: 35px; font-size: 15px; font-weight: 700;
            border: 2px solid rgba(255,255,255,0.3); transition: all 0.3s; display: inline-block;
        }
        .btn-secondary-hero:hover { background: rgba(255,255,255,0.2); border-color: #f953c6; }
        .hero-stats { display: flex; gap: 40px; }
        .stat-item { text-align: center; }
        .stat-number {
            font-size: 30px; font-weight: 900;
            background: linear-gradient(90deg, #f953c6, #FFD93D);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .stat-label { font-size: 11px; color: rgba(255,255,255,0.5); margin-top: 4px; letter-spacing: 2px; }
        .hero-image {
            position: absolute; right: 80px; top: 50%;
            transform: translateY(-50%); width: 400px; height: 500px;
            border-radius: 40px; overflow: hidden; z-index: 2;
            box-shadow: 0 40px 100px rgba(0,0,0,0.6);
            border: 3px solid rgba(102,126,234,0.4);
        }
        .hero-image img { width: 100%; height: 100%; object-fit: cover; }
        .floating-badge {
            position: absolute; bottom: 50px; right: 500px; z-index: 3;
            background: white; padding: 16px 22px; border-radius: 20px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3); min-width: 160px;
        }
        .floating-badge-label { font-size: 11px; color: #888; margin-bottom: 6px; }
        .floating-badge-value { font-size: 20px; font-weight: 900; color: #667eea; }
        .floating-badge-sub { font-size: 11px; color: #f953c6; font-weight: 700; margin-top: 3px; }

        /* CATEGORIES */
        .categories-section { padding: 70px 50px; background: #fff; }
        .section-header { text-align: center; margin-bottom: 45px; }
        .section-tag {
            display: inline-block; background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 6px 22px; border-radius: 25px;
            font-size: 11px; font-weight: 800; margin-bottom: 15px; letter-spacing: 3px;
        }
        .section-title { font-size: 36px; font-weight: 900; color: #1a1a2e; }
        .section-title span {
            background: linear-gradient(135deg, #667eea, #f953c6);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .section-subtitle { font-size: 15px; color: #888; margin-top: 10px; }
        .categories-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 18px; }
        .category-card {
            position: relative; border-radius: 20px; overflow: hidden;
            height: 280px; cursor: pointer; transition: transform 0.4s, box-shadow 0.4s;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .category-card:hover { transform: translateY(-8px); box-shadow: 0 20px 50px rgba(102,126,234,0.2); }
        .category-card img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s; }
        .category-card:hover img { transform: scale(1.1); }
        .category-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(15,12,41,0.9) 0%, rgba(48,43,99,0.3) 50%, transparent 100%);
            display: flex; flex-direction: column; justify-content: flex-end; padding: 20px 15px;
        }
        .category-name { font-size: 18px; font-weight: 900; color: white; margin-bottom: 4px; }
        .category-count { font-size: 11px; color: rgba(255,255,255,0.7); margin-bottom: 10px; }
        .category-btn {
            display: inline-block; background: linear-gradient(135deg, #667eea, #f953c6);
            color: white; padding: 6px 14px; border-radius: 15px;
            font-size: 11px; font-weight: 700; width: fit-content;
        }

        /* PRODUCTS */
        .products-section { padding: 70px 50px; background: #f8f8ff; }
        .products-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 22px; }
        .product-card {
            background: white; border-radius: 20px; overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); border: 1px solid #f0f0ff;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 20px 50px rgba(102,126,234,0.2); }
        .product-image { position: relative; height: 280px; overflow: hidden; background: #f9f9f9; }
        .product-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
        .product-card:hover .product-image img { transform: scale(1.08); }
        .discount-badge {
            position: absolute; top: 12px; left: 12px;
            background: linear-gradient(135deg, #f953c6, #764ba2);
            color: white; padding: 4px 12px; border-radius: 15px; font-size: 11px; font-weight: 800;
        }
        .new-badge {
            position: absolute; top: 12px; left: 12px;
            background: linear-gradient(135deg, #667eea, #4ECDC4);
            color: white; padding: 4px 12px; border-radius: 15px; font-size: 11px; font-weight: 800;
        }
        .wishlist-btn {
            position: absolute; top: 12px; right: 12px;
            background: white; border: none; width: 36px; height: 36px;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 14px; color: #f953c6;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .product-info { padding: 16px; }
        .product-brand { font-size: 11px; color: #667eea; font-weight: 800; letter-spacing: 1px; margin-bottom: 5px; text-transform: uppercase; }
        .product-info h3 { font-size: 14px; font-weight: 700; color: #1a1a2e; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .product-price { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
        .discounted-price { font-size: 18px; font-weight: 900; color: #667eea; }
        .original-price { font-size: 13px; color: #bbb; text-decoration: line-through; }
        .save-tag { font-size: 10px; color: #4CAF50; font-weight: 800; background: #E8F5E9; padding: 3px 8px; border-radius: 10px; }
        .btn-add-cart {
            display: block; text-align: center;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 10px; border-radius: 12px; font-size: 13px; font-weight: 700;
        }
        .btn-add-cart:hover { background: linear-gradient(135deg, #f953c6, #764ba2); }

        /* PROMO */
        .promo-section { padding: 50px; background: #fff; display: grid; grid-template-columns: 1fr 1fr; gap: 22px; }
        .promo-card {
            border-radius: 24px; padding: 40px; position: relative; overflow: hidden; min-height: 240px;
            display: flex; flex-direction: column; justify-content: center;
        }
        .promo-card-1 { background: linear-gradient(135deg, #0f0c29, #302b63, #1a0533); }
        .promo-card-2 { background: linear-gradient(135deg, #f953c6, #667eea, #764ba2); }
        .promo-offer-tag {
            display: inline-block; background: rgba(255,255,255,0.2);
            color: white; padding: 5px 14px; border-radius: 15px;
            font-size: 11px; font-weight: 800; margin-bottom: 14px; width: fit-content;
        }
        .promo-card h3 { font-size: 26px; font-weight: 900; color: white; margin-bottom: 8px; line-height: 1.2; }
        .promo-card p { font-size: 13px; color: rgba(255,255,255,0.8); margin-bottom: 22px; }
        .promo-btn {
            display: inline-block; background: white; padding: 11px 26px;
            border-radius: 25px; font-size: 13px; font-weight: 800; color: #764ba2; width: fit-content;
        }
        .promo-img {
            position: absolute; right: 20px; bottom: 0;
            width: 160px; height: 200px; object-fit: cover; border-radius: 18px 18px 0 0;
        }

        /* DEALS */
        .deals-section { padding: 70px 50px; background: #f8f8ff; }

        /* BRANDS */
        .brands-section { padding: 50px; background: #fff; text-align: center; }
        .brands-grid { display: flex; justify-content: center; align-items: center; gap: 40px; flex-wrap: wrap; margin-top: 35px; }
        .brand-item { font-size: 20px; font-weight: 900; color: #ccc; transition: all 0.3s; cursor: pointer; letter-spacing: 2px; }
        .brand-item:hover { background: linear-gradient(135deg, #667eea, #f953c6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; transform: scale(1.1); }

        /* NEWSLETTER */
        .newsletter-section { background: linear-gradient(135deg, #0f0c29, #302b63); padding: 60px 50px; text-align: center; }
        .newsletter-section h2 { font-size: 32px; font-weight: 900; color: white; margin-bottom: 12px; }
        .newsletter-section h2 span { background: linear-gradient(90deg, #f953c6, #FFD93D); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .newsletter-section p { font-size: 15px; color: rgba(255,255,255,0.65); margin-bottom: 30px; }
        .newsletter-form { display: flex; max-width: 500px; margin: 0 auto; }
        .newsletter-form input { flex: 1; border: none; outline: none; padding: 14px 22px; border-radius: 35px 0 0 35px; font-size: 14px; background: rgba(255,255,255,0.1); color: white; border: 1px solid rgba(255,255,255,0.2); }
        .newsletter-form input::placeholder { color: rgba(255,255,255,0.4); }
        .newsletter-form button { background: linear-gradient(135deg, #667eea, #f953c6); color: white; border: none; padding: 14px 28px; border-radius: 0 35px 35px 0; font-size: 14px; font-weight: 800; cursor: pointer; }

        /* FOOTER */
        .footer { background: linear-gradient(135deg, #0f0c29, #302b63); padding: 60px 50px 25px; }
        .footer-grid { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 40px; margin-bottom: 40px; }
        .footer-brand .logo-footer { font-size: 28px; font-weight: 900; background: linear-gradient(135deg, #667eea, #764ba2, #f953c6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 15px; display: block; }
        .footer-brand p { font-size: 14px; color: rgba(255,255,255,0.5); line-height: 1.8; margin-bottom: 22px; }
        .social-links { display: flex; gap: 10px; flex-wrap: wrap; }
        .social-link { width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.08); display: flex; align-items: center; justify-content: center; color: white; font-size: 15px; transition: all 0.3s; border: 1px solid rgba(255,255,255,0.1); }
        .social-link:hover { background: linear-gradient(135deg, #667eea, #f953c6); }
        .footer-col h4 { font-size: 14px; font-weight: 800; color: white; margin-bottom: 18px; }
        .footer-col a { display: block; font-size: 13px; color: rgba(255,255,255,0.5); margin-bottom: 10px; transition: all 0.3s; }
        .footer-col a:hover { color: #667eea; padding-left: 5px; }
        .footer-divider { border: none; border-top: 1px solid rgba(255,255,255,0.08); margin-bottom: 22px; }
        .footer-bottom { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: rgba(255,255,255,0.3); flex-wrap: wrap; gap: 10px; }

        /* ========================================
           RESPONSIVE CSS — MOBILE & TABLET
        ======================================== */

        /* TABLET — 768px to 1024px */
        @media (max-width: 1024px) {
            .navbar { padding: 15px 30px; }
            .search-bar { width: 300px; }
            .hero-banner { padding: 50px 40px; min-height: 500px; }
            .hero-content h1 { font-size: 44px; }
            .hero-image { width: 320px; height: 400px; right: 40px; }
            .floating-badge { right: 380px; bottom: 30px; }
            .categories-grid { grid-template-columns: repeat(3, 1fr); }
            .products-grid { grid-template-columns: repeat(3, 1fr); }
            .footer-grid { grid-template-columns: 1fr 1fr; gap: 30px; }
            .categories-section { padding: 50px 30px; }
            .products-section { padding: 50px 30px; }
            .deals-section { padding: 50px 30px; }
            .promo-section { padding: 30px; }
        }

        /* MOBILE — below 768px */
        @media (max-width: 768px) {

            /* NAVBAR — hide search and links, show hamburger */
            .navbar { padding: 14px 20px; }
            .search-bar { display: none; }
            .nav-right { display: none; }
            .hamburger { display: block; }
            .logo { font-size: 24px; }

            /* HERO — full width, no side image */
            .hero-banner {
                padding: 40px 25px;
                min-height: auto;
                text-align: center;
            }
            .hero-content { max-width: 100%; }
            .hero-content h1 { font-size: 32px; }
            .hero-subtitle { font-size: 14px; margin-bottom: 25px; }
            .hero-tag { font-size: 11px; padding: 6px 16px; margin-bottom: 16px; }
            .hero-buttons { justify-content: center; gap: 10px; }
            .btn-primary-hero { padding: 12px 24px; font-size: 14px; }
            .btn-secondary-hero { padding: 12px 24px; font-size: 14px; }
            .hero-stats { justify-content: center; gap: 25px; margin-top: 25px; }
            .stat-number { font-size: 22px; }
            .hero-image { display: none; }
            .floating-badge { display: none; }

            /* CATEGORIES — 2 columns */
            .categories-section { padding: 40px 15px; }
            .section-title { font-size: 26px; }
            .section-subtitle { font-size: 13px; }
            .categories-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .category-card { height: 160px; border-radius: 14px; }
            .category-name { font-size: 14px; }
            .category-btn { font-size: 10px; padding: 4px 10px; }

            /* PRODUCTS — 2 columns */
            .products-section { padding: 40px 15px; }
            .products-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .product-image { height: 200px; }
            .product-info { padding: 12px; }
            .product-info h3 { font-size: 13px; }
            .discounted-price { font-size: 15px; }
            .btn-add-cart { padding: 8px; font-size: 12px; }

            /* PROMO — stack vertically */
            .promo-section { grid-template-columns: 1fr; padding: 20px 15px; gap: 15px; }
            .promo-card { padding: 25px; min-height: 180px; }
            .promo-card h3 { font-size: 20px; }
            .promo-img { width: 110px; height: 140px; }

            /* DEALS */
            .deals-section { padding: 40px 15px; }

            /* BRANDS */
            .brands-section { padding: 35px 15px; }
            .brands-grid { gap: 20px; }
            .brand-item { font-size: 16px; }

            /* NEWSLETTER */
            .newsletter-section { padding: 40px 20px; }
            .newsletter-section h2 { font-size: 22px; }
            .newsletter-section p { font-size: 13px; }
            .newsletter-form { flex-direction: column; gap: 10px; max-width: 100%; }
            .newsletter-form input { border-radius: 25px; padding: 12px 18px; }
            .newsletter-form button { border-radius: 25px; padding: 12px 18px; }

            /* FOOTER */
            .footer { padding: 40px 20px 20px; }
            .footer-grid { grid-template-columns: 1fr; gap: 25px; }
            .footer-bottom { flex-direction: column; text-align: center; gap: 8px; }
        }

        /* SMALL MOBILE — below 480px */
        @media (max-width: 480px) {
            .hero-content h1 { font-size: 26px; }
            .categories-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
            .category-card { height: 140px; }
            .products-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
            .product-image { height: 170px; }
            .section-title { font-size: 22px; }
            .hero-stats { gap: 18px; }
            .stat-number { font-size: 18px; }
        }
    </style>
</head>
<body>

    <!-- MOBILE MENU -->
    <div class="mobile-menu" id="mobileMenu" onclick="closeMobileMenu(event)">
        <div class="mobile-menu-content">
            <div class="mobile-menu-header">
                <span class="mobile-menu-logo">Trendora</span>
                <button class="mobile-menu-close" onclick="toggleMobileMenu()">✕</button>
            </div>
            <form action="${pageContext.request.contextPath}/products" method="get">
                <div class="mobile-search">
                    <input type="text" name="search" placeholder="Search fashion..."/>
                    <button type="submit"><i class="fas fa-search"></i></button>
                </div>
            </form>
            <div class="mobile-nav-links">
                <% if(session.getAttribute("user") != null) { %>
                    <a href="${pageContext.request.contextPath}/profile">
                        <i class="fas fa-user"></i> Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/orders">
                        <i class="fas fa-box"></i> My Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-user"></i> Login
                    </a>
                    <a href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus"></i> Register
                    </a>
                <% } %>
                <a href="${pageContext.request.contextPath}/products">
                    <i class="fas fa-shopping-bag"></i> All Products
                </a>
            </div>
            <a href="${pageContext.request.contextPath}/cart" class="mobile-cart-btn">
                <i class="fas fa-shopping-cart"></i> View Cart
            </a>
        </div>
    </div>

    <!-- NAVBAR -->
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
        <button class="hamburger" onclick="toggleMobileMenu()">
            <i class="fas fa-bars"></i>
        </button>
    </nav>

    <!-- MARQUEE -->
    <div class="marquee-section">
        <div class="marquee-content">
            <span>🔥 NEW COLLECTION ARRIVED</span>
            <span>⭐ FREE SHIPPING ON ORDERS ABOVE ₹999</span>
            <span>💥 UPTO 50% OFF ON SELECTED ITEMS</span>
            <span>🎁 EASY 7 DAY RETURNS</span>
            <span>✨ PREMIUM QUALITY GUARANTEED</span>
            <span>💎 EXCLUSIVE MEMBER DISCOUNTS</span>
            <span>🔥 NEW COLLECTION ARRIVED</span>
            <span>⭐ FREE SHIPPING ON ORDERS ABOVE ₹999</span>
            <span>💥 UPTO 50% OFF ON SELECTED ITEMS</span>
            <span>🎁 EASY 7 DAY RETURNS</span>
            <span>✨ PREMIUM QUALITY GUARANTEED</span>
            <span>💎 EXCLUSIVE MEMBER DISCOUNTS</span>
        </div>
    </div>

    <!-- HERO BANNER -->
    <section class="hero-banner">
        <div class="hero-content">
            <div class="hero-tag">✨ SUMMER COLLECTION 2026</div>
            <h1>Redefine Your<br/><span>Everyday Style</span></h1>
            <p class="hero-subtitle">Discover premium fashion for every occasion. Handpicked styles for Men, Women & Kids.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/products" class="btn-primary-hero">
                    Shop Now <i class="fas fa-arrow-right"></i>
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn-secondary-hero">
                    New Arrivals
                </a>
            </div>
            <div class="hero-stats">
                <div class="stat-item">
                    <div class="stat-number">500+</div>
                    <div class="stat-label">PRODUCTS</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">50K+</div>
                    <div class="stat-label">CUSTOMERS</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">4.9★</div>
                    <div class="stat-label">RATING</div>
                </div>
            </div>
        </div>
        <div class="hero-image">
            <img src="https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600&q=80" alt="Fashion"/>
        </div>
        <div class="floating-badge">
            <div class="floating-badge-label">🔥 Today's Special</div>
            <div class="floating-badge-value">Upto 50% OFF</div>
            <div class="floating-badge-sub">Limited Time Offer!</div>
        </div>
    </section>

    <!-- CATEGORIES -->
    <section class="categories-section">
        <div class="section-header">
            <div class="section-tag">SHOP BY CATEGORY</div>
            <h2 class="section-title">Explore Our <span>Collections</span></h2>
            <p class="section-subtitle">Find the perfect style for every occasion</p>
        </div>
        <div class="categories-grid">
            <%
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                String[] categoryImages = {
                    "https://images.unsplash.com/photo-1617137968427-85924c800a22?w=400&q=80",
                    "https://images.unsplash.com/photo-1581044777550-4cfa60707c03?w=400&q=80",
                    "https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400&q=80",
                    "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&q=80",
                    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80"
                };
                int catIndex = 0;
                if(categories != null) {
                    for(Category category : categories) {
                        String catImg = catIndex < categoryImages.length ? categoryImages[catIndex] : categoryImages[0];
            %>
                <a href="${pageContext.request.contextPath}/products?categoryId=<%=category.getCategoryId()%>" class="category-card">
                    <img src="<%=catImg%>" alt="<%=category.getCategoryName()%>"/>
                    <div class="category-overlay">
                        <div class="category-name"><%=category.getCategoryName()%></div>
                        <div class="category-count">Explore Collection</div>
                        <span class="category-btn">Shop Now →</span>
                    </div>
                </a>
            <%
                        catIndex++;
                    }
                }
            %>
        </div>
    </section>

    <!-- FEATURED PRODUCTS -->
    <section class="products-section">
        <div class="section-header">
            <div class="section-tag">FEATURED</div>
            <h2 class="section-title">Trending <span>Products</span></h2>
            <p class="section-subtitle">Most loved styles by our customers</p>
        </div>
        <div class="products-grid">
            <%
                List<Product> featuredProducts = (List<Product>) request.getAttribute("featuredProducts");
                if(featuredProducts != null) {
                    for(Product product : featuredProducts) {
                        String imgUrl = product.getImageUrl();
                        String imgSrc = (imgUrl != null && imgUrl.startsWith("http")) ? imgUrl :
                                        request.getContextPath() + "/images/" + imgUrl;
                        int saving = (int)(product.getPrice() - product.getDiscountedPrice());
            %>
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product-detail?productId=<%=product.getProductId()%>">
                        <div class="product-image">
                            <img src="<%=imgSrc%>" alt="<%=product.getProductName()%>"
                                 onerror="this.src='https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400'"/>
                            <% if(product.getDiscountPercent() > 0) { %>
                                <span class="discount-badge"><%=String.format("%.0f", product.getDiscountPercent())%>% OFF</span>
                            <% } else { %>
                                <span class="new-badge">NEW</span>
                            <% } %>
                            <button class="wishlist-btn"><i class="fas fa-heart"></i></button>
                        </div>
                        <div class="product-info">
                            <div class="product-brand">Trendora</div>
                            <h3><%=product.getProductName()%></h3>
                            <div class="product-price">
                                <span class="discounted-price">₹<%=String.format("%.0f", product.getDiscountedPrice())%></span>
                                <% if(product.getDiscountPercent() > 0) { %>
                                    <span class="original-price">₹<%=String.format("%.0f", product.getPrice())%></span>
                                    <span class="save-tag">Save ₹<%=saving%></span>
                                <% } %>
                            </div>
                            <span class="btn-add-cart"><i class="fas fa-eye"></i> View Product</span>
                        </div>
                    </a>
                </div>
            <%
                    }
                }
            %>
        </div>
    </section>

    <!-- PROMO BANNERS -->
    <section class="promo-section">
        <div class="promo-card promo-card-1">
            <div class="promo-offer-tag">🔥 LIMITED OFFER</div>
            <h3>Men's Premium<br/>Collection 2026</h3>
            <p>Exclusive styles for the modern man.</p>
            <a href="${pageContext.request.contextPath}/products?categoryId=1" class="promo-btn">Shop Men's →</a>
            <img src="https://images.unsplash.com/photo-1617137968427-85924c800a22?w=300&q=80" class="promo-img" alt="Men"/>
        </div>
        <div class="promo-card promo-card-2">
            <div class="promo-offer-tag">✨ NEW ARRIVALS</div>
            <h3>Women's Trendy<br/>New Collection</h3>
            <p>Fresh styles for the modern woman.</p>
            <a href="${pageContext.request.contextPath}/products?categoryId=2" class="promo-btn">Shop Women's →</a>
            <img src="https://images.unsplash.com/photo-1581044777550-4cfa60707c03?w=300&q=80" class="promo-img" alt="Women"/>
        </div>
    </section>

    <!-- HOT DEALS -->
    <section class="deals-section">
        <div class="section-header">
            <div class="section-tag">HOT DEALS</div>
            <h2 class="section-title">🔥 Special <span>Offers</span></h2>
            <p class="section-subtitle">Limited time deals — grab them before they're gone!</p>
        </div>
        <div class="products-grid">
            <%
                List<Product> discountedProducts = (List<Product>) request.getAttribute("discountedProducts");
                if(discountedProducts != null) {
                    for(Product product : discountedProducts) {
                        String imgUrl = product.getImageUrl();
                        String imgSrc = (imgUrl != null && imgUrl.startsWith("http")) ? imgUrl :
                                        request.getContextPath() + "/images/" + imgUrl;
                        int saving = (int)(product.getPrice() - product.getDiscountedPrice());
            %>
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product-detail?productId=<%=product.getProductId()%>">
                        <div class="product-image">
                            <img src="<%=imgSrc%>" alt="<%=product.getProductName()%>"
                                 onerror="this.src='https://images.unsplash.com/photo-1483985988355-763728e1935b?w=400'"/>
                            <span class="discount-badge"><%=String.format("%.0f", product.getDiscountPercent())%>% OFF</span>
                            <button class="wishlist-btn"><i class="fas fa-heart"></i></button>
                        </div>
                        <div class="product-info">
                            <div class="product-brand">Trendora</div>
                            <h3><%=product.getProductName()%></h3>
                            <div class="product-price">
                                <span class="discounted-price">₹<%=String.format("%.0f", product.getDiscountedPrice())%></span>
                                <span class="original-price">₹<%=String.format("%.0f", product.getPrice())%></span>
                                <span class="save-tag">Save ₹<%=saving%></span>
                            </div>
                            <span class="btn-add-cart"><i class="fas fa-eye"></i> View Product</span>
                        </div>
                    </a>
                </div>
            <%
                    }
                }
            %>
        </div>
    </section>

    <!-- BRANDS -->
    <section class="brands-section">
        <div class="section-tag">TRUSTED BRANDS</div>
        <h2 class="section-title" style="margin-top:15px">Top <span>Fashion Brands</span></h2>
        <div class="brands-grid">
            <div class="brand-item">ZARA</div>
            <div class="brand-item">H&M</div>
            <div class="brand-item">LEVIS</div>
            <div class="brand-item">PUMA</div>
            <div class="brand-item">ADIDAS</div>
            <div class="brand-item">MANGO</div>
            <div class="brand-item">FABINDIA</div>
        </div>
    </section>

    <!-- NEWSLETTER -->
    <section class="newsletter-section">
        <h2>Subscribe & Get <span>Exclusive Offers</span></h2>
        <p>Join 50,000+ fashion lovers and get the latest trends delivered to your inbox!</p>
        <div class="newsletter-form">
            <input type="email" placeholder="Enter your email address..."/>
            <button type="button">Subscribe →</button>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-grid">
            <div class="footer-brand">
                <span class="logo-footer">Trendora</span>
                <p>Your ultimate fashion destination. We bring you the latest trends in clothing, accessories and footwear for Men, Women and Kids.</p>
                <div class="social-links">
                    <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="social-link"><i class="fab fa-pinterest"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <a href="${pageContext.request.contextPath}/home">Home</a>
                <a href="${pageContext.request.contextPath}/products">All Products</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a href="${pageContext.request.contextPath}/register">Register</a>
                <a href="${pageContext.request.contextPath}/cart">My Cart</a>
                <a href="${pageContext.request.contextPath}/orders">My Orders</a>
            </div>
            <div class="footer-col">
                <h4>Categories</h4>
                <%
                    if(categories != null) {
                        for(Category cat : categories) {
                %>
                    <a href="${pageContext.request.contextPath}/products?categoryId=<%=cat.getCategoryId()%>"><%=cat.getCategoryName()%></a>
                <%
                        }
                    }
                %>
            </div>
            <div class="footer-col">
                <h4>Customer Care</h4>
                <a href="#">FAQ</a>
                <a href="#">Shipping Policy</a>
                <a href="#">Return Policy</a>
                <a href="#">Track Order</a>
                <a href="#">Contact Us</a>
                <a href="#">Size Guide</a>
            </div>
        </div>
        <hr class="footer-divider"/>
        <div class="footer-bottom">
            <p>&copy; 2026 Trendora. All Rights Reserved. Made with ❤️ in India</p>
            <p>Privacy Policy | Terms of Service</p>
        </div>
    </footer>

    <script>
        function toggleMobileMenu() {
            var menu = document.getElementById('mobileMenu');
            menu.classList.toggle('active');
            document.body.style.overflow = menu.classList.contains('active') ? 'hidden' : 'auto';
        }

        function closeMobileMenu(event) {
            if(event.target === document.getElementById('mobileMenu')) {
                toggleMobileMenu();
            }
        }
    </script>

</body>
</html>