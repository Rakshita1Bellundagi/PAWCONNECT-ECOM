<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.User" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Manage Users"/></jsp:include>
<% List<User> users = (List<User>) request.getAttribute("users"); String ctx = request.getContextPath(); %>
<div class="admin-header">
    <h1><i class="fa-solid fa-users"></i> Manage Users</h1>
    <div class="header-actions" style="display: flex; gap: 8px;">
        <input type="text" id="adminSearch" class="form-control" placeholder="Search users..." style="width:250px;">
        <a href="<%= ctx %>/admin/export?type=users" class="btn btn-primary" title="Download all users as CSV"><i class="fa-solid fa-file-csv"></i> Export CSV</a>
    </div>
</div>
<div class="admin-card"><div class="card-body">
<table><thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>City</th><th>Status</th><th>Joined</th><th>Action</th></tr></thead>
<tbody>
<% if(users!=null){for(User u:users){ %>
<tr><td>#<%= u.getUserId() %></td><td><strong><%= u.getFullName() %></strong></td><td><%= u.getEmail() %></td><td><%= u.getPhone()!=null?u.getPhone():"-" %></td><td><%= u.getCity()!=null?u.getCity():"-" %></td>
<td><span class="badge-status <%= u.isActive()?"badge-success":"badge-failed" %>"><%= u.isActive()?"Active":"Inactive" %></span></td>
<td><%= u.getCreatedAt() %></td>
<td><form method="post" action="<%= ctx %>/admin/users" style="display:inline;"><input type="hidden" name="action" value="toggleStatus"><input type="hidden" name="userId" value="<%= u.getUserId() %>"><input type="hidden" name="isActive" value="<%= u.isActive() %>"><button type="submit" class="btn btn-sm toggle-status-btn <%= u.isActive()?"btn-danger":"btn-success" %>" data-active="<%= u.isActive() %>"><%= u.isActive()?"Deactivate":"Activate" %></button></form></td></tr>
<% }} %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
