<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Register"/></jsp:include>
<%
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>

<div class="auth-container" style="max-width: 600px;">
    <div class="auth-card">
        <h2><i class="fa-solid fa-hand-sparkles"></i> Create Account</h2>
        <p class="subtitle">Join Paw Connect and find your perfect pet</p>

        <% if (error != null) { %>
            <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> <%= error %></div>
        <% } %>

        <form method="post" action="<%= ctx %>/register" data-validate="true">
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" class="form-control" placeholder="Enter your full name" required>
            </div>
            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div class="form-group">
                    <label>Password *</label>
                    <div style="position: relative;">
                        <input type="password" id="reg-password" name="password" class="form-control" placeholder="Create password" required onkeyup="checkPasswordStrength()">
                        <i class="fa-solid fa-eye" id="toggle-reg-pwd" style="position: absolute; right: 15px; top: 15px; cursor: pointer; color: var(--text-light);" onclick="togglePassword('reg-password', 'toggle-reg-pwd')"></i>
                    </div>
                    <div id="password-strength-container" style="margin-top: 8px; height: 4px; background: #eee; border-radius: 2px; overflow: hidden; display: none;">
                        <div id="password-strength-bar" style="height: 100%; width: 0%; transition: 0.3s;"></div>
                    </div>
                    <small id="password-strength-text" style="color: var(--text-light); font-size: 0.75rem; display: block; margin-top: 4px;"></small>
                </div>
                <div class="form-group">
                    <label>Confirm Password *</label>
                    <div style="position: relative;">
                        <input type="password" id="reg-confirm" name="confirmPassword" class="form-control" placeholder="Confirm password" required onkeyup="checkPasswordMatch()">
                        <i class="fa-solid fa-eye" id="toggle-reg-conf" style="position: absolute; right: 15px; top: 15px; cursor: pointer; color: var(--text-light);" onclick="togglePassword('reg-confirm', 'toggle-reg-conf')"></i>
                    </div>
                    <small id="password-match-text" style="color: var(--danger); font-size: 0.75rem; display: none; margin-top: 4px;">Passwords do not match</small>
                </div>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="tel" name="phone" class="form-control" placeholder="Enter phone number">
            </div>
            <div class="form-group">
                <label>Address</label>
                <textarea id="reg-address" name="address" class="form-control" rows="2" placeholder="Enter your full address"></textarea>
            </div>
            
            <!-- Leaflet Map Integration -->
            <div class="form-group">
                <label><i class="fa-solid fa-map-location-dot"></i> Your Location</label>
                <p style="font-size: 0.8rem; color: var(--text-light); margin-bottom: 8px;">Click on the map or click the button to detect your current location.</p>
                <div style="display: flex; gap: 8px; margin-bottom: 8px;">
                    <button type="button" class="btn btn-sm btn-outline" onclick="detectLocation()"><i class="fa-solid fa-location-crosshairs"></i> Detect My Location</button>
                    <span id="location-status" style="font-size: 0.85rem; color: var(--success); display: none; align-items: center;"><i class="fa-solid fa-check"></i> Location captured</span>
                </div>
                <div id="map" style="height: 250px; border-radius: var(--radius-sm); border: 1px solid var(--border); z-index: 1;"></div>
                
                <input type="hidden" name="latitude" id="latitude">
                <input type="hidden" name="longitude" id="longitude">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                <div class="form-group">
                    <label>City</label>
                    <input type="text" id="reg-city" name="city" class="form-control" placeholder="City">
                </div>
                <div class="form-group">
                    <label>State</label>
                    <input type="text" id="reg-state" name="state" class="form-control" placeholder="State">
                </div>
                <div class="form-group">
                    <label>Pincode</label>
                    <input type="text" id="reg-pincode" name="pincode" class="form-control" placeholder="Pincode">
                </div>
            </div>
            <button type="submit" id="register-btn" class="btn btn-primary btn-block btn-lg" disabled style="opacity: 0.6; cursor: not-allowed;" title="Please enter a strong password first">Create Account <i class="fa-solid fa-lock"></i></button>
        </form>

        <!-- Leaflet CSS & JS -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>

        <script>
            // Map Initialization
            let map;
            let marker;
            
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize map centered on India
                map = L.map('map').setView([20.5937, 78.9629], 4);
                
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(map);

                // Add click listener
                map.on('click', function(e) {
                    setLocation(e.latlng.lat, e.latlng.lng);
                });
            });

            function detectLocation() {
                if (navigator.geolocation) {
                    document.getElementById('location-status').innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Detecting...';
                    document.getElementById('location-status').style.display = 'flex';
                    document.getElementById('location-status').style.color = 'var(--primary)';
                    
                    navigator.geolocation.getCurrentPosition(
                        function(position) {
                            setLocation(position.coords.latitude, position.coords.longitude);
                            map.setView([position.coords.latitude, position.coords.longitude], 15);
                        },
                        function(error) {
                            alert('Could not get your location. Please click on the map manually.');
                            document.getElementById('location-status').style.display = 'none';
                        }
                    );
                } else {
                    alert('Geolocation is not supported by your browser');
                }
            }

            function setLocation(lat, lng) {
                // Update hidden inputs
                document.getElementById('latitude').value = lat;
                document.getElementById('longitude').value = lng;
                
                // Show success status
                document.getElementById('location-status').innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Fetching address...';
                document.getElementById('location-status').style.display = 'flex';
                document.getElementById('location-status').style.color = 'var(--primary)';
                
                // Add or move marker
                if (marker) {
                    marker.setLatLng([lat, lng]);
                } else {
                    marker = L.marker([lat, lng]).addTo(map);
                }
                
                // Reverse geocoding using OpenStreetMap Nominatim
                fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}`)
                    .then(response => response.json())
                    .then(data => {
                        let cityText = '';
                        if(data.address) {
                            // Try to get City, State, and Pincode
                            const city = data.address.city || data.address.town || data.address.village || data.address.state_district || data.address.county || '';
                            const state = data.address.state || '';
                            const pincode = data.address.postcode || '';
                            
                            // Try to get a meaningful address line
                            let address = data.display_name || '';
                            
                            // Fill the form fields using IDs to guarantee no conflicts
                            document.getElementById('reg-city').value = city;
                            document.getElementById('reg-state').value = state;
                            document.getElementById('reg-pincode').value = pincode;
                            document.getElementById('reg-address').value = address;
                            
                            cityText = city ? (' in ' + city) : '';
                        }
                        
                        document.getElementById('location-status').innerHTML = '<i class="fa-solid fa-check"></i> Address auto-filled' + cityText;
                        document.getElementById('location-status').style.color = 'var(--success)';
                    })
                    .catch(error => {
                        console.error("Error fetching address:", error);
                        document.getElementById('location-status').innerHTML = '<i class="fa-solid fa-check"></i> Location captured (Address failed)';
                        document.getElementById('location-status').style.color = '#F59E0B'; // Orange
                    });
            }
        </script>

        <script>
            let isStrong = false;
            let isMatch = false;

            function togglePassword(inputId, iconId) {
                const input = document.getElementById(inputId);
                const icon = document.getElementById(iconId);
                if (input.type === "password") {
                    input.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    input.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }

            function checkPasswordStrength() {
                const pwd = document.getElementById('reg-password').value;
                const container = document.getElementById('password-strength-container');
                const bar = document.getElementById('password-strength-bar');
                const text = document.getElementById('password-strength-text');
                
                if(pwd.length === 0) {
                    container.style.display = 'none';
                    text.innerText = '';
                    isStrong = false;
                    updateButton();
                    return;
                }
                
                container.style.display = 'block';
                
                let strength = 0;
                if (pwd.length >= 8) strength += 1;
                if (pwd.match(/[a-z]+/)) strength += 1;
                if (pwd.match(/[A-Z]+/)) strength += 1;
                if (pwd.match(/[0-9]+/)) strength += 1;
                if (pwd.match(/[$@#&!]+/)) strength += 1;

                if (strength <= 2) {
                    bar.style.width = '33%';
                    bar.style.backgroundColor = 'var(--danger)';
                    text.innerText = 'Weak - Needs uppercase, numbers & symbols';
                    text.style.color = 'var(--danger)';
                    isStrong = false;
                } else if (strength === 3 || strength === 4) {
                    bar.style.width = '66%';
                    bar.style.backgroundColor = '#F59E0B'; // Orange
                    text.innerText = 'Medium - Add more variety';
                    text.style.color = '#F59E0B';
                    isStrong = false;
                } else {
                    bar.style.width = '100%';
                    bar.style.backgroundColor = 'var(--success)';
                    text.innerText = 'Strong - Ready to go!';
                    text.style.color = 'var(--success)';
                    isStrong = true;
                }
                
                checkPasswordMatch();
            }

            function checkPasswordMatch() {
                const pwd = document.getElementById('reg-password').value;
                const conf = document.getElementById('reg-confirm').value;
                const matchText = document.getElementById('password-match-text');
                
                if(conf.length === 0) {
                    matchText.style.display = 'none';
                    isMatch = false;
                } else if(pwd !== conf) {
                    matchText.style.display = 'block';
                    isMatch = false;
                } else {
                    matchText.style.display = 'none';
                    isMatch = true;
                }
                updateButton();
            }

            function updateButton() {
                const btn = document.getElementById('register-btn');
                if(isStrong && isMatch) {
                    btn.disabled = false;
                    btn.style.opacity = '1';
                    btn.style.cursor = 'pointer';
                    btn.innerHTML = 'Create Account <i class="fa-solid fa-arrow-right"></i>';
                    btn.title = '';
                } else {
                    btn.disabled = true;
                    btn.style.opacity = '0.6';
                    btn.style.cursor = 'not-allowed';
                    btn.innerHTML = 'Create Account <i class="fa-solid fa-lock"></i>';
                    btn.title = 'Please enter a strong password and match it first';
                }
            }
        </script>

        <div class="auth-footer">
            Already have an account? <a href="<%= ctx %>/login">Sign in here</a>
        </div>
    </div>
</div>

<jsp:include page="/jsp/common/footer.jsp"/>
