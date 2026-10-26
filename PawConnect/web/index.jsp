<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.dao.PetDAO, com.pawconnect.dao.CategoryDAO, com.pawconnect.dao.UserDAO, com.pawconnect.dao.OrderDAO" %>
<%@ page import="com.pawconnect.model.Pet, com.pawconnect.model.Category" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Home - Buy Pets Online"/></jsp:include>
<%
    PetDAO petDAO = new PetDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Pet> featuredPets = petDAO.getFeaturedPets(8);
    List<Category> categories = categoryDAO.getAllCategories();
    int totalPets = petDAO.getTotalPets();
    int totalUsers = new UserDAO().getTotalUsers();
    String ctx = request.getContextPath();
%>

<!-- Hero Section -->
<section class="hero">
    <div class="container" data-aos="fade-up" data-aos-duration="1000">
        <span style="display: inline-block; background: rgba(255,255,255,0.15); backdrop-filter: blur(10px); padding: 8px 20px; border-radius: 50px; font-size: 0.85rem; margin-bottom: 20px; letter-spacing: 1px;"><i class="fa-solid fa-sparkles"></i> India's Most Trusted Online Pet Store</span>
        <h1><i class="fa-solid fa-paw"></i> Find Your Perfect Pet Companion</h1>
        <p>Browse, select, and purchase pets online with secure payment. Dogs, cats, birds, fish, and more — delivered to your doorstep with love!</p>
        <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; margin-top: 24px;">
            <a href="<%= ctx %>/browse" class="btn-hero"><i class="fa-solid fa-magnifying-glass"></i> Browse All Pets</a>
            <a href="#how-it-works" class="btn-hero" style="background: rgba(255,255,255,0.15); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.3);"><i class="fa-solid fa-circle-play"></i> How It Works</a>
        </div>
        <div style="display: flex; gap: 32px; justify-content: center; margin-top: 40px; flex-wrap: wrap;">
            <div style="text-align: center;"><div style="font-size: 1.8rem; font-weight: 800;"><%= totalPets %>+</div><div style="font-size: 0.8rem; opacity: 0.8;">Pets Available</div></div>
            <div style="text-align: center;"><div style="font-size: 1.8rem; font-weight: 800;"><%= totalUsers %>+</div><div style="font-size: 0.8rem; opacity: 0.8;">Happy Customers</div></div>
            <div style="text-align: center;"><div style="font-size: 1.8rem; font-weight: 800;"><%= categories.size() %></div><div style="font-size: 0.8rem; opacity: 0.8;">Pet Categories</div></div>
            <div style="text-align: center;"><div style="font-size: 1.8rem; font-weight: 800;">4.9<i class="fa-solid fa-star" style="font-size: 0.9rem;"></i></div><div style="font-size: 0.8rem; opacity: 0.8;">User Rating</div></div>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section id="how-it-works" style="padding: 64px 0; background: var(--bg-card);">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2><i class="fa-solid fa-route"></i> How It Works</h2>
            <p>Getting your dream pet is just 3 simple steps away</p>
        </div>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 32px; text-align: center;">
            <div data-aos="fade-up" data-aos-delay="0" style="padding: 32px 24px;">
                <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #6366F1, #A855F7); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 20px;"><i class="fa-solid fa-magnifying-glass"></i></div>
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 8px;">1. Browse & Choose</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Explore our wide collection of vaccinated, healthy pets. Filter by category, breed, price, and location.</p>
            </div>
            <div data-aos="fade-up" data-aos-delay="100" style="padding: 32px 24px;">
                <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #10B981, #34D399); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 20px;"><i class="fa-solid fa-credit-card"></i></div>
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 8px;">2. Secure Payment</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Pay safely using UPI, Credit/Debit Cards, Net Banking, or Digital Wallets with SSL encryption.</p>
            </div>
            <div data-aos="fade-up" data-aos-delay="200" style="padding: 32px 24px;">
                <div style="width: 80px; height: 80px; border-radius: 50%; background: linear-gradient(135deg, #F59E0B, #FBBF24); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 20px;"><i class="fa-solid fa-truck-fast"></i></div>
                <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 8px;">3. Safe Delivery</h3>
                <p style="color: var(--text-secondary); font-size: 0.9rem;">Your pet is delivered safely to your doorstep with a health certificate and care guide included.</p>
            </div>
        </div>
    </div>
</section>

