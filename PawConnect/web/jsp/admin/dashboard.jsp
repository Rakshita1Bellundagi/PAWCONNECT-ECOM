<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Dashboard"/></jsp:include>
<%
    int totalPets = (int) request.getAttribute("totalPets");
    int totalUsers = (int) request.getAttribute("totalUsers");
    int totalOrders = (int) request.getAttribute("totalOrders");
    double totalRevenue = (double) request.getAttribute("totalRevenue");
    List<Order> orders = (List<Order>) request.getAttribute("recentOrders");
    String ctx = request.getContextPath();
%>

<div class="admin-header">
    <h1><i class="fa-solid fa-chart-line"></i> Dashboard</h1>
    <div class="header-actions">
        <a href="<%= ctx %>/admin/pets?action=add" class="btn btn-primary">+ Add New Pet</a>
    </div>
</div>

<!-- Stats Cards -->
<div class="stats-grid">
    <div class="stat-card" data-aos="fade-up" data-aos-delay="0">
        <div class="stat-icon pets"><i class="fa-solid fa-dog"></i></div>
        <div class="stat-info"><h3>Total Pets</h3><div class="value"><%= totalPets %></div></div>
    </div>
    <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
        <div class="stat-icon users"><i class="fa-solid fa-users"></i></div>
        <div class="stat-info"><h3>Total Users</h3><div class="value"><%= totalUsers %></div></div>
    </div>
    <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
        <div class="stat-icon orders"><i class="fa-solid fa-box-open"></i></div>
        <div class="stat-info"><h3>Total Orders</h3><div class="value"><%= totalOrders %></div></div>
    </div>
    <div class="stat-card" data-aos="fade-up" data-aos-delay="300">
        <div class="stat-icon revenue"><i class="fa-solid fa-wallet"></i></div>
        <div class="stat-info"><h3>Total Revenue</h3><div class="value"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.0f", totalRevenue) %></div></div>
    </div>
</div>

<!-- Charts Section -->
<div class="admin-card" data-aos="fade-up" data-aos-delay="350" style="margin-bottom: 24px;">
    <div class="card-header">
        <h2>Revenue Overview (Last 6 Months)</h2>
    </div>
    <div class="card-body">
        <canvas id="revenueChart" style="width: 100%; height: 300px;"></canvas>
    </div>
</div>

<!-- Recent Orders -->
<div class="admin-card" data-aos="fade-up" data-aos-delay="400">
    <div class="card-header">
        <h2>Recent Orders</h2>
        <a href="<%= ctx %>/admin/orders" class="btn btn-outline btn-sm">View All</a>
    </div>
    <div class="card-body">
        <table>
            <thead><tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Status</th><th>Date</th><th>Action</th></tr></thead>
            <tbody>
            <% if (orders != null) { int count = 0; for (Order order : orders) { if (count++ >= 10) break;
                String sc = "badge-pending";
                if ("Confirmed".equals(order.getOrderStatus())) sc = "badge-confirmed";
                else if ("Shipped".equals(order.getOrderStatus())) sc = "badge-shipped";
                else if ("Delivered".equals(order.getOrderStatus())) sc = "badge-delivered";
                else if ("Cancelled".equals(order.getOrderStatus())) sc = "badge-cancelled";
            %>
            <tr>
                <td><strong>#<%= order.getOrderId() %></strong></td>
                <td><%= order.getUserName() %></td>
                <td><strong><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", order.getTotalAmount()) %></strong></td>
                <td><span class="badge-status <%= sc %>"><%= order.getOrderStatus() %></span></td>
                <td><%= order.getOrderDate() %></td>
                <td><a href="<%= ctx %>/admin/orders?action=view&id=<%= order.getOrderId() %>" class="btn btn-primary btn-sm">View</a></td>
            </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/jsp/common/admin-sidebar.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var ctxChart = document.getElementById('revenueChart').getContext('2d');
    
    // Data passed from servlet
    var labels = <%= request.getAttribute("monthLabels") != null ? request.getAttribute("monthLabels") : "[]" %>;
    var data = <%= request.getAttribute("monthlyRevenueData") != null ? request.getAttribute("monthlyRevenueData") : "[]" %>;
    
    var revenueChart = new Chart(ctxChart, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Monthly Revenue (\u20B9)',
                data: data,
                borderColor: '#4f46e5',
                backgroundColor: 'rgba(79, 70, 229, 0.1)',
                borderWidth: 3,
                pointBackgroundColor: '#ffffff',
                pointBorderColor: '#4f46e5',
                pointBorderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: { borderDash: [5, 5], color: 'rgba(0,0,0,0.05)' }
                },
                x: {
                    grid: { display: false }
                }
            }
        }
    });
});
</script>
