<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.pawconnect.dao.DBConnection, com.pawconnect.dao.UserDAO, com.pawconnect.model.User, com.pawconnect.util.PasswordUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>PawConnect - Database Diagnostics & User Auth</title>
    <style>
        body { font-family: system-ui, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; margin: 0; }
        .card { background: #1e293b; border-radius: 12px; padding: 24px; max-width: 850px; margin: 0 auto; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h1 { color: #818cf8; margin-top: 0; font-size: 1.5rem; }
        h2 { margin-top: 24px; font-size: 1.2rem; color: #cbd5e1; border-bottom: 1px solid #334155; padding-bottom: 6px; }
        .badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-weight: bold; font-size: 0.85rem; }
        .success { background: #065f46; color: #6ee7b7; }
        .error { background: #7f1d1d; color: #fca5a5; }
        pre { background: #0f172a; padding: 12px; border-radius: 6px; overflow-x: auto; color: #f43f5e; font-size: 0.9rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 12px; font-size: 0.9rem; }
        th, td { text-align: left; padding: 8px 10px; border-bottom: 1px solid #334155; }
        th { color: #94a3b8; }
        code { background: #0f172a; padding: 2px 6px; border-radius: 4px; color: #38bdf8; font-size: 0.85rem; }
        .form-row { display: flex; gap: 10px; margin-top: 10px; }
        input[type="text"], input[type="password"] { padding: 8px 12px; border-radius: 6px; border: 1px solid #475569; background: #0f172a; color: #fff; flex: 1; }
        button { background: #6366f1; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: bold; }
        button:hover { background: #4f46e5; }
    </style>
</head>
<body>
<div class="card">
    <h1>PawConnect Database & Auth Diagnostics</h1>
    <%
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        boolean hasPassword = System.getenv("DB_PASSWORD") != null && !System.getenv("DB_PASSWORD").isEmpty();
    %>
    <table>
        <tr><th>Config</th><th>Value</th></tr>
        <tr><td>DB_URL</td><td><code><%= dbUrl != null ? dbUrl : "(Not set - using local default)" %></code></td></tr>
        <tr><td>DB_USER</td><td><code><%= dbUser != null ? dbUser : "(Not set - using local default)" %></code></td></tr>
        <tr><td>DB_PASSWORD</td><td><code><%= hasPassword ? "******** (Set)" : "(Not set)" %></code></td></tr>
    </table>

    <h2>Live Connection & Schema Diagnostics</h2>
    <%
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
    %>
            <p><span class="badge success">&#10004; CONNECTED TO DATABASE</span></p>
    <%
            Statement st = conn.createStatement();
            
            // Auto-repair missing columns in users table
            try {
                st.execute("ALTER TABLE users ADD COLUMN latitude DOUBLE");
                out.println("<p style='color:#38bdf8;'>Added missing 'latitude' column to users table.</p>");
            } catch (Exception ignored) {}
            try {
                st.execute("ALTER TABLE users ADD COLUMN longitude DOUBLE");
                out.println("<p style='color:#38bdf8;'>Added missing 'longitude' column to users table.</p>");
            } catch (Exception ignored) {}

            int catCount = 0;
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM categories")) {
                if (rs.next()) catCount = rs.getInt(1);
            } catch (Exception e) {
                out.println("<p style='color:#f87171'>categories: " + e.getMessage() + "</p>");
            }

            int petCount = 0;
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM pets")) {
                if (rs.next()) petCount = rs.getInt(1);
            } catch (Exception e) {
                out.println("<p style='color:#f87171'>pets: " + e.getMessage() + "</p>");
            }

            int userCount = 0;
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users")) {
                if (rs.next()) userCount = rs.getInt(1);
            } catch (Exception e) {
                out.println("<p style='color:#f87171'>users: " + e.getMessage() + "</p>");
            }
    %>
            <table>
                <tr><th>Table</th><th>Rows</th><th>Status</th></tr>
                <tr><td>categories</td><td><%= catCount %></td><td><%= catCount > 0 ? "<span style='color:#4ade80'>OK</span>" : "<span style='color:#f87171'>EMPTY</span>" %></td></tr>
                <tr><td>pets</td><td><%= petCount %></td><td><%= petCount > 0 ? "<span style='color:#4ade80'>OK</span>" : "<span style='color:#f87171'>EMPTY</span>" %></td></tr>
                <tr><td>users</td><td><%= userCount %></td><td><%= userCount > 0 ? "<span style='color:#4ade80'>OK</span>" : "<span style='color:#f87171'>EMPTY</span>" %></td></tr>
            </table>

            <h2>Users Table Columns</h2>
            <table>
                <tr><th>Column</th><th>Type</th><th>Nullable</th><th>Default</th></tr>
                <%
                    DatabaseMetaData meta = conn.getMetaData();
                    try (ResultSet cols = meta.getColumns(null, null, "users", "%")) {
                        while (cols.next()) {
                %>
                        <tr>
                            <td><code><%= cols.getString("COLUMN_NAME") %></code></td>
                            <td><%= cols.getString("TYPE_NAME") %></td>
                            <td><%= cols.getString("IS_NULLABLE") %></td>
                            <td><%= cols.getString("COLUMN_DEF") %></td>
                        </tr>
                <%
                        }
                    }
                %>
            </table>

            <h2>Registered Users (Latest 15)</h2>
            <table>
                <tr><th>ID</th><th>Email</th><th>Name</th><th>Active</th><th>Pwd Prefix</th><th>Created</th></tr>
                <%
                    try (ResultSet uRs = st.executeQuery("SELECT user_id, email, full_name, is_active, password, created_at FROM users ORDER BY user_id DESC LIMIT 15")) {
                        while (uRs.next()) {
                            String rawPwd = uRs.getString("password");
                            String pwdPrefix = rawPwd != null ? (rawPwd.length() > 8 ? rawPwd.substring(0, 8) + "..." : rawPwd) : "(null)";
                %>
                        <tr>
                            <td><%= uRs.getInt("user_id") %></td>
                            <td><code><%= uRs.getString("email") %></code></td>
                            <td><%= uRs.getString("full_name") %></td>
                            <td><%= uRs.getBoolean("is_active") ? "<span style='color:#4ade80'>Active</span>" : "<span style='color:#f87171'>Inactive</span>" %></td>
                            <td><code><%= pwdPrefix %></code></td>
                            <td><%= uRs.getTimestamp("created_at") %></td>
                        </tr>
                <%
                        }
                    }
                %>
            </table>

            <h2>Direct Auth Test & Quick Action</h2>
            <%
                String testAction = request.getParameter("action");
                String testEmail = request.getParameter("testEmail");
                String testPassword = request.getParameter("testPassword");

                if ("testLogin".equals(testAction) && testEmail != null && testPassword != null) {
                    UserDAO uDao = new UserDAO();
                    User u = uDao.login(testEmail, testPassword);
                    if (u != null) {
                        out.println("<p style='color:#4ade80; font-weight:bold;'>&#10004; Login SUCCESS for " + u.getEmail() + " (User ID: " + u.getUserId() + ", Name: " + u.getFullName() + ")</p>");
                    } else {
                        Boolean active = uDao.checkUserActiveStatus(testEmail);
                        out.println("<p style='color:#f87171; font-weight:bold;'>&#10008; Login FAILED for " + testEmail + ". Status in DB: " + (active == null ? "Not Found" : (active ? "Active" : "Inactive")) + "</p>");
                    }
                } else if ("quickRegister".equals(testAction) && testEmail != null && testPassword != null) {
                    UserDAO uDao = new UserDAO();
                    if (uDao.emailExists(testEmail)) {
                        out.println("<p style='color:#f59e0b;'>Email already exists. Updating password instead...</p>");
                        try (PreparedStatement up = conn.prepareStatement("UPDATE users SET password = ?, is_active = TRUE WHERE LOWER(email) = LOWER(?)")) {
                            up.setString(1, PasswordUtil.hashPassword(testPassword));
                            up.setString(2, testEmail.trim());
                            int count = up.executeUpdate();
                            out.println("<p style='color:#4ade80;'>Password reset for " + testEmail + ". Rows affected: " + count + "</p>");
                        }
                    } else {
                        User nu = new User();
                        nu.setFullName(request.getParameter("testName") != null ? request.getParameter("testName") : "Test User");
                        nu.setEmail(testEmail.trim());
                        nu.setPassword(testPassword);
                        boolean ok = uDao.register(nu);
                        out.println("<p style='color:" + (ok ? "#4ade80" : "#f87171") + "; font-weight:bold;'>" + (ok ? "&#10004; Registered: " + testEmail : "&#10008; Registration Failed") + "</p>");
                    }
                }
            %>

            <form method="post" action="test-db.jsp" style="margin-top: 16px;">
                <input type="hidden" name="action" value="testLogin">
                <div class="form-row">
                    <input type="text" name="testEmail" placeholder="Test Email (e.g. abc@gmail.com)" value="<%= testEmail != null ? testEmail : "abc@gmail.com" %>" required>
                    <input type="password" name="testPassword" placeholder="Test Password" required>
                    <button type="submit">Test Login</button>
                </div>
            </form>

            <form method="post" action="test-db.jsp" style="margin-top: 12px;">
                <input type="hidden" name="action" value="quickRegister">
                <div class="form-row">
                    <input type="text" name="testName" placeholder="Full Name" value="Test User">
                    <input type="text" name="testEmail" placeholder="Email" value="<%= testEmail != null ? testEmail : "abc@gmail.com" %>" required>
                    <input type="password" name="testPassword" placeholder="Password (sets or resets)" required>
                    <button type="submit" style="background:#10b981;">Register / Reset Pwd</button>
                </div>
            </form>
    <%
        } catch (Throwable t) {
    %>
            <p><span class="badge error">&#10008; CONNECTION FAILED</span></p>
            <pre><%= t.getClass().getName() %>: <%= t.getMessage() %></pre>
    <%
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ignored) {}
            }
        }
    %>
    <p style="margin-top: 24px;"><a href="<%= request.getContextPath() %>/login" style="color: #818cf8;">&larr; Go to Login</a> &nbsp;|&nbsp; <a href="<%= request.getContextPath() %>/register" style="color: #818cf8;">Go to Register</a></p>
</div>
</body>
</html>
