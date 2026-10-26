<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Page Not Found"/></jsp:include>
<% String ctx = request.getContextPath(); %>
<div class="container">
    <div class="empty-state">
        <div class="icon" style="color: var(--primary);">&#128683;</div>
        <h1 style="font-size: 4rem; font-weight: 800; color: var(--text-primary); margin: 0;">404</h1>
        <h2>Oops! Page Not Found</h2>
        <p>The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
        <div style="margin-top: 24px;">
            <a href="<%= ctx %>/" class="btn btn-primary btn-lg">&#8962; Back to Home</a>
            <a href="<%= ctx %>/browse" class="btn btn-outline btn-lg"><i class="fa-solid fa-magnifying-glass"></i> Browse Pets</a>
        </div>
    </div>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