<!-- Categories -->
<section class="container" style="padding: 64px 0;">
    <div class="section-header" data-aos="fade-up">
        <h2><i class="fa-solid fa-folder-open"></i> Shop by Category</h2>
        <p>Find the perfect pet type for your family</p>
    </div>
    <div class="category-grid">
        <% int delay = 0; for (Category cat : categories) { %>
            <a href="<%= ctx %>/browse?category=<%= cat.getCategoryId() %>" class="category-card" data-aos="fade-up" data-aos-delay="<%= delay %>" data-tilt>
                <img src="<%= ctx %>/images/categories/<%= cat.getCategoryName().toLowerCase().replace(" ", "_") %>.png" alt="<%= cat.getCategoryName() %>" class="cat-img">
                <h3><%= cat.getCategoryName() %></h3>
                <p><%= cat.getPetCount() %> pets available</p>
            </a>
        <% delay += 50; } %>
    </div>
</section>

<!-- Featured Pets -->
<section style="background: var(--bg-secondary); padding: 64px 0;">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2><i class="fa-solid fa-star" style="color:var(--accent);"></i> Featured Pets</h2>
            <p>Our top-rated and most popular pets</p>
        </div>
        <div class="pet-grid">
            <% int petDelay = 0; for (Pet pet : featuredPets) { %>
                <div class="card" data-aos="fade-up" data-aos-delay="<%= petDelay %>" data-tilt>
                    <img src="<%= ctx %>/images/pets/<%= pet.getImageUrl() %>" alt="<%= pet.getPetName() %>" class="card-img" onerror="this.src='https://placehold.co/400x300?text=No+Image';">
                    <div class="card-body">
                        <div class="card-title"><%= pet.getPetName() %></div>
                        <div class="card-text"><%= pet.getBreed() %> &bull; <%= pet.getAge() %> &bull; <%= pet.getGender() %></div>
                        <div class="card-text"><i class="fa-solid fa-location-dot"></i> <%= pet.getLocation() %></div>
                        <div class="stars">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <span class="star <%= i <= pet.getAvgRating() ? "filled" : "" %>"><i class="fa-solid fa-star"></i></span>
                            <% } %>
                            <span style="color: #6C7A89; font-size: 0.8rem; margin-left: 4px;">(<%= pet.getReviewCount() %>)</span>
                        </div>
                        <div class="card-price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", pet.getPrice()) %></div>
                    </div>
                    <div class="card-footer">
                        <a href="<%= ctx %>/pet-details?id=<%= pet.getPetId() %>" class="btn btn-primary btn-sm" style="flex:1">View Details</a>
                        <form method="post" action="<%= ctx %>/cart/" style="flex:1">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                            <button type="submit" class="btn btn-outline btn-sm btn-block add-to-cart-btn"><i class="fa-solid fa-cart-plus"></i> Add to Cart</button>
                        </form>
                    </div>
                </div>
            <% petDelay += 50; } %>
        </div>
        <div style="text-align: center; padding: 32px 0;">
            <a href="<%= ctx %>/browse" class="btn btn-secondary btn-lg">View All Pets <i class="fa-solid fa-arrow-right"></i></a>
        </div>
    </div>
</section>

<!-- Why Choose Us -->
<section style="padding: 64px 0;">
    <div class="container">
        <div class="section-header" data-aos="fade-up">
            <h2><i class="fa-solid fa-shield-cat"></i> Why Choose Paw Connect?</h2>
            <p>India's most trusted online pet store</p>
        </div>
        <div class="category-grid" style="grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));">
            <div class="category-card" data-aos="fade-up" data-aos-delay="0" data-tilt style="text-align: center; padding: 32px 20px;">
                <div style="width: 64px; height: 64px; border-radius: 16px; background: #DBEAFE; color: #3B82F6; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px;"><i class="fa-solid fa-credit-card"></i></div>
                <h3>Secure Payment</h3>
                <p>UPI QR, Cards, Net Banking & Wallets with SSL</p>
            </div>
            <div class="category-card" data-aos="fade-up" data-aos-delay="100" data-tilt style="text-align: center; padding: 32px 20px;">
                <div style="width: 64px; height: 64px; border-radius: 16px; background: #D1FAE5; color: #10B981; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px;"><i class="fa-solid fa-truck-fast"></i></div>
                <h3>Safe Delivery</h3>
                <p>Pets delivered safely with health certificates</p>
            </div>
            <div class="category-card" data-aos="fade-up" data-aos-delay="200" data-tilt style="text-align: center; padding: 32px 20px;">
                <div style="width: 64px; height: 64px; border-radius: 16px; background: #FEF3C7; color: #F59E0B; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px;"><i class="fa-solid fa-circle-check"></i></div>
                <h3>Health Certified</h3>
                <p>All pets vaccinated & vet checked</p>
            </div>
            <div class="category-card" data-aos="fade-up" data-aos-delay="300" data-tilt style="text-align: center; padding: 32px 20px;">
                <div style="width: 64px; height: 64px; border-radius: 16px; background: #E0E7FF; color: #6366F1; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 16px;"><i class="fa-solid fa-headset"></i></div>
                <h3>24/7 Support</h3>
                <p>Expert pet care guidance anytime</p>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials -->
