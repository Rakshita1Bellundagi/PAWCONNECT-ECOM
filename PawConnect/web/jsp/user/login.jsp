<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Login"/></jsp:include>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String email = (String) request.getAttribute("email");
    String ctx = request.getContextPath();
%>

<div class="auth-container">
    <div class="auth-card">
        <h2><i class="fa-solid fa-lock"></i> Welcome Back</h2>
        <p class="subtitle">Sign in to your Paw Connect account</p>

        <% if (error != null) { %>
            <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check" style="color:var(--success);"></i> <%= success %></div>
        <% } %>

        <form method="post" action="<%= ctx %>/login" data-validate="true">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" value="<%= email != null ? email : "" %>" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <div style="position: relative;">
                    <input type="password" id="login-password" name="password" class="form-control" placeholder="Enter your password" required>
                    <i class="fa-solid fa-eye" id="toggle-login-pwd" style="position: absolute; right: 15px; top: 15px; cursor: pointer; color: var(--text-light);" onclick="togglePassword()"></i>
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">Sign In <i class="fa-solid fa-arrow-right"></i></button>
        </form>

        <script>
            function togglePassword() {
                const input = document.getElementById('login-password');
                const icon = document.getElementById('toggle-login-pwd');
                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    input.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }
        </script>

        <div class="auth-footer">
            Don't have an account? <a href="<%= ctx %>/register">Register here</a>
        </div>

        <div style="text-align: center; margin-top: 16px;">
            <a href="<%= ctx %>/admin/login" style="color: var(--text-light); font-size: 0.8rem;">Admin Login <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    </div>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
