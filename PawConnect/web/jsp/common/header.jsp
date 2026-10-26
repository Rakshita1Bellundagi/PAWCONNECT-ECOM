<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.dao.CartDAO, com.pawconnect.dao.NotificationDAO" %>
<%
    String ctxPath = request.getContextPath();
    Integer sessionUserId = (Integer) session.getAttribute("userId");
    String sessionUserName = (String) session.getAttribute("userName");
    int cartCount = 0;
    int notifCount = 0;
    if (sessionUserId != null) {
        cartCount = new CartDAO().getCartCount(sessionUserId);
        notifCount = new NotificationDAO().getUnreadCount(sessionUserId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Paw Connect - Buy pets online with secure payment. Browse dogs, cats, birds, fish and more.">
    <title>Paw Connect - ${param.pageTitle != null ? param.pageTitle : 'Online Pet Store'}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctxPath %>/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a href="<%= ctxPath %>/" class="navbar-brand">
                <span class="paw-icon"><i class="fa-solid fa-paw"></i></span>
                <span>Paw Connect</span>
            </a>
            <button class="hamburger" id="hamburgerBtn" aria-label="Toggle menu">
                <span></span><span></span><span></span>
            </button>
            <ul class="navbar-nav" id="navbarNav">
                <li><a href="<%= ctxPath %>/"><i class="fa-solid fa-house"></i></a></li>
                <li><a href="<%= ctxPath %>/browse"><i class="fa-solid fa-magnifying-glass"></i> Browse</a></li>
                <% if (sessionUserId != null) { %>
                    <li>
                        <a href="<%= ctxPath %>/cart/"><i class="fa-solid fa-cart-shopping"></i> Cart
                            <% if (cartCount > 0) { %><span class="badge"><%= cartCount %></span><% } %>
                        </a>
                    </li>
                    <li><a href="<%= ctxPath %>/wishlist/"><i class="fa-solid fa-heart"></i> Wishlist</a></li>
                    <li><a href="<%= ctxPath %>/orders/"><i class="fa-solid fa-box-open"></i> Orders</a></li>
                    <li>
                        <a href="<%= ctxPath %>/notifications/"><i class="fa-solid fa-bell"></i> Alerts
                            <% if (notifCount > 0) { %><span class="badge"><%= notifCount %></span><% } %>
                        </a>
                    </li>
                    <li><a href="<%= ctxPath %>/user/profile"><i class="fa-solid fa-user"></i> <%= sessionUserName %></a></li>
                    <li><a href="<%= ctxPath %>/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
                <% } else { %>
                    <li><a href="<%= ctxPath %>/login" class="btn btn-primary btn-sm">Login</a></li>
                    <li><a href="<%= ctxPath %>/register" class="btn btn-outline btn-sm">Register</a></li>
                <% } %>
            </ul>
        </div>
    </nav>