<section style="background: linear-gradient(135deg, #6366F1 0%, #A855F7 100%); padding: 64px 0; color: #fff;">
    <div class="container">
        <div class="section-header" data-aos="fade-up" style="color: #fff;">
            <h2 style="color: #fff;"><i class="fa-solid fa-quote-left"></i> What Our Customers Say</h2>
            <p style="color: rgba(255,255,255,0.8);">Trusted by pet lovers across India</p>
        </div>
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px;">
            <div data-aos="fade-up" data-aos-delay="0" style="background: rgba(255,255,255,0.12); backdrop-filter: blur(10px); border-radius: 20px; padding: 32px; border: 1px solid rgba(255,255,255,0.15);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                    <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.2rem;">R</div>
                    <div><div style="font-weight: 700;">Rahul Sharma</div><div style="font-size: 0.8rem; opacity: 0.7;">Bangalore</div></div>
                    <div style="margin-left: auto; color: #FFC107;"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div>
                </div>
                <p style="font-size: 0.9rem; opacity: 0.9; line-height: 1.7;">"Got my adorable Golden Retriever from Paw Connect. The entire process was smooth — from browsing to payment to delivery. The pet came with a health certificate and all vaccinations done. Highly recommended!"</p>
            </div>
            <div data-aos="fade-up" data-aos-delay="100" style="background: rgba(255,255,255,0.12); backdrop-filter: blur(10px); border-radius: 20px; padding: 32px; border: 1px solid rgba(255,255,255,0.15);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                    <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.2rem;">P</div>
                    <div><div style="font-weight: 700;">Priya Patel</div><div style="font-size: 0.8rem; opacity: 0.7;">Mumbai</div></div>
                    <div style="margin-left: auto; color: #FFC107;"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i></div>
                </div>
                <p style="font-size: 0.9rem; opacity: 0.9; line-height: 1.7;">"The care guide that came with my Persian cat was incredibly helpful. UPI payment was instant and I received the bill immediately. Paw Connect truly cares about pets and their new families!"</p>
            </div>
            <div data-aos="fade-up" data-aos-delay="200" style="background: rgba(255,255,255,0.12); backdrop-filter: blur(10px); border-radius: 20px; padding: 32px; border: 1px solid rgba(255,255,255,0.15);">
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
                    <div style="width: 48px; height: 48px; border-radius: 50%; background: rgba(255,255,255,0.2); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 1.2rem;">A</div>
                    <div><div style="font-weight: 700;">Arjun Reddy</div><div style="font-size: 0.8rem; opacity: 0.7;">Hyderabad</div></div>
                    <div style="margin-left: auto; color: #FFC107;"><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-solid fa-star"></i><i class="fa-regular fa-star"></i></div>
                </div>
                <p style="font-size: 0.9rem; opacity: 0.9; line-height: 1.7;">"Best online pet store experience I've had. My kids love the Beagle we got. The detailed pet information and health tips section helped us prepare before the pet arrived. Great service!"</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA Banner -->
<section style="padding: 64px 0; text-align: center;" data-aos="fade-up">
    <div class="container">
        <div style="background: linear-gradient(135deg, #0F172A 0%, #334155 100%); border-radius: 24px; padding: 48px 32px; color: #fff;">
            <h2 style="font-size: 2rem; font-weight: 800; margin-bottom: 12px;"><i class="fa-solid fa-heart" style="color: #EC4899;"></i> Ready to Find Your Furry Friend?</h2>
            <p style="font-size: 1.1rem; opacity: 0.8; margin-bottom: 24px; max-width: 600px; margin-left: auto; margin-right: auto;">Join thousands of happy pet owners who found their perfect companion through Paw Connect.</p>
            <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                <a href="<%= ctx %>/browse" class="btn btn-lg" style="background: var(--primary); color: #fff; border: none;"><i class="fa-solid fa-magnifying-glass"></i> Start Browsing</a>
                <a href="<%= ctx %>/register" class="btn btn-lg" style="background: rgba(255,255,255,0.15); color: #fff; border: 1px solid rgba(255,255,255,0.3);"><i class="fa-solid fa-user-plus"></i> Create Account</a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/jsp/common/footer.jsp"/>
