<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Pet" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Manage Pets"/></jsp:include>
<% List<Pet> pets = (List<Pet>) request.getAttribute("pets"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1><i class="fa-solid fa-dog"></i> Manage Pets</h1><div class="header-actions"><input type="text" id="adminSearch" class="form-control" placeholder="Search pets..." style="width:250px;"><a href="<%= ctx %>/admin/pets?action=add" class="btn btn-primary">+ Add New Pet</a></div></div>
<div class="admin-card"><div class="card-body">
<table><thead><tr><th>ID</th><th>Image</th><th>Name</th><th>Breed</th><th>Category</th><th>Price</th><th>Location</th><th>Status</th><th>Actions</th></tr></thead>
<tbody>
<% if (pets != null) { for (Pet pet : pets) { %>
<tr><td>#<%= pet.getPetId() %></td><td><img src="<%= ctx %>/images/pets/<%= pet.getImageUrl() %>" alt="<%= pet.getPetName() %>" style="width: 50px; height: 50px; border-radius: var(--radius-sm); object-fit: cover; display: block;" onerror="this.src='https://placehold.co/50x50?text=NA';"></td><td><strong><%= pet.getPetName() %></strong></td><td><%= pet.getBreed() %></td><td><%= pet.getCategoryName() %></td><td><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", pet.getPrice()) %></td><td><%= pet.getLocation() %></td>
<td><span class="badge-status <%= pet.isAvailable() ? "badge-success" : "badge-failed" %>"><%= pet.isAvailable() ? "Available" : "Sold" %></span></td>
<td><a href="<%= ctx %>/admin/pets?action=edit&id=<%= pet.getPetId() %>" class="btn btn-secondary btn-sm">Edit</a> <a href="<%= ctx %>/admin/pets?action=delete&id=<%= pet.getPetId() %>" class="btn btn-danger btn-sm delete-btn">Delete</a></td></tr>
<% } } %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
