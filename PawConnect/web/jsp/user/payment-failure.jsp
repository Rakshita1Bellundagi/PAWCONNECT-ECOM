<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Payment Failed"/></jsp:include>
<%
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>

<div class="container">
    <div class="result-page">
        <div class="icon failure"><i class="fa-solid fa-circle-xmark" style="color:var(--danger);"></i></div>
        <h1>Payment Failed</h1>
        <p style="color: var(--text-secondary); font-size: 1.1rem;"><%= error != null ? error : "Something went wrong. Your payment could not be processed." %></p>

        <div class="details">
            <div class="detail-row">
                <span style="color: var(--text-light);">Status</span>
                <span class="badge-status badge-failed"><i class="fa-solid fa-circle-xmark" style="color:var(--danger);"></i> Failed</span>
            </div>
            <div class="detail-row">
                <span style="color: var(--text-light);">Note</span>
                <span>No amount has been deducted from your account.</span>
            </div>
        </div>

        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
            <a href="<%= ctx %>/checkout/" class="btn btn-primary btn-lg">&#128260; Try Again</a>
            <a href="<%= ctx %>/browse" class="btn btn-outline btn-lg">Continue Shopping</a>
        </div>
    </div>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
