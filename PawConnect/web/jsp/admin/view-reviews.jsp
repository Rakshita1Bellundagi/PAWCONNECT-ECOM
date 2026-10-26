<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Review" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/admin-header.jsp"><jsp:param name="pageTitle" value="Reviews"/></jsp:include>
<% List<Review> reviews = (List<Review>) request.getAttribute("reviews"); String ctx = request.getContextPath(); %>
<div class="admin-header"><h1><i class="fa-solid fa-star" style="color:var(--accent);"></i> All Reviews</h1><div class="header-actions"><input type="text" id="adminSearch" class="form-control" placeholder="Search reviews..." style="width:250px;"></div></div>
<div class="admin-card"><div class="card-body">
<table><thead><tr><th>ID</th><th>User</th><th>Pet</th><th>Rating</th><th>Review</th><th>Date</th><th>Action</th></tr></thead>
<tbody>
<% if(reviews!=null){for(Review r:reviews){ %>
<tr><td>#<%= r.getReviewId() %></td><td><%= r.getUserName() %></td><td><%= r.getPetName() %></td>
<td><div class="stars"><% for(int i=1;i<=5;i++){ %><span class="star <%= i<=r.getRating()?"filled":"" %>"><i class="fa-solid fa-star"></i></span><% } %></div></td>
<td style="max-width:300px; font-size:0.8rem;"><%= r.getReviewText()!=null?(r.getReviewText().length()>100?r.getReviewText().substring(0,100)+"...":r.getReviewText()):"-" %></td>
<td style="font-size:0.8rem;"><%= r.getCreatedAt() %></td>
<td><form method="post" action="<%= ctx %>/admin/reviews" style="display:inline;"><input type="hidden" name="action" value="deleteReview"><input type="hidden" name="reviewId" value="<%= r.getReviewId() %>"><button type="submit" class="btn btn-danger btn-sm delete-btn">Delete</button></form></td></tr>
<% }} %>
</tbody></table>
</div></div>
<jsp:include page="/jsp/common/admin-sidebar.jsp"/>
