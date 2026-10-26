<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Payment" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Transactions"/></jsp:include>
<% List<Payment> payments = (List<Payment>) request.getAttribute("payments"); Double totalRevenue = (Double) request.getAttribute("totalRevenue"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1><i class="fa-solid fa-credit-card"></i> Transaction History</h1><div class="header-actions"><div class="stat-card" style="padding:12px 20px;"><div class="stat-info"><h3 style="font-size:0.7rem;">Total Revenue</h3><div class="value" style="font-size:1.3rem; color:#10B981;"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", totalRevenue) %></div></div></div><input type="text" id="adminSearch" class="form-control" placeholder="Search..." style="width:200px;"></div></div>
<div class="admin-card"><div class="card-body">
<table><thead><tr><th>Payment ID</th><th>Order</th><th>Customer</th><th>Amount</th><th>Method</th><th>Transaction ID</th><th>Status</th><th>Date</th></tr></thead>
<tbody>
<% if(payments!=null){for(Payment p:payments){ %>
<tr><td>#<%= p.getPaymentId() %></td><td><a href="<%= ctx %>/admin/orders?action=view&id=<%= p.getOrderId() %>">#<%= p.getOrderId() %></a></td><td><%= p.getUserName() %></td><td><strong><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f",p.getAmount()) %></strong></td><td><%= p.getPaymentMethod() %></td><td style="font-size:0.75rem;"><%= p.getTransactionId() %></td>
<td><span class="badge-status <%= "Success".equals(p.getPaymentStatus())?"badge-success":"Pending".equals(p.getPaymentStatus())?"badge-pending":"badge-failed" %>"><%= p.getPaymentStatus() %></span></td><td style="font-size:0.8rem;"><%= p.getPaymentDate() %></td></tr>
<% }} %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
