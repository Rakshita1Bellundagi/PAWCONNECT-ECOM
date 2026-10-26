<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.WishlistItem" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="My Wishlist"/></jsp:include>
<%
    List<WishlistItem> items = (List<WishlistItem>) request.getAttribute("wishlistItems");
    String ctx = request.getContextPath();
%>
<div class="page-header"><div class="container"><h1><i class="fa-solid fa-heart" style="color:var(--danger);"></i> My Wishlist</h1><p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Wishlist (<%= items != null ? items.size() : 0 %> items)</p></div></div>
<div class="container">
<% if (items != null && !items.isEmpty()) { %>
<div class="pet-grid">
<% for (WishlistItem item : items) { %>
<div class="card" data-aos="fade-up" data-tilt data-tilt-max="3" data-tilt-speed="400" data-tilt-glare="true" data-tilt-max-glare="0.2">
    <img src="<%= ctx %>/images/pets/<%= item.getImageUrl() %>" alt="<%= item.getPetName() %>" class="card-img" onerror="this.src='https://placehold.co/400x300?text=No+Image';">
    <div class="card-body">
        <div class="card-title"><%= item.getPetName() %></div>
        <div class="card-text"><%= item.getBreed() %> &bull; <%= item.getCategoryName() %></div>
        <div class="card-price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", item.getPrice()) %></div>
        <% if (!item.isAvailable()) { %><span class="badge-status badge-failed">Sold Out</span><% } %>
    </div>
    <div class="card-footer">
        <a href="<%= ctx %>/pet-details?id=<%= item.getPetId() %>" class="btn btn-primary btn-sm" style="flex:1">View</a>
        <% if (item.isAvailable()) { %>
        <form method="post" action="<%= ctx %>/cart/" style="flex:1"><input type="hidden" name="action" value="add"><input type="hidden" name="petId" value="<%= item.getPetId() %>"><button type="submit" class="btn btn-success btn-sm btn-block"><i class="fa-solid fa-cart-shopping"></i> Buy</button></form>
        <% } %>
        <form method="post" action="<%= ctx %>/wishlist/"><input type="hidden" name="action" value="remove"><input type="hidden" name="wishlistId" value="<%= item.getWishlistId() %>"><button type="submit" class="btn btn-danger btn-sm"><i class="fa-solid fa-xmark"></i></button></form>
    </div>
</div>
<% } %>
</div>
<% } else { %>
<div class="empty-state"><div class="icon"><i class="fa-solid fa-heart" style="color:var(--danger);"></i></div><h2>Wishlist is Empty</h2><p>Save pets you like for later!</p><a href="<%= ctx %>/browse" class="btn btn-primary">Browse Pets</a></div>
<% } %>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
