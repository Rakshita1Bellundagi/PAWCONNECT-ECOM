<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Pet, com.pawconnect.model.Category" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Edit Pet"/></jsp:include>
<% Pet pet = (Pet) request.getAttribute("pet"); List<Category> categories = (List<Category>) request.getAttribute("categories"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1>&#9998; Edit Pet: <%= pet.getPetName() %></h1><a href="<%= ctx %>/admin/pets" class="btn btn-outline">&#8592; Back</a></div>
<div class="admin-form">
<form method="post" action="<%= ctx %>/admin/pets">
<input type="hidden" name="action" value="update"><input type="hidden" name="petId" value="<%= pet.getPetId() %>">
<div class="form-row">
<div class="form-group"><label>Pet Name *</label><input type="text" name="petName" class="form-control" value="<%= pet.getPetName() %>" required></div>
<div class="form-group"><label>Category *</label><select name="categoryId" class="form-control" required><% if(categories!=null){for(Category c:categories){ %><option value="<%= c.getCategoryId() %>" <%= c.getCategoryId()==pet.getCategoryId()?"selected":"" %>><%= c.getCategoryName() %></option><%}}%></select></div>
</div>
<div class="form-row">
<div class="form-group"><label>Breed</label><input type="text" name="breed" class="form-control" value="<%= pet.getBreed() %>"></div>
<div class="form-group"><label>Age</label><input type="text" name="age" class="form-control" value="<%= pet.getAge() %>"></div>
</div>
<div class="form-row">
<div class="form-group"><label>Gender</label><select name="gender" class="form-control"><option value="Male" <%= "Male".equals(pet.getGender())?"selected":"" %>>Male</option><option value="Female" <%= "Female".equals(pet.getGender())?"selected":"" %>>Female</option></select></div>
<div class="form-group"><label>Color</label><input type="text" name="color" class="form-control" value="<%= pet.getColor() %>"></div>
</div>
<div class="form-row">
<div class="form-group"><label>Weight (kg)</label><input type="number" step="0.01" name="weight" class="form-control" value="<%= pet.getWeight() %>"></div>
<div class="form-group"><label>Price (<i class="fa-solid fa-indian-rupee-sign"></i>)</label><input type="number" step="0.01" name="price" class="form-control" value="<%= pet.getPrice() %>"></div>
</div>
<div class="form-group"><label>Description</label><textarea name="description" class="form-control" rows="4"><%= pet.getDescription() %></textarea></div>
<div class="form-row">
<div class="form-group"><label>Health Status</label><input type="text" name="healthStatus" class="form-control" value="<%= pet.getHealthStatus() %>"></div>
<div class="form-group"><label>Vaccinated</label><select name="vaccinationStatus" class="form-control"><option value="true" <%= pet.isVaccinationStatus()?"selected":"" %>>Yes</option><option value="false" <%= !pet.isVaccinationStatus()?"selected":"" %>>No</option></select></div>
</div>
<div class="form-row">
<div class="form-group"><label>Location</label><input type="text" name="location" class="form-control" value="<%= pet.getLocation() %>"></div>
<div class="form-group"><label>Available</label><select name="isAvailable" class="form-control"><option value="true" <%= pet.isAvailable()?"selected":"" %>>Yes</option><option value="false" <%= !pet.isAvailable()?"selected":"" %>>No (Sold)</option></select></div>
</div>
<div class="form-row">
<div class="form-group"><label>Primary Image URL</label><input type="text" name="imageUrl" class="form-control" value="<%= pet.getImageUrl() != null ? pet.getImageUrl() : "" %>"></div>
<div class="form-group"><label>Secondary Image URL</label><input type="text" name="imageUrl2" class="form-control" value="<%= pet.getImageUrl2() != null ? pet.getImageUrl2() : "" %>"></div>
</div>

<h3 style="margin: 24px 0 16px; font-size: 1.2rem; border-bottom: 1px solid var(--border); padding-bottom: 8px;">Care Guide</h3>
<div class="form-group"><label>General Care Guide</label><textarea name="careGuide" class="form-control" rows="3"><%= pet.getCareGuide() != null ? pet.getCareGuide() : "" %></textarea></div>
<div class="form-row">
<div class="form-group"><label>Food Guide</label><textarea name="foodGuide" class="form-control" rows="2"><%= pet.getFoodGuide() != null ? pet.getFoodGuide() : "" %></textarea></div>
<div class="form-group"><label>Health Tips</label><textarea name="healthTips" class="form-control" rows="2"><%= pet.getHealthTips() != null ? pet.getHealthTips() : "" %></textarea></div>
</div>
<div class="form-row">
<div class="form-group"><label>Things to Do</label><textarea name="doList" class="form-control" rows="2"><%= pet.getDoList() != null ? pet.getDoList() : "" %></textarea></div>
<div class="form-group"><label>Things to Avoid (Don'ts)</label><textarea name="dontList" class="form-control" rows="2"><%= pet.getDontList() != null ? pet.getDontList() : "" %></textarea></div>
</div>
<button type="submit" class="btn btn-primary btn-lg">Update Pet</button>
</form>
</div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
