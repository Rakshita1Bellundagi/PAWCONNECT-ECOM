<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.CartItem, com.pawconnect.model.User" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Checkout"/></jsp:include>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double cartTotal = (Double) request.getAttribute("cartTotal");
    User user = (User) request.getAttribute("user");
    String ctx = request.getContextPath();
%>

<div class="page-header">
    <div class="container">
        <h1><i class="fa-solid fa-credit-card"></i> Checkout</h1>
        <p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / <a href="<%= ctx %>/cart/">Cart</a> / Checkout</p>
    </div>
</div>

<div class="container">
    <div class="checkout-grid">
        <div>
            <form method="post" action="<%= ctx %>/payment/" data-validate="true">
                <input type="hidden" name="action" value="saveShipping">
                <div class="payment-form" style="max-width: unset;">
                    <h2 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 24px;"><i class="fa-solid fa-truck-fast"></i> Shipping Details</h2>
                    <div class="form-group" style="margin-bottom: 20px; min-width: unset; flex: unset;">
                        <label>Full Address *</label>
                        <textarea name="shippingAddress" class="form-control" rows="3" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                        <div class="form-group" style="min-width: unset; flex: unset;">
                            <label>City *</label>
                            <input type="text" name="shippingCity" class="form-control" value="<%= user.getCity() != null ? user.getCity() : "" %>" required>
                        </div>
                        <div class="form-group" style="min-width: unset; flex: unset;">
                            <label>State *</label>
                            <input type="text" name="shippingState" class="form-control" value="<%= user.getState() != null ? user.getState() : "" %>" required>
                        </div>
                        <div class="form-group" style="min-width: unset; flex: unset;">
                            <label>Pincode *</label>
                            <input type="text" name="shippingPincode" class="form-control" value="<%= user.getPincode() != null ? user.getPincode() : "" %>" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 16px;">Continue to Payment <i class="fa-solid fa-arrow-right"></i></button>
                </div>
            </form>
        </div>
        <div>
            <div class="cart-summary">
                <h3>Order Summary</h3>
                <% if (cartItems != null) { for (CartItem item : cartItems) { %>
                    <div class="summary-row">
                        <span><%= item.getPetName() %></span>
                        <span><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", item.getPrice()) %></span>
                    </div>
                <% } } %>
                <div class="total-row">
                    <span>Total</span>
                    <span style="color: var(--primary);"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", cartTotal) %></span>
                </div>
                <div style="margin-top: 16px; padding: 12px; background: #D1FAE5; border-radius: 8px; text-align: center; font-size: 0.85rem; color: #065F46;">
                    <i class="fa-solid fa-lock"></i> Secure checkout powered by Paw Connect
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
