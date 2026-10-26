<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Internal Server Error"/></jsp:include>
<% String ctx = request.getContextPath(); %>
<div class="container">
    <div class="empty-state">
        <div class="icon" style="color: var(--danger);"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <h1 style="font-size: 4rem; font-weight: 800; color: var(--text-primary); margin: 0;">500</h1>
        <h2>Internal Server Error</h2>
        <p>We're experiencing some technical difficulties. Please try again later or contact support if the problem persists.</p>
        <div style="margin-top: 24px;">
            <a href="<%= ctx %>/" class="btn btn-primary btn-lg">&#8962; Back to Home</a>
        </div>
    </div>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
