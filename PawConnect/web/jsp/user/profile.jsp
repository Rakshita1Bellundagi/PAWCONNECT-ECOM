<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.User" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="My Profile"/></jsp:include>
<%
    User user = (User) request.getAttribute("user");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String ctx = request.getContextPath();
%>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<div class="page-header"><div class="container"><h1><i class="fa-solid fa-user"></i> My Profile</h1><p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Profile</p></div></div>
<div class="container">
<div class="profile-card" data-aos="fade-up" data-tilt data-tilt-max="2" data-tilt-speed="400" data-tilt-glare="true" data-tilt-max-glare="0.1" style="transform-style: preserve-3d; margin-top: -30px; position: relative; z-index: 10;">
<% if (error != null) { %><div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div><% } %>
<% if (success != null) { %><div class="alert alert-success"><i class="fa-solid fa-circle-check" style="color:var(--success);"></i> <%= success %></div><% } %>
<form method="post" action="<%= ctx %>/user/profile" data-validate="true">
<h2 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 24px;">Personal Information</h2>
<div class="form-group"><label>Full Name *</label><input type="text" name="fullName" class="form-control" value="<%= user.getFullName() %>" required></div>
<div class="form-group"><label>Email (cannot be changed)</label><input type="email" class="form-control" value="<%= user.getEmail() %>" disabled></div>
<div class="form-group"><label>Phone Number</label><input type="tel" name="phone" class="form-control" value="<%= user.getPhone() != null ? user.getPhone() : "" %>"></div>
<div class="form-group"><label>Address</label><textarea name="address" class="form-control" rows="2"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea></div>
<div class="form-row">
<div class="form-group"><label>City</label><input type="text" name="city" class="form-control" value="<%= user.getCity() != null ? user.getCity() : "" %>"></div>
<div class="form-group"><label>State</label><input type="text" name="state" class="form-control" value="<%= user.getState() != null ? user.getState() : "" %>"></div>
</div>
<div class="form-group"><label>Pincode</label><input type="text" name="pincode" class="form-control" value="<%= user.getPincode() != null ? user.getPincode() : "" %>"></div>

<div style="margin-bottom: 24px;">
    <label style="display:block; margin-bottom:8px; font-weight:500;">Your Location (Click map to update)</label>
    <div id="map" style="height: 250px; width: 100%; border-radius: 8px; border: 1px solid var(--border); z-index: 1;"></div>
    <input type="hidden" id="latitude" name="latitude" value="<%= user.getLatitude() != null ? user.getLatitude() : "" %>">
    <input type="hidden" id="longitude" name="longitude" value="<%= user.getLongitude() != null ? user.getLongitude() : "" %>">
</div>

<button type="submit" class="btn btn-primary btn-lg">Save Changes</button>
</form>
</div>
</div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    var hasLocation = <%= user.getLatitude() != null %>;
    var initialLat = hasLocation ? <%= user.getLatitude() != null ? user.getLatitude() : "20.5937" %> : 20.5937;
    var initialLng = hasLocation ? <%= user.getLongitude() != null ? user.getLongitude() : "78.9629" %> : 78.9629;
    
    var map = L.map('map').setView([initialLat, initialLng], hasLocation ? 14 : 5);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    var marker = L.marker([initialLat, initialLng]).addTo(map);
    if (!hasLocation) {
        marker.setOpacity(0);
    }

    map.on('click', function(e) {
        var lat = e.latlng.lat;
        var lng = e.latlng.lng;
        marker.setLatLng([lat, lng]);
        marker.setOpacity(1);
        document.getElementById('latitude').value = lat;
        document.getElementById('longitude').value = lng;
    });

    if ("geolocation" in navigator && !hasLocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude;
            var lng = position.coords.longitude;
            map.setView([lat, lng], 14);
            marker.setLatLng([lat, lng]);
            marker.setOpacity(1);
            document.getElementById('latitude').value = lat;
            document.getElementById('longitude').value = lng;
        });
    }
</script>

<jsp:include page="/jsp/common/footer.jsp"/>
