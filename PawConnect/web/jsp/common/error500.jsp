<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Internal Server Error"/></jsp:include>
<% String ctx = request.getContextPath(); %>
<div class="container">
    <div class="empty-state">
        <div class="icon" style="color: var(--danger);"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <h1 style="font-size: 4rem; font-weight: 800; color: var(--text-primary); margin: 0;">500</h1>
        <h2>Internal Server Error</h2>
        <p>We're experiencing some technical difficulties. Please try again later or contact support if the problem persists.</p>
        <% 
            Throwable err = (Throwable) request.getAttribute("jakarta.servlet.error.exception");
            if (err == null && exception != null) err = exception;
            if (err != null) {
        %>
            <div style="background:#fee2e2; color:#b91c1c; padding:12px 18px; border-radius:8px; margin:16px auto; max-width:600px; text-align:left; font-family:monospace; font-size:0.85rem; word-break:break-all;">
                <strong>Debug Info:</strong> <%= err.getMessage() != null ? err.getMessage() : err.toString() %>
            </div>
        <% } %>
        <div style="margin-top: 24px;">
            <a href="<%= ctx %>/" class="btn btn-primary btn-lg">&#8962; Back to Home</a>
        </div>
    </div>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
