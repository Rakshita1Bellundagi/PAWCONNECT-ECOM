<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Category" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Manage Categories"/></jsp:include>
<% List<Category> categories = (List<Category>) request.getAttribute("categories"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1><i class="fa-solid fa-folder-open"></i> Manage Categories</h1></div>

<!-- Add Category Form -->
<div class="admin-form" style="margin-bottom: 24px;">
<h2>Add New Category</h2>
<form method="post" action="<%= ctx %>/admin/categories" style="display:flex; gap:12px; align-items:flex-end; flex-wrap:wrap;">
<input type="hidden" name="action" value="add">
<div class="form-group" style="flex:1; min-width:200px;"><label>Category Name *</label><input type="text" name="categoryName" class="form-control" required></div>
<div class="form-group" style="flex:2; min-width:200px;"><label>Description</label><input type="text" name="description" class="form-control"></div>
<div class="form-group" style="flex:1; min-width:150px;"><label>Image URL</label><input type="text" name="imageUrl" class="form-control"></div>
<div class="form-group" style="flex:0;"><label>&nbsp;</label><button type="submit" class="btn btn-primary">Add</button></div>
</form>
</div>

<div class="admin-card"><div class="card-body">
<table><thead><tr><th>ID</th><th>Name</th><th>Description</th><th>Pets</th><th>Actions</th></tr></thead>
<tbody>
<% if(categories!=null){for(Category c:categories){ %>
<tr><td>#<%= c.getCategoryId() %></td><td><strong><%= c.getCategoryName() %></strong></td><td><%= c.getDescription()!=null?c.getDescription():"-" %></td><td><%= c.getPetCount() %></td>
<td><form method="post" action="<%= ctx %>/admin/categories" style="display:inline;"><input type="hidden" name="action" value="delete"><input type="hidden" name="categoryId" value="<%= c.getCategoryId() %>"><button type="submit" class="btn btn-danger btn-sm delete-btn">Delete</button></form></td></tr>
<% }} %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
