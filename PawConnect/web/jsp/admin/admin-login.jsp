<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctx = request.getContextPath(); String error = (String) request.getAttribute("error"); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | Paw Connect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/style.css">
    <link rel="stylesheet" href="<%= ctx %>/css/admin.css">
</head>
<body>
<div class="admin-login-page">
    <div class="admin-login-card">
        <h2><i class="fa-solid fa-lock"></i> Admin Login</h2>
        <p class="subtitle">Paw Connect Administration Panel</p>
        <% if (error != null) { %><div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div><% } %>
        <form method="post" action="<%= ctx %>/admin/login">
            <div class="form-group" style="margin-bottom: 20px; min-width: unset; flex: unset;"><label>Username</label><input type="text" name="username" class="form-control" placeholder="Enter username" required></div>
            <div class="form-group" style="margin-bottom: 20px; min-width: unset; flex: unset;"><label>Password</label><input type="password" name="password" class="form-control" placeholder="Enter password" required></div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">Sign In</button>
        </form>
        <div style="text-align: center; margin-top: 24px;"><a href="<%= ctx %>/" style="color: var(--text-light); font-size: 0.85rem;">&#8592; Back to Website</a></div>
    </div>
</div>
</body></html>
