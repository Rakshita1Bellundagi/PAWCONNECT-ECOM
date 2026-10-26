<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order, com.pawconnect.model.OrderItem, com.pawconnect.model.Payment" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Order Details"/></jsp:include>
<%
    Order order = (Order) request.getAttribute("order");
    Payment payment = order != null ? order.getPayment() : null;
    String ctx = request.getContextPath();
%>
<div class="page-header"><div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
        <div>
            <h1><i class="fa-solid fa-box-open"></i> Order #<%= order != null ? order.getOrderId() : "" %></h1>
            <p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / <a href="<%= ctx %>/orders/">Orders</a> / #<%= order != null ? order.getOrderId() : "" %></p>
        </div>
        <% if (payment != null && "Completed".equals(payment.getPaymentStatus())) { %>
            <button onclick="generateBillPDF()" class="btn btn-primary"><i class="fa-solid fa-file-pdf"></i> Download Official Bill</button>
        <% } %>
    </div>
</div></div>
<div class="container">
<% if (order != null) { %>
<div class="checkout-grid">
<div>
<div class="payment-form" style="max-width: unset; margin-bottom: 24px;">
<h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 16px;">Order Items</h2>
<% if (order.getOrderItems() != null) { for (OrderItem item : order.getOrderItems()) { %>
<div class="cart-item" style="box-shadow: none; border: 1px solid var(--border);">
    <img src="<%= ctx %>/images/pets/<%= item.getImageUrl() %>" alt="<%= item.getPetName() %>" class="item-image" style="width: 60px; height: 60px; border-radius: var(--radius-sm); object-fit: cover; display: block;" onerror="this.src='https://placehold.co/100x100?text=No+Image';">
    <div class="item-info"><h3 style="font-size: 0.9rem;"><%= item.getPetName() %></h3></div>
    <div class="item-price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", item.getPrice()) %></div>
</div>
<% } } %>
</div>
<% if (payment != null) { %>
<div class="payment-form" style="max-width: unset;">
<h2 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 16px;"><i class="fa-solid fa-credit-card"></i> Payment Details</h2>
<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
<div class="info-item" style="padding: 12px; background: var(--bg-secondary); border-radius: 8px;"><div class="label" style="font-size: 0.75rem; color: var(--text-light);">Transaction ID</div><div class="value" style="font-weight: 600;"><%= payment.getTransactionId() %></div></div>
<div class="info-item" style="padding: 12px; background: var(--bg-secondary); border-radius: 8px;"><div class="label" style="font-size: 0.75rem; color: var(--text-light);">Method</div><div class="value" style="font-weight: 600;"><%= payment.getPaymentMethod() %></div></div>
<div class="info-item" style="padding: 12px; background: var(--bg-secondary); border-radius: 8px;"><div class="label" style="font-size: 0.75rem; color: var(--text-light);">Status</div><div class="value"><span class="badge-status badge-success"><%= payment.getPaymentStatus() %></span></div></div>
<div class="info-item" style="padding: 12px; background: var(--bg-secondary); border-radius: 8px;"><div class="label" style="font-size: 0.75rem; color: var(--text-light);">Date</div><div class="value" style="font-weight: 600;"><%= payment.getPaymentDate() %></div></div>
</div>
</div>
<% } %>
</div>
<div>
<div class="cart-summary">
<h3>Order Summary</h3>
<div class="summary-row"><span>Order ID</span><strong>#<%= order.getOrderId() %></strong></div>
<div class="summary-row"><span>Date</span><span><%= order.getOrderDate() %></span></div>
<div class="summary-row"><span>Status</span><span class="badge-status badge-confirmed"><%= order.getOrderStatus() %></span></div>
<div class="summary-row"><span>Shipping</span><span><%= order.getShippingAddress() %>, <%= order.getShippingCity() %></span></div>
<div class="total-row"><span>Total</span><span style="color: var(--primary);"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", order.getTotalAmount()) %></span></div>
</div>
</div>
</div>
<% } %>
</div>
<% if(payment != null && "Completed".equals(payment.getPaymentStatus())) { %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script>
    function generateBillPDF() {
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        
        const orderId = '<%= order.getOrderId() %>';
        const txnId = '<%= payment != null ? payment.getTransactionId() : "N/A" %>';
        const method = '<%= payment != null ? payment.getPaymentMethod() : "N/A" %>';
        const amount = '<%= payment != null ? String.format("%,.2f", payment.getAmount()) : "0.00" %>';
        const date = '<%= payment != null ? payment.getPaymentDate() : "N/A" %>';
        const customerName = '<%= order.getUserName() %>';
        const customerEmail = '<%= order.getUserEmail() %>';
        
        const primary = [99, 102, 241];
        const dark = [15, 23, 42];
        const gray = [100, 116, 139];
        const lightGray = [241, 245, 249];
        
        doc.setFillColor(...primary);
        doc.rect(0, 0, 210, 50, 'F');
        
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(24);
        doc.setFont('helvetica', 'bold');
        doc.text('PAW CONNECT', 20, 25);
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text('Online Pet Purchase & Payment System', 20, 33);
        doc.text('www.pawconnect.com | support@pawconnect.com', 20, 40);
        
        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.text('INVOICE', 160, 25);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'normal');
        doc.text('#INV-' + orderId, 160, 33);
        
        let y = 62;
        doc.setTextColor(...dark);
        doc.setFontSize(11);
        doc.setFont('helvetica', 'bold');
        doc.text('BILL TO:', 20, y);
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(10);
        doc.setTextColor(...gray);
        y += 8;
        doc.text(customerName, 20, y);
        y += 6;
        doc.text(customerEmail, 20, y);
        
        doc.setTextColor(...dark);
        doc.setFontSize(10);
        doc.setFont('helvetica', 'bold');
        doc.text('Invoice Date:', 120, 62);
        doc.text('Order ID:', 120, 70);
        doc.text('Transaction ID:', 120, 78);
        doc.text('Payment Method:', 120, 86);
        doc.setFont('helvetica', 'normal');
        doc.setTextColor(...gray);
        doc.text(date, 165, 62);
        doc.text('#' + orderId, 165, 70);
        doc.text(txnId, 165, 78);
        doc.text(method, 165, 86);
        
        y = 100;
        doc.setDrawColor(226, 232, 240);
        doc.setLineWidth(0.5);
        doc.line(20, y, 190, y);
        
        y += 10;
        doc.setFillColor(...lightGray);
        doc.rect(20, y - 6, 170, 10, 'F');
        doc.setTextColor(...dark);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.text('DESCRIPTION', 25, y);
        doc.text('AMOUNT', 165, y, { align: 'right' });
        
        y += 12;
        doc.setFont('helvetica', 'normal');
        doc.setTextColor(...gray);
        doc.text('Pet Purchase - Order #' + orderId, 25, y);
        doc.setTextColor(...dark);
        doc.setFont('helvetica', 'bold');
        doc.text('Rs. ' + amount, 165, y, { align: 'right' });
        
        y += 20;
        doc.setDrawColor(226, 232, 240);
        doc.line(120, y, 190, y);
        y += 10;
        doc.setFont('helvetica', 'normal');
        doc.setTextColor(...gray);
        doc.setFontSize(9);
        doc.text('Subtotal:', 120, y);
        doc.setTextColor(...dark);
        doc.text('Rs. ' + amount, 185, y, { align: 'right' });
        
        y += 8;
        doc.setTextColor(...gray);
        doc.text('Tax (0%):', 120, y);
        doc.setTextColor(...dark);
        doc.text('Rs. 0.00', 185, y, { align: 'right' });
        
        y += 8;
        doc.setTextColor(...gray);
        doc.text('Delivery:', 120, y);
        doc.setTextColor(...dark);
        doc.text('FREE', 185, y, { align: 'right' });
        
        y += 4;
        doc.setDrawColor(...primary);
        doc.setLineWidth(1);
        doc.line(120, y, 190, y);
        y += 10;
        doc.setFillColor(...primary);
        doc.rect(118, y - 7, 74, 12, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(11);
        doc.setFont('helvetica', 'bold');
        doc.text('TOTAL: Rs. ' + amount, 155, y, { align: 'center' });
        
        y += 20;
        doc.setFillColor(16, 185, 129);
        doc.roundedRect(20, y - 5, 50, 12, 3, 3, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.text('PAID', 45, y + 2, { align: 'center' });
        
        y += 30;
        doc.setTextColor(...dark);
        doc.setFontSize(10);
        doc.setFont('helvetica', 'italic');
        doc.text('Paw Connect', 150, y);
        doc.setDrawColor(...primary);
        doc.setLineWidth(0.5);
        doc.line(130, y + 3, 190, y + 3);
        doc.setFont('helvetica', 'normal');
        doc.setFontSize(8);
        doc.setTextColor(...gray);
        doc.text('Authorized Digital Signature', 150, y + 10);
        
        y = 270;
        doc.setDrawColor(226, 232, 240);
        doc.line(20, y, 190, y);
        y += 6;
        doc.setFontSize(7);
        doc.setTextColor(...gray);
        doc.text('This is a computer-generated invoice and does not require a physical signature.', 105, y, { align: 'center' });
        y += 5;
        doc.text('Paw Connect | Hubballi, Karnataka, India - 580031 | support@pawconnect.com | +91 98765 43210', 105, y, { align: 'center' });
        
        doc.save('PawConnect_Invoice_' + orderId + '.pdf');
    }
</script>
<% } %>
<jsp:include page="/jsp/common/footer.jsp"/>
