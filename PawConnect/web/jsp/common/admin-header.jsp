<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminCtx = request.getContextPath();
    String adminName = (String) session.getAttribute("adminName");
    String adminRole = (String) session.getAttribute("adminRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - ${param.pageTitle != null ? param.pageTitle : 'Dashboard'} | Paw Connect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= adminCtx %>/css/style.css">
    <link rel="stylesheet" href="<%= adminCtx %>/css/admin.css">
</head>
<body>
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="brand">
                <span class="paw-icon"><i class="fa-solid fa-paw"></i></span>
                <span>Paw Connect</span>
            </div>
            <nav>
                <ul>
                    <li><a href="<%= adminCtx %>/admin/dashboard"><span class="icon"><i class="fa-solid fa-chart-line"></i></span> <span>Dashboard</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/pets"><span class="icon"><i class="fa-solid fa-dog"></i></span> <span>Manage Pets</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/users"><span class="icon"><i class="fa-solid fa-users"></i></span> <span>Manage Users</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/orders"><span class="icon"><i class="fa-solid fa-box-open"></i></span> <span>Manage Orders</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/categories"><span class="icon"><i class="fa-solid fa-folder-open"></i></span> <span>Categories</span></a></li>
                    <div class="sidebar-divider"></div>
                    <li><a href="<%= adminCtx %>/admin/transactions"><span class="icon"><i class="fa-solid fa-credit-card"></i></span> <span>Transactions</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/reviews"><span class="icon"><i class="fa-solid fa-star"></i></span> <span>Reviews</span></a></li>
                    <div class="sidebar-divider"></div>
                    <li><a href="<%= adminCtx %>/"><span class="icon"><i class="fa-solid fa-house"></i></span> <span>View Site</span></a></li>
                    <li><a href="<%= adminCtx %>/admin/logout"><span class="icon"><i class="fa-solid fa-right-from-bracket"></i></span> <span>Logout</span></a></li>
                </ul>
            </nav>
            <div class="admin-info">
                <div class="name"><%= adminName != null ? adminName : "Admin" %></div>
                <div class="role"><%= adminRole != null ? adminRole : "Administrator" %></div>
            </div>
        </aside>
        <main class="admin-content">
