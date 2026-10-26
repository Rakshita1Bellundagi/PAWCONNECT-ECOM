<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.pawconnect.dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>PawConnect - Database Diagnostics</title>
    <style>
        body { font-family: system-ui, sans-serif; background: #0f172a; color: #f8fafc; padding: 40px; }
        .card { background: #1e293b; border-radius: 12px; padding: 24px; max-width: 700px; margin: 0 auto; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h1 { color: #818cf8; margin-top: 0; font-size: 1.5rem; }
        .badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-weight: bold; font-size: 0.85rem; }
        .success { background: #065f46; color: #6ee7b7; }
        .error { background: #7f1d1d; color: #fca5a5; }
        pre { background: #0f172a; padding: 12px; border-radius: 6px; overflow-x: auto; color: #f43f5e; font-size: 0.9rem; }
        table { width: 100%; border-collapse: collapse; margin-top: 16px; }
        th, td { text-align: left; padding: 10px; border-bottom: 1px solid #334155; }
        th { color: #94a3b8; }
        code { background: #0f172a; padding: 2px 6px; border-radius: 4px; color: #38bdf8; font-size: 0.85rem; }
    </style>
</head>
<body>
<div class="card">
    <h1>PawConnect Database Diagnostics</h1>
    <%
        String dbUrl = System.getenv("DB_URL");
        String dbUser = System.getenv("DB_USER");
        boolean hasPassword = System.getenv("DB_PASSWORD") != null && !System.getenv("DB_PASSWORD").isEmpty();
    %>
    <table>
        <tr><th>Environment Variable</th><th>Configured Value</th></tr>
        <tr><td>DB_URL</td><td><code><%= dbUrl != null ? dbUrl : "(Not set - using local default)" %></code></td></tr>
        <tr><td>DB_USER</td><td><code><%= dbUser != null ? dbUser : "(Not set - using local default)" %></code></td></tr>
        <tr><td>DB_PASSWORD</td><td><code><%= hasPassword ? "******** (Set)" : "(Not set)" %></code></td></tr>
    </table>

    <h2 style="margin-top: 24px; font-size: 1.2rem;">Live Connection Test</h2>
    <%
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
    %>
            <p><span class="badge success">&#10004; CONNECTED TO DATABASE</span></p>
    <%
            Statement st = conn.createStatement();
            int catCount = 0;
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM categories")) {
                if (rs.next()) catCount = rs.getInt(1);
            } catch (Exception e) {
                out.println("<p style='color:#f87171'>categories table: " + e.getMessage() + "</p>");
            }

            int petCount = 0;
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM pets")) {
                if (rs.next()) petCount = rs.getInt(1);
            } catch (Exception e) {
                out.println("<p style='color:#f87171'>pets table: " + e.getMessage() + "</p>");
            }
    %>
            <table>
                <tr><th>Table</th><th>Rows</th><th>Status</th></tr>
                <tr><td>categories</td><td><%= catCount %></td><td><%= catCount > 0 ? "<span style='color:#4ade80'>OK</span>" : "<span style='color:#f87171'>EMPTY (pawconnect_db.sql needs to be executed)</span>" %></td></tr>
                <tr><td>pets</td><td><%= petCount %></td><td><%= petCount > 0 ? "<span style='color:#4ade80'>OK</span>" : "<span style='color:#f87171'>EMPTY (pawconnect_db.sql needs to be executed)</span>" %></td></tr>
            </table>
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
    <p style="margin-top: 24px;"><a href="<%= request.getContextPath() %>/browse" style="color: #818cf8;">&larr; Back to Browse Pets</a></p>
</div>
</body>
</html>
