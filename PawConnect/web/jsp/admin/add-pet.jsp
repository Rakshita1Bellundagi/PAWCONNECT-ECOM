<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Category" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Add New Pet"/></jsp:include>
<% List<Category> categories = (List<Category>) request.getAttribute("categories"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1>+ Add New Pet</h1><a href="<%= ctx %>/admin/pets" class="btn btn-outline">&#8592; Back to Pets</a></div>
<div class="admin-form">
<h2>Pet Information</h2>
<form method="post" action="<%= ctx %>/admin/pets">
<input type="hidden" name="action" value="add">
<div class="form-row">
<div class="form-group"><label>Pet Name *</label><input type="text" name="petName" class="form-control" required></div>
<div class="form-group"><label>Category *</label><select name="categoryId" class="form-control" required><option value="">Select</option><% if(categories!=null){for(Category c:categories){ %><option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option><%}}%></select></div>
</div>
<div class="form-row">
<div class="form-group"><label>Breed *</label><input type="text" name="breed" class="form-control" required></div>
<div class="form-group"><label>Age *</label><input type="text" name="age" class="form-control" placeholder="e.g., 2 years" required></div>
</div>
<div class="form-row">
<div class="form-group"><label>Gender *</label><select name="gender" class="form-control" required><option value="Male">Male</option><option value="Female">Female</option></select></div>
<div class="form-group"><label>Color</label><input type="text" name="color" class="form-control"></div>
</div>
<div class="form-row">
<div class="form-group"><label>Weight (kg)</label><input type="number" step="0.01" name="weight" class="form-control"></div>
<div class="form-group"><label>Price (<i class="fa-solid fa-indian-rupee-sign"></i>) *</label><input type="number" step="0.01" name="price" class="form-control" required></div>
</div>
<div class="form-group"><label>Description *</label><textarea name="description" class="form-control" rows="4" required></textarea></div>
<div class="form-row">
<div class="form-group"><label>Health Status</label><input type="text" name="healthStatus" class="form-control" value="Excellent"></div>
<div class="form-group"><label>Vaccinated</label><select name="vaccinationStatus" class="form-control"><option value="true">Yes</option><option value="false">No</option></select></div>
</div>
<div class="form-row">
<div class="form-group"><label>Location *</label><input type="text" name="location" class="form-control" required></div>
<div class="form-group"><label>Primary Image URL</label><input type="text" name="imageUrl" class="form-control" value="default-pet.jpg"></div>
</div>
<div class="form-group"><label>Secondary Image URL</label><input type="text" name="imageUrl2" class="form-control"></div>

<h3 style="margin: 24px 0 16px; font-size: 1.2rem; border-bottom: 1px solid var(--border); padding-bottom: 8px;">Care Guide</h3>
<div class="form-group"><label>General Care Guide</label><textarea name="careGuide" class="form-control" rows="3" placeholder="How to take care of this pet..."></textarea></div>
<div class="form-row">
<div class="form-group"><label>Food Guide</label><textarea name="foodGuide" class="form-control" rows="2" placeholder="What to feed..."></textarea></div>
<div class="form-group"><label>Health Tips</label><textarea name="healthTips" class="form-control" rows="2" placeholder="Vaccinations, common issues..."></textarea></div>
</div>
<div class="form-row">
<div class="form-group"><label>Things to Do</label><textarea name="doList" class="form-control" rows="2" placeholder="Daily walks, grooming..."></textarea></div>
<div class="form-group"><label>Things to Avoid (Don'ts)</label><textarea name="dontList" class="form-control" rows="2" placeholder="Foods to avoid..."></textarea></div>
</div>
<button type="submit" class="btn btn-primary btn-lg">Add Pet</button>
</form>
</div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
