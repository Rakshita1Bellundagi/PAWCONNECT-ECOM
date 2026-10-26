<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Manage Orders"/></jsp:include>
<% List<Order> orders = (List<Order>) request.getAttribute("orders"); String ctx = request.getContextPath(); %>
<div class="admin-header">
    <h1><i class="fa-solid fa-box-open"></i> Manage Orders</h1>
    <div class="header-actions" style="display: flex; gap: 8px;">
        <input type="text" id="adminSearch" class="form-control" placeholder="Search orders..." style="width:250px;">
        <a href="<%= ctx %>/admin/export?type=orders" class="btn btn-primary" title="Download all orders as CSV"><i class="fa-solid fa-file-csv"></i> Export CSV</a>
    </div>
</div>
<div class="admin-card"><div class="card-body">
<table><thead><tr><th>Order ID</th><th>Customer</th><th>Email</th><th>Amount</th><th>Status</th><th>Date</th><th>Actions</th></tr></thead>
<tbody>
<% if(orders!=null){for(Order o:orders){
    String sc = "badge-pending";
    if("Confirmed".equals(o.getOrderStatus())) sc="badge-confirmed";
    else if("Shipped".equals(o.getOrderStatus())) sc="badge-shipped";
    else if("Delivered".equals(o.getOrderStatus())) sc="badge-delivered";
    else if("Cancelled".equals(o.getOrderStatus())) sc="badge-cancelled";
%>
<tr><td><strong>#<%= o.getOrderId() %></strong></td><td><%= o.getUserName() %></td><td><%= o.getUserEmail() %></td><td><strong><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", o.getTotalAmount()) %></strong></td>
<td><span class="badge-status <%= sc %>"><%= o.getOrderStatus() %></span></td><td><%= o.getOrderDate() %></td>
<td style="display:flex; gap:4px; align-items: center;">
<a href="<%= ctx %>/admin/orders?action=view&id=<%= o.getOrderId() %>" class="btn btn-primary btn-sm">View</a>
<form method="post" action="<%= ctx %>/admin/orders" style="display:flex; gap:4px;"><input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
<select name="status" class="form-control status-select" data-current="<%= o.getOrderStatus() %>" style="padding:4px 8px; font-size:0.75rem; min-width: auto;">
<option value="Pending" <%= "Pending".equals(o.getOrderStatus())?"selected":"" %>>Pending</option>
<option value="Confirmed" <%= "Confirmed".equals(o.getOrderStatus())?"selected":"" %>>Confirmed</option>
<option value="Shipped" <%= "Shipped".equals(o.getOrderStatus())?"selected":"" %>>Shipped</option>
<option value="Delivered" <%= "Delivered".equals(o.getOrderStatus())?"selected":"" %>>Delivered</option>
<option value="Cancelled" <%= "Cancelled".equals(o.getOrderStatus())?"selected":"" %>>Cancelled</option>
</select></form>
</td></tr>
<% }} %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
