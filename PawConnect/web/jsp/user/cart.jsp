<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.CartItem" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Shopping Cart"/></jsp:include>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    String ctx = request.getContextPath();
%>

<div class="page-header">
    <div class="container">
        <h1><i class="fa-solid fa-cart-shopping"></i> Shopping Cart</h1>
        <p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Cart (<%= cartItems != null ? cartItems.size() : 0 %> items)</p>
    </div>
</div>

<div class="container">
    <% if (cartItems != null && !cartItems.isEmpty()) { %>
        <div class="checkout-grid">
            <div>
                <% for (CartItem item : cartItems) { %>
                    <div class="cart-item">
                        <img src="<%= ctx %>/images/pets/<%= item.getImageUrl() %>" alt="<%= item.getPetName() %>" class="item-image" onerror="this.src='https://placehold.co/100x100?text=No+Image';">
                        <div class="item-info">
                            <h3><%= item.getPetName() %></h3>
                            <p><%= item.getBreed() %> &bull; <%= item.getCategoryName() %></p>
                        </div>
                        <div class="item-price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", item.getPrice()) %></div>
                        <form method="post" action="<%= ctx %>/cart/">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                            <button type="submit" class="btn btn-danger btn-sm" data-confirm="Remove this item from cart?"><i class="fa-solid fa-xmark"></i></button>
                        </form>
                    </div>
                <% } %>
            </div>
            <div>
                <div class="cart-summary">
                    <h3>Order Summary</h3>
                    <% for (CartItem item : cartItems) { %>
                        <div class="summary-row">
                            <span><%= item.getPetName() %></span>
                            <span><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", item.getPrice()) %></span>
                        </div>
                    <% } %>
                    <div class="total-row">
                        <span>Total</span>
                        <span style="color: var(--primary);"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", cartTotal) %></span>
                    </div>
                    <div style="margin-top: 20px;">
                        <a href="<%= ctx %>/checkout/" class="btn btn-primary btn-block btn-lg">Proceed to Checkout <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                    <div style="margin-top: 12px;">
                        <a href="<%= ctx %>/browse" class="btn btn-outline btn-block btn-sm">Continue Shopping</a>
                    </div>
                    <div style="margin-top: 12px;">
                        <form method="post" action="<%= ctx %>/cart/">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-danger btn-block btn-sm" data-confirm="Clear entire cart?">Clear Cart</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="empty-state">
            <div class="icon"><i class="fa-solid fa-cart-shopping"></i></div>
            <h2>Your Cart is Empty</h2>
            <p>Start browsing our amazing collection of pets!</p>
            <a href="<%= ctx %>/browse" class="btn btn-primary btn-lg">Browse Pets</a>
        </div>
    <% } %>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
