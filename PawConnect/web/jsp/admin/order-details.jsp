<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order, com.pawconnect.model.OrderItem, com.pawconnect.model.Payment, com.pawconnect.model.User" %>
<%@ page import="com.pawconnect.dao.UserDAO" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Order Details"/></jsp:include>
<% 
    Order order = (Order) request.getAttribute("order"); 
    Payment payment = order != null ? order.getPayment() : null; 
    String ctx = request.getContextPath(); 
    
    // Fetch User for phone number
    User customer = null;
    if (order != null) {
        customer = new UserDAO().getUserById(order.getUserId());
    }
    String customerPhone = (customer != null && customer.getPhone() != null) ? customer.getPhone() : "";
%>
<!-- jsPDF for PDF bill generation -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<div class="admin-header">
    <h1>Order #<%= order!=null?order.getOrderId():"" %></h1>
    <div class="header-actions">
        <a href="<%= ctx %>/admin/orders" class="btn btn-outline">&#8592; Back</a>
        <% if(payment != null && "Completed".equals(payment.getPaymentStatus())) { %>
            <div style="display: flex; gap: 8px;">
                <button onclick="generateBillPDF()" class="btn btn-primary"><i class="fa-solid fa-file-pdf"></i> Download Bill</button>
                <a href="#" onclick="shareWhatsApp()" class="btn" style="background: #25D366; color: white;"><i class="fa-brands fa-whatsapp"></i> Share Bill via WhatsApp</a>
                <form method="post" action="<%= ctx %>/admin/orders" style="margin: 0;">
                    <input type="hidden" name="action" value="sendBillAlert">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <input type="hidden" name="userId" value="<%= order.getUserId() %>">
                    <button type="submit" class="btn btn-outline" title="Send an alert to the user's PawConnect Notifications"><i class="fa-solid fa-bell"></i> App Alert</button>
                </form>
            </div>
        <% } %>
    </div>
</div>

