<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pawconnect.model.Pet, com.pawconnect.model.Review" %>
<%@ page import="java.util.List" %>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Pet Details"/></jsp:include>
<%
    Pet pet = (Pet) request.getAttribute("pet");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Boolean inWishlist = (Boolean) request.getAttribute("inWishlist");
    Integer userId = (Integer) session.getAttribute("userId");
    String ctx = request.getContextPath();
    
    // Parse do/dont lists
    String[] doItems = (pet.getDoList() != null && !pet.getDoList().isEmpty()) ? pet.getDoList().split("\\|") : new String[0];
    String[] dontItems = (pet.getDontList() != null && !pet.getDontList().isEmpty()) ? pet.getDontList().split("\\|") : new String[0];
%>

<style>
    .image-gallery { display: flex; gap: 12px; flex-direction: column; }
    .image-gallery .main-image { width: 100%; border-radius: var(--radius); object-fit: cover; max-height: 500px; cursor: zoom-in; transition: var(--transition); }
    .image-gallery .thumb-row { display: flex; gap: 8px; }
    .image-gallery .thumb { width: 80px; height: 80px; border-radius: var(--radius-sm); object-fit: cover; cursor: pointer; border: 3px solid transparent; transition: var(--transition); opacity: 0.7; }
    .image-gallery .thumb:hover, .image-gallery .thumb.active { border-color: var(--primary); opacity: 1; }

    .care-tabs { display: flex; gap: 4px; flex-wrap: wrap; margin-bottom: 24px; border-bottom: 2px solid var(--border); padding-bottom: 0; }
    .care-tab { padding: 10px 20px; cursor: pointer; font-size: 0.85rem; font-weight: 600; color: var(--text-light); border-bottom: 3px solid transparent; transition: var(--transition); background: none; border-top: none; border-left: none; border-right: none; }
    .care-tab:hover { color: var(--primary); }
    .care-tab.active { color: var(--primary); border-bottom-color: var(--primary); }
    .care-content { display: none; animation: fadeIn 0.3s ease; }
    .care-content.active { display: block; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    .guide-card { background: var(--bg-secondary); border-radius: var(--radius); padding: 24px; margin-bottom: 16px; }
    .guide-card h4 { font-size: 1rem; font-weight: 700; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .guide-card p { color: var(--text-secondary); line-height: 1.8; font-size: 0.9rem; }
    .guide-list { list-style: none; padding: 0; }
    .guide-list li { padding: 8px 0; display: flex; align-items: flex-start; gap: 10px; font-size: 0.9rem; color: var(--text-secondary); border-bottom: 1px solid var(--border); }
    .guide-list li:last-child { border-bottom: none; }
    .guide-list li i { margin-top: 4px; flex-shrink: 0; }
    .do-icon { color: var(--success); }
    .dont-icon { color: var(--danger); }
</style>

<div class="container">
    <div class="pet-details" data-aos="fade-up">
        <!-- Image Gallery -->
        <div class="image-gallery">
            <% String mainImgSrc = pet.getImageUrl().startsWith("http") ? pet.getImageUrl() : ctx + "/images/pets/" + pet.getImageUrl(); %>
            <img id="mainImage" src="<%= mainImgSrc %>" alt="<%= pet.getPetName() %>" class="main-image" onerror="this.src='https://placehold.co/800x600?text=No+Image';">
            <div class="thumb-row">
                <img src="<%= mainImgSrc %>" alt="<%= pet.getPetName() %> - Photo 1" class="thumb active" onclick="changeImage(this)" onerror="this.src='https://placehold.co/80x80?text=1';">
                <% if (pet.getImageUrl2() != null && !pet.getImageUrl2().isEmpty()) { 
                    String thumb2Src = pet.getImageUrl2().startsWith("http") ? pet.getImageUrl2() : ctx + "/images/pets/" + pet.getImageUrl2();
                %>
                    <img src="<%= thumb2Src %>" alt="<%= pet.getPetName() %> - Photo 2" class="thumb" onclick="changeImage(this)" onerror="this.style.display='none';">
                <% } %>
            </div>
        </div>
        <div class="pet-info">
            <span class="badge-status badge-confirmed"><%= pet.getCategoryName() %></span>
            <h1><%= pet.getPetName() %></h1>
            <p class="breed"><%= pet.getBreed() %> &bull; <%= pet.getAge() %> &bull; <%= pet.getGender() %></p>

            <div class="stars" style="font-size: 1.2rem;">
                <% for (int i = 1; i <= 5; i++) { %>
                    <span class="star <%= i <= pet.getAvgRating() ? "filled" : "" %>"><i class="fa-solid fa-star"></i></span>
                <% } %>
                <span style="color: #6C7A89; font-size: 0.9rem; margin-left: 8px;">(<%= pet.getReviewCount() %> reviews)</span>
            </div>

            <div class="price"><i class="fa-solid fa-indian-rupee-sign"></i><%= String.format("%,.2f", pet.getPrice()) %></div>

            <p style="color: var(--text-secondary); line-height: 1.8;"><%= pet.getDescription() %></p>

            <div class="info-grid">
                <div class="info-item"><div class="label">Age</div><div class="value"><%= pet.getAge() %></div></div>
                <div class="info-item"><div class="label">Gender</div><div class="value"><%= pet.getGender() %></div></div>
                <div class="info-item"><div class="label">Color</div><div class="value"><%= pet.getColor() %></div></div>
                <div class="info-item"><div class="label">Weight</div><div class="value"><%= pet.getWeight() %> kg</div></div>
                <div class="info-item"><div class="label">Health</div><div class="value"><%= pet.getHealthStatus() %></div></div>
                <div class="info-item"><div class="label">Vaccinated</div><div class="value"><%= pet.isVaccinationStatus() ? "<i class='fa-solid fa-circle-check' style='color:var(--success);'></i> Yes" : "<i class='fa-solid fa-circle-xmark' style='color:var(--danger);'></i> No" %></div></div>
                <div class="info-item"><div class="label">Location</div><div class="value"><i class="fa-solid fa-location-dot"></i> <%= pet.getLocation() %></div></div>
                <div class="info-item"><div class="label">Status</div><div class="value"><%= pet.isAvailable() ? "<i class='fa-solid fa-circle-check' style='color:var(--success);'></i> Available" : "<i class='fa-solid fa-circle-xmark' style='color:var(--danger);'></i> Sold" %></div></div>
            </div>

            <div class="actions">
                <form method="post" action="<%= ctx %>/cart/">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                    <button type="submit" class="btn btn-primary btn-lg"><i class="fa-solid fa-cart-shopping"></i> Add to Cart</button>
                </form>
                <form method="post" action="<%= ctx %>/wishlist/">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                    <button type="submit" class="btn btn-outline btn-lg"><%= (inWishlist != null && inWishlist) ? "<i class='fa-solid fa-heart' style='color:var(--danger);'></i> In Wishlist" : "<i class='fa-regular fa-heart'></i> Add to Wishlist" %></button>
                </form>
            </div>
        </div>
    </div>

    <!-- Pet Care Guide Section -->
    <% if (pet.getCareGuide() != null || pet.getFoodGuide() != null || pet.getHealthTips() != null) { %>
    <div style="padding: 48px 0;" data-aos="fade-up">
        <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: 8px;">
            <i class="fa-solid fa-book-medical" style="color: var(--primary);"></i> Pet Care Guide — <%= pet.getPetName() %>
        </h2>
        <p style="color: var(--text-secondary); margin-bottom: 24px;">Everything you need to know to keep your pet happy and healthy</p>

        <div class="care-tabs">
            <button class="care-tab active" onclick="switchTab('overview')"><i class="fa-solid fa-clipboard-list"></i> Overview</button>
            <button class="care-tab" onclick="switchTab('food')"><i class="fa-solid fa-bowl-food"></i> Food & Nutrition</button>
            <button class="care-tab" onclick="switchTab('health')"><i class="fa-solid fa-heart-pulse"></i> Health Tips</button>
            <button class="care-tab" onclick="switchTab('dos')"><i class="fa-solid fa-check-circle"></i> Do's & Don'ts</button>
        </div>

        <!-- Overview Tab -->
        <div class="care-content active" id="tab-overview">
            <div class="guide-card">
                <h4><i class="fa-solid fa-clipboard-list" style="color: var(--primary);"></i> Care Overview</h4>
                <p><%= pet.getCareGuide() != null ? pet.getCareGuide() : "Care guide coming soon." %></p>
            </div>
        </div>

        <!-- Food Tab -->
        <div class="care-content" id="tab-food">
            <div class="guide-card">
                <h4><i class="fa-solid fa-bowl-food" style="color: var(--success);"></i> Food & Nutrition Guide</h4>
                <p><%= pet.getFoodGuide() != null ? pet.getFoodGuide() : "Nutrition guide coming soon." %></p>
            </div>
        </div>

        <!-- Health Tab -->
        <div class="care-content" id="tab-health">
            <div class="guide-card">
                <h4><i class="fa-solid fa-heart-pulse" style="color: var(--danger);"></i> Health Tips</h4>
                <p><%= pet.getHealthTips() != null ? pet.getHealthTips() : "Health tips coming soon." %></p>
            </div>
        </div>

        <!-- Do's & Don'ts Tab -->
        <div class="care-content" id="tab-dos">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="guide-card" style="border-left: 4px solid var(--success);">
                    <h4><i class="fa-solid fa-circle-check do-icon"></i> Do's</h4>
                    <ul class="guide-list">
                        <% for (String item : doItems) { %>
                            <li><i class="fa-solid fa-check do-icon"></i> <%= item.trim() %></li>
                        <% } %>
                        <% if (doItems.length == 0) { %><li>Care tips coming soon.</li><% } %>
                    </ul>
                </div>
                <div class="guide-card" style="border-left: 4px solid var(--danger);">
                    <h4><i class="fa-solid fa-circle-xmark dont-icon"></i> Don'ts</h4>
                    <ul class="guide-list">
                        <% for (String item : dontItems) { %>
                            <li><i class="fa-solid fa-xmark dont-icon"></i> <%= item.trim() %></li>
                        <% } %>
                        <% if (dontItems.length == 0) { %><li>Care tips coming soon.</li><% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Reviews Section -->
    <div style="padding: 40px 0;">
        <h2 style="font-size: 1.5rem; font-weight: 800; margin-bottom: 24px;"><i class="fa-solid fa-star" style="color:var(--accent);"></i> Reviews & Ratings</h2>

        <% if (userId != null) { %>
            <div class="review-card" style="background: var(--bg-secondary);" data-aos="fade-up">
                <h3 style="margin-bottom: 16px;">Write a Review</h3>
                <form method="post" action="<%= ctx %>/review/">
                    <input type="hidden" name="petId" value="<%= pet.getPetId() %>">
                    <div class="star-rating-input" style="margin-bottom: 12px; font-size: 1.5rem; cursor: pointer;">
                        <input type="hidden" name="rating" value="5">
                        <span class="star filled" data-value="1"><i class="fa-solid fa-star"></i></span>
                        <span class="star filled" data-value="2"><i class="fa-solid fa-star"></i></span>
                        <span class="star filled" data-value="3"><i class="fa-solid fa-star"></i></span>
                        <span class="star filled" data-value="4"><i class="fa-solid fa-star"></i></span>
                        <span class="star filled" data-value="5"><i class="fa-solid fa-star"></i></span>
                    </div>
                    <div class="form-group" style="margin-bottom: 12px; min-width: unset; flex: unset;">
                        <textarea name="reviewText" class="form-control" rows="3" placeholder="Share your experience with this pet..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-sm">Submit Review</button>
                </form>
            </div>
        <% } %>

        <% if (reviews != null && !reviews.isEmpty()) { %>
            <% for (Review review : reviews) { %>
                <div class="review-card" data-aos="fade-up">
                    <div class="review-header">
                        <div class="avatar"><%= review.getUserName().charAt(0) %></div>
                        <div class="review-meta">
                            <h4><%= review.getUserName() %></h4>
                            <div class="date"><%= review.getCreatedAt() %></div>
                        </div>
                        <div class="stars" style="margin-left: auto;">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <span class="star <%= i <= review.getRating() ? "filled" : "" %>"><i class="fa-solid fa-star"></i></span>
                            <% } %>
                        </div>
                    </div>
                    <p class="review-text"><%= review.getReviewText() %></p>
                </div>
            <% } %>
        <% } else { %>
            <p style="color: var(--text-light); text-align: center; padding: 24px;">No reviews yet. Be the first to review!</p>
        <% } %>
    </div>
</div>

<script>
    // Image Gallery
    function changeImage(thumb) {
        document.getElementById('mainImage').src = thumb.src;
        document.querySelectorAll('.thumb').forEach(t => t.classList.remove('active'));
        thumb.classList.add('active');
    }

    // Care Guide Tabs
    function switchTab(tabName) {
        document.querySelectorAll('.care-content').forEach(c => c.classList.remove('active'));
        document.querySelectorAll('.care-tab').forEach(t => t.classList.remove('active'));
        document.getElementById('tab-' + tabName).classList.add('active');
        event.target.closest('.care-tab').classList.add('active');
    }
</script>

<jsp:include page="/jsp/common/footer.jsp"/>
