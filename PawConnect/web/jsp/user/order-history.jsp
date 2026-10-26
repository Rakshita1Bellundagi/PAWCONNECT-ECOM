<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="My Orders"/></jsp:include>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String ctx = request.getContextPath();
%>
<div class="page-header"><div class="container"><h1><i class="fa-solid fa-box-open"></i> My Orders</h1><p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Orders</p></div></div>
<div class="container">
<% if (orders != null && !orders.isEmpty()) { %>
<div class="table-container" data-aos="fade-up" style="background: var(--bg-card); padding: 24px; border-radius: var(--radius); box-shadow: var(--shadow);">
<table>
<thead><tr><th>Order ID</th><th>Date</th><th>Amount</th><th>Status</th><th>Action</th></tr></thead>
<tbody>
<% for (Order order : orders) {
    String statusClass = "badge-pending";
    if ("Confirmed".equals(order.getOrderStatus())) statusClass = "badge-confirmed";
    else if ("Shipped".equals(order.getOrderStatus())) statusClass = "badge-shipped";
    else if ("Delivered".equals(order.getOrderStatus())) statusClass = "badge-delivered";
    else if ("Cancelled".equals(order.getOrderStatus())) statusClass = "badge-cancelled";
%>
<tr>
    <td><strong>#<%= order.getOrderId() %></strong></td>
    <td><%= order.getOrderDate() %></td>
    <td><strong><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", order.getTotalAmount()) %></strong></td>
    <td><span class="badge-status <%= statusClass %>"><%= order.getOrderStatus() %></span></td>
    <td><a href="<%= ctx %>/orders/<%= order.getOrderId() %>" class="btn btn-primary btn-sm">View Details</a></td>
</tr>
<% } %>
</tbody>
</table>
</div>
<% } else { %>
<div class="empty-state"><div class="icon"><i class="fa-solid fa-box-open"></i></div><h2>No Orders Yet</h2><p>Start shopping to see your orders here!</p><a href="<%= ctx %>/browse" class="btn btn-primary">Browse Pets</a></div>
<% } %>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
