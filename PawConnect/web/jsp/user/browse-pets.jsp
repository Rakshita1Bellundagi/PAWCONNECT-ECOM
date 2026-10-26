<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Pet, com.pawconnect.model.Category" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Browse Pets"/></jsp:include>
<%
    List<Pet> pets = (List<Pet>) request.getAttribute("pets");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<String> locations = (List<String>) request.getAttribute("locations");
    String keyword = (String) request.getAttribute("keyword");
    int selectedCategory = request.getAttribute("selectedCategory") != null ? (int) request.getAttribute("selectedCategory") : 0;
    String selectedLocation = (String) request.getAttribute("selectedLocation");
    String minPrice = (String) request.getAttribute("minPrice");
    String maxPrice = (String) request.getAttribute("maxPrice");
    String selectedGender = (String) request.getAttribute("selectedGender");
    String ctx = request.getContextPath();
%>

<div class="page-header">
    <div class="container">
        <h1><i class="fa-solid fa-dog"></i> Browse Our Pets</h1>
        <p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Browse Pets (<%= pets != null ? pets.size() : 0 %> found)</p>
    </div>
</div>

<div class="container">
    <!-- Search & Filter Bar -->
    <div class="search-bar" data-aos="fade-down" data-aos-duration="800">
        <form method="get" action="<%= ctx %>/browse">
            <div class="form-group" style="flex: 2;">
                <label>Search</label>
                <input type="text" name="keyword" class="form-control" placeholder="Search by name, breed..." value="<%= keyword != null ? keyword : "" %>">
            </div>
            <div class="form-group">
                <label>Category</label>
                <select name="category" class="form-control">
                    <option value="">All Categories</option>
                    <% if (categories != null) { for (Category cat : categories) { %>
                        <option value="<%= cat.getCategoryId() %>" <%= selectedCategory == cat.getCategoryId() ? "selected" : "" %>><%= cat.getCategoryName() %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label>Location</label>
                <select name="location" class="form-control">
                    <option value="">All Locations</option>
                    <% if (locations != null) { for (String loc : locations) { %>
                        <option value="<%= loc %>" <%= loc.equals(selectedLocation) ? "selected" : "" %>><%= loc %></option>
                    <% } } %>
                </select>
            </div>
            <div class="form-group">
                <label>Gender</label>
                <select name="gender" class="form-control">
                    <option value="">All</option>
                    <option value="Male" <%= "Male".equals(selectedGender) ? "selected" : "" %>>Male</option>
                    <option value="Female" <%= "Female".equals(selectedGender) ? "selected" : "" %>>Female</option>
                </select>
            </div>
            <div class="form-group">
                <label>Min Price (<i class="fa-solid fa-indian-rupee-sign"></i>)</label>
                <input type="number" name="minPrice" class="form-control" placeholder="0" value="<%= minPrice != null ? minPrice : "" %>">
            </div>
            <div class="form-group">
                <label>Max Price (<i class="fa-solid fa-indian-rupee-sign"></i>)</label>
                <input type="number" name="maxPrice" class="form-control" placeholder="99999" value="<%= maxPrice != null ? maxPrice : "" %>">
            </div>
            <div class="form-group" style="flex: 0;">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </div>
        </form>
    </div>

    <!-- Pet Grid -->
    <% if (pets != null && !pets.isEmpty()) { %>
        <div class="pet-grid">
            <% int delay = 0; for (Pet pet : pets) { %>
                <div class="card" data-aos="fade-up" data-aos-delay="<%= delay %>" data-tilt>
                    <img src="<%= ctx %>/images/pets/<%= pet.getImageUrl() %>" alt="<%= pet.getPetName() %>" class="card-img" onerror="this.src='https://placehold.co/400x300?text=No+Image';">
                    <div class="card-body">
                        <div class="card-title"><%= pet.getPetName() %></div>
                        <div class="card-text"><%= pet.getBreed() %> &bull; <%= pet.getAge() %> &bull; <%= pet.getGender() %></div>
                        <div class="card-text"><i class="fa-solid fa-location-dot"></i> <%= pet.getLocation() %> &bull; <%= pet.getCategoryName() %></div>
                        <div class="stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <span class="star <%= i <= pet.getAvgRating() ? "filled" : "" %>"><i class="fa-solid fa-star"></i></span>
                            <% } %>
                            <span style="color: #6C7A89; font-size: 0.8rem; margin-left: 4px;">(<%= pet.getReviewCount() %>)</span>
                        </div>
                        <div class="card-price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", pet.getPrice()) %></div>
                        <div style="display: flex; gap: 2px; margin-top: 4px;">
                            <% if (pet.isVaccinationStatus()) { %>
                                <span class="badge-status badge-success" style="font-size: 0.65rem;"><i class="fa-solid fa-circle-check" style="color:var(--success);"></i> Vaccinated</span>
                            <% } %>
                            <span class="badge-status badge-confirmed" style="font-size: 0.65rem;"><%= pet.getHealthStatus() %></span>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a href="<%= ctx %>/pet-details?id=<%= pet.getPetId() %>" class="btn btn-primary btn-sm" style="flex:1">View Details</a>
                        <form method="post" action="<%= ctx %>/cart/" style="flex:1">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                            <button type="submit" class="btn btn-outline btn-sm btn-block add-to-cart-btn"><i class="fa-solid fa-cart-shopping"></i> Add</button>
                        </form>
                    </div>
                </div>
            <% delay += 50; } %>
        </div>
    <% } else { %>
        <div class="empty-state" data-aos="zoom-in">
            <div class="icon"><i class="fa-solid fa-paw"></i></div>
            <h2>No Pets Found</h2>
            <p>Try adjusting your search filters or browse all pets.</p>
            <a href="<%= ctx %>/browse" class="btn btn-primary">Browse All Pets</a>
        </div>
    <% } %>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
