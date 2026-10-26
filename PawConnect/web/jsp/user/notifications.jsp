<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Notification" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Notifications"/></jsp:include>
<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) unreadCount = 0;
    String ctx = request.getContextPath();
%>
<div class="page-header"><div class="container"><h1><i class="fa-solid fa-bell"></i> Notifications</h1><p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Notifications (<%= unreadCount %> unread)</p></div></div>
<div class="container">
<% if (unreadCount > 0) { %>
<div style="text-align: right; margin-bottom: 16px;">
<form method="post" action="<%= ctx %>/notifications/" style="display: inline;"><input type="hidden" name="action" value="markAllRead"><button type="submit" class="btn btn-outline btn-sm"><i class="fa-solid fa-check-double"></i> Mark All as Read</button></form>
</div>
<% } %>
<% if (notifications != null && !notifications.isEmpty()) { %>
<% for (Notification notif : notifications) {
    String iconClass = "general";
    String icon = "<i class=\"fa-solid fa-bell\"></i>";
    if ("Order".equals(notif.getType())) { iconClass = "order"; icon = "<i class=\"fa-solid fa-box-open\"></i>"; }
    else if ("Payment".equals(notif.getType())) { iconClass = "payment"; icon = "<i class=\"fa-solid fa-credit-card\"></i>"; }
    else if ("Promotion".equals(notif.getType())) { iconClass = "promotion"; icon = "<i class=\"fa-solid fa-gift\"></i>"; }
%>
<div class="notification-item <%= !notif.isRead() ? "unread" : "" %>" data-aos="fade-up">
    <div class="notif-icon <%= iconClass %>"><%= icon %></div>
    <div style="flex: 1;">
        <h4 style="font-size: 0.95rem; font-weight: 600;"><%= notif.getTitle() %></h4>
        <p style="color: var(--text-secondary); font-size: 0.85rem; margin: 4px 0;"><%= notif.getMessage() %></p>
        <span style="font-size: 0.75rem; color: var(--text-light);"><%= notif.getCreatedAt() %></span>
    </div>
    <% if (!notif.isRead()) { %>
    <form method="post" action="<%= ctx %>/notifications/"><input type="hidden" name="action" value="markRead"><input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>"><button type="submit" class="btn btn-sm btn-outline" style="font-size: 0.7rem;"><i class="fa-solid fa-check"></i> Read</button></form>
    <% } %>
</div>
<% } %>
<% } else { %>
<div class="empty-state"><div class="icon"><i class="fa-solid fa-bell-slash"></i></div><h2>No Notifications</h2><p>You're all caught up!</p></div>
<% } %>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
