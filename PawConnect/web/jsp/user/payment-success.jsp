<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Order, com.pawconnect.model.Payment" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Payment Successful"/></jsp:include>
<%
    Order order = (Order) request.getAttribute("order");
    Payment payment = (Payment) request.getAttribute("payment");
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String ctx = request.getContextPath();
%>
<!-- jsPDF for PDF bill generation -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<div class="container">
    <div class="result-page" data-aos="fade-up">
        <div class="icon success" style="animation: bounceIn 0.6s;"><i class="fa-solid fa-circle-check" style="color:var(--success);"></i></div>
        <h1>Payment Successful!</h1>
        <p style="color: var(--text-secondary); font-size: 1.1rem;">Your order has been placed successfully. Thank you for shopping with Paw Connect!</p>

        <div class="details">
            <div class="detail-row">
                <span style="color: var(--text-light);">Order ID</span>
                <strong>#<%= order != null ? order.getOrderId() : "" %></strong>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Transaction ID</span>
                <strong><%= payment != null ? payment.getTransactionId() : "" %></strong>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Payment Method</span>
                <strong><%= payment != null ? payment.getPaymentMethod() : "" %></strong>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Amount Paid</span>
                <strong style="color: var(--success); font-size: 1.2rem;"><i class="fa-solid fa-indian-rupee-sign"></i><%= payment != null ? String.format("%,.2f", payment.getAmount()) : "0.00" %></strong>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Payment Status</span>
                <span class="badge-status badge-success"><i class="fa-solid fa-circle-check" style="color:var(--success);"></i> Success</span>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Order Status</span>
                <span class="badge-status badge-confirmed">Confirmed</span>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Date</span>
                <strong><%= payment != null ? payment.getPaymentDate() : "" %></strong>
            </div>
        </div>

        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
            <button onclick="generateBillPDF()" class="btn btn-primary btn-lg"><i class="fa-solid fa-file-pdf"></i> Download Bill (PDF)</button>
            <a href="<%= ctx %>/orders/<%= order != null ? order.getOrderId() : "" %>" class="btn btn-secondary btn-lg"><i class="fa-solid fa-eye"></i> View Order</a>
            <a href="<%= ctx %>/browse" class="btn btn-outline btn-lg"><i class="fa-solid fa-cart-shopping"></i> Continue Shopping</a>
        </div>
    </div>
</div>

<script>
function generateBillPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    
    const orderId = '<%= order != null ? order.getOrderId() : "N/A" %>';
    const txnId = '<%= payment != null ? payment.getTransactionId() : "N/A" %>';
    const method = '<%= payment != null ? payment.getPaymentMethod() : "N/A" %>';
    const amount = '<%= payment != null ? String.format("%,.2f", payment.getAmount()) : "0.00" %>';
    const date = '<%= payment != null ? payment.getPaymentDate() : "N/A" %>';
    const customerName = '<%= userName != null ? userName : "Customer" %>';
    const customerEmail = '<%= userEmail != null ? userEmail : "" %>';
    
    // Colors
    const primary = [99, 102, 241]; // #6366F1
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
    y += 5;
    doc.text('Thank you for your purchase! For support, contact us at the details above.', 105, y, { align: 'center' });
    
    // Save
    doc.save('PawConnect_Invoice_' + orderId + '.pdf');
}
</script>

<style>
@keyframes bounceIn {
    0% { transform: scale(0); opacity: 0; }
    50% { transform: scale(1.2); }
    100% { transform: scale(1); opacity: 1; }
}
</style>

<jsp:include page="/jsp/common/footer.jsp"/>
