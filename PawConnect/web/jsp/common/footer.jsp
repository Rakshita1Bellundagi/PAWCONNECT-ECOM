<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String footerCtx = request.getContextPath();
%>
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div>
                    <h3><i class="fa-solid fa-paw"></i> Paw Connect</h3>
                    <p>Your trusted online destination for buying pets. We connect loving families with their perfect furry, feathered, or finned companions. Secure payments and doorstep delivery across India.</p>
                </div>
                <div>
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="<%= footerCtx %>/browse">Browse Pets</a></li>
                        <li><a href="<%= footerCtx %>/browse?category=1">Dogs</a></li>
                        <li><a href="<%= footerCtx %>/browse?category=2">Cats</a></li>
                        <li><a href="<%= footerCtx %>/browse?category=3">Birds</a></li>
                    </ul>
                </div>
                <div>
                    <h3>My Account</h3>
                    <ul>
                        <li><a href="<%= footerCtx %>/user/profile">My Profile</a></li>
                        <li><a href="<%= footerCtx %>/orders/">My Orders</a></li>
                        <li><a href="<%= footerCtx %>/wishlist/">My Wishlist</a></li>
                        <li><a href="<%= footerCtx %>/cart/">My Cart</a></li>
                    </ul>
                </div>
                <div>
                    <h3>Contact Us</h3>
                    <ul>
                        <li>&#128231; support@pawconnect.com</li>
                        <li><i class="fa-solid fa-headset"></i> +91 98765 43210</li>
                        <li><i class="fa-solid fa-location-dot"></i> Hubballi, Karnataka</li>
                        <li>India - 580031</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Paw Connect. All Rights Reserved. | Chetan Business School MCA Project</p>
            </div>
        </div>
    </footer>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vanilla-tilt/1.8.0/vanilla-tilt.min.js"></script>
    <script src="<%= footerCtx %>/js/modal.js"></script>
    <script src="<%= footerCtx %>/js/main.js"></script>
    <script>
        AOS.init({
            duration: 800,
            once: true,
            offset: 100
        });
        
        // Initialize VanillaTilt for elements with data-tilt
        VanillaTilt.init(document.querySelectorAll("[data-tilt]"), {
            max: 15,
            speed: 400,
            glare: true,
            "max-glare": 0.2
        });
    </script>
</body>
</html>