<% if(order!=null){ %>
<div style="display:grid; grid-template-columns:1fr 1fr; gap:24px;">
    <div class="admin-card" style="padding:24px;">
        <h3 style="margin-bottom:16px;">Order Items</h3>
        <% if(order.getOrderItems()!=null){for(OrderItem item:order.getOrderItems()){ %>
            <div style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid #E5E7EB;">
                <span><%= item.getPetName() %></span>
                <strong><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f",item.getPrice()) %></strong>
            </div>
        <% }} %>
        <div style="display:flex; justify-content:space-between; padding:16px 0 0; font-size:1.2rem; font-weight:800;">
            <span>Total</span>
            <span style="color:#FF6B35;"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f",order.getTotalAmount()) %></span>
        </div>
    </div>
    <div>
        <div class="admin-card" style="padding:24px; margin-bottom:16px;">
            <h3 style="margin-bottom:16px;">Order Info</h3>
            <p><strong>Customer:</strong> <%= order.getUserName() %></p>
            <p><strong>Email:</strong> <%= order.getUserEmail() %></p>
            <p><strong>Phone:</strong> <%= customerPhone %></p>
            <p><strong>Status:</strong> <span class="badge-status badge-confirmed"><%= order.getOrderStatus() %></span></p>
            <p><strong>Date:</strong> <%= order.getOrderDate() %></p>
            <p><strong>Shipping:</strong> <%= order.getShippingAddress() %>, <%= order.getShippingCity() %>, <%= order.getShippingState() %> - <%= order.getShippingPincode() %></p>
            
            <% if (customer != null && customer.getLatitude() != null && customer.getLongitude() != null) { %>
                <div style="margin-top: 20px;">
                    <h4 style="margin-bottom: 8px; font-size: 0.95rem; color: var(--text-secondary);"><i class="fa-solid fa-map-location-dot"></i> Customer Location</h4>
                    <div id="customer-map" style="height: 200px; border-radius: var(--radius-sm); border: 1px solid var(--border); z-index: 1;"></div>
                </div>
            <% } %>
        </div>
        <% if(payment!=null){ %>
        <div class="admin-card" style="padding:24px;">
            <h3 style="margin-bottom:16px;">Payment Info</h3>
            <p><strong>Transaction ID:</strong> <%= payment.getTransactionId() %></p>
            <p><strong>Method:</strong> <%= payment.getPaymentMethod() %></p>
            <p><strong>Amount:</strong> <i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f",payment.getAmount()) %></p>
            <p><strong>Status:</strong> <span class="badge-status <%= "Completed".equals(payment.getPaymentStatus()) ? "badge-success" : "badge-warning" %>"><%= payment.getPaymentStatus() %></span></p>
            <p><strong>Date:</strong> <%= payment.getPaymentDate() %></p>
            
            <% if (!"Completed".equals(payment.getPaymentStatus())) { %>
                <form method="post" action="<%= ctx %>/admin/orders" style="margin-top: 16px;">
                    <input type="hidden" name="action" value="markPaymentCompleted">
                    <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                    <button type="submit" class="btn btn-success btn-sm"><i class="fa-solid fa-check"></i> Mark Payment Complete</button>
                </form>
            <% } %>
        </div>
        <% } %>
    </div>
</div>

<!-- Hidden script to generate and share bill -->
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
        
        // Colors
        const primary = [99, 102, 241];
        const dark = [15, 23, 42];
        const gray = [100, 116, 139];
        const lightGray = [241, 245, 249];
        
        // Header Background
        doc.setFillColor(...primary);
        doc.rect(0, 0, 210, 50, 'F');
        
        // Company Name
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(24);
        doc.setFont('helvetica', 'bold');
        doc.text('PAW CONNECT', 20, 25);
        doc.setFontSize(10);
        doc.setFont('helvetica', 'normal');
        doc.text('Online Pet Purchase & Payment System', 20, 33);
        doc.text('www.pawconnect.com | support@pawconnect.com', 20, 40);
        
        // Invoice Label
        doc.setFontSize(16);
        doc.setFont('helvetica', 'bold');
        doc.text('INVOICE', 160, 25);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'normal');
        doc.text('#INV-' + orderId, 160, 33);
        
        // Bill To Section
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
        
        // Invoice Details (right side)
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
        
        // Divider
        y = 100;
        doc.setDrawColor(226, 232, 240);
        doc.setLineWidth(0.5);
        doc.line(20, y, 190, y);
        
        // Table Header
        y += 10;
        doc.setFillColor(...lightGray);
        doc.rect(20, y - 6, 170, 10, 'F');
        doc.setTextColor(...dark);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.text('DESCRIPTION', 25, y);
        doc.text('AMOUNT', 165, y, { align: 'right' });
        
        // Table Row
        y += 12;
        doc.setFont('helvetica', 'normal');
        doc.setTextColor(...gray);
        doc.text('Pet Purchase - Order #' + orderId, 25, y);
        doc.setTextColor(...dark);
        doc.setFont('helvetica', 'bold');
        doc.text('Rs. ' + amount, 165, y, { align: 'right' });
        
        // Subtotal Section
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
        
        // Total
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
        
        // Payment Status Badge
        y += 20;
        doc.setFillColor(16, 185, 129);
        doc.roundedRect(20, y - 5, 50, 12, 3, 3, 'F');
        doc.setTextColor(255, 255, 255);
        doc.setFontSize(9);
        doc.setFont('helvetica', 'bold');
        doc.text('PAID', 45, y + 2, { align: 'center' });
        
        // Digital Signature
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
        
        // Footer
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

    function shareWhatsApp() {
        const phone = '<%= customerPhone.replaceAll("[^0-9]", "") %>';
        const orderId = '<%= order.getOrderId() %>';
        const amount = '<%= String.format("%,.2f", order.getTotalAmount()) %>';
        const customerName = '<%= order.getUserName() %>';
        
        let message = `Hello ${customerName},%0A%0A`;
        message += `Thank you for your purchase from *Paw Connect*! 🐾%0A%0A`;
        message += `*Order ID:* #${orderId}%0A`;
        message += `*Total Amount Paid:* Rs. ${amount}%0A`;
        message += `*Payment Status:* Successful ✅%0A%0A`;
        message += `You can download your official bill/invoice from your account dashboard on our website.%0A%0A`;
        message += `We will notify you once your pet is dispatched for delivery! 🚚`;
        
        let url = `https://wa.me/91${phone}?text=${message}`;
        window.open(url, '_blank');
    }
</script>
<% } %>
<!-- Leaflet CSS & JS for Admin Map -->
<% if (customer != null && customer.getLatitude() != null && customer.getLongitude() != null) { %>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const lat = <%= customer.getLatitude() %>;
        const lng = <%= customer.getLongitude() %>;
        const map = L.map('customer-map').setView([lat, lng], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors'
        }).addTo(map);

        L.marker([lat, lng]).addTo(map)
            .bindPopup('<b>Customer Location</b><br><%= order.getShippingCity() %>')
            .openPopup();
    });
</script>
<% } %>

<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
