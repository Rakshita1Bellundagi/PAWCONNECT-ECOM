<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/jsp/common/header.jsp"><jsp:param name="pageTitle" value="Pet Care Tips"/></jsp:include>
<%
    String ctx = request.getContextPath();
%>
<div class="page-header"><div class="container"><h1><i class="fa-solid fa-book"></i> Pet Care Tips</h1><p class="breadcrumb"><a href="<%= ctx %>/">Home</a> / Pet Care Tips</p></div></div>
<div class="container" style="max-width: 800px;">
<div class="tip-card"><span class="category-tag">Dogs</span><h3>How to Choose the Right Dog Breed</h3><p>Choosing the right dog breed depends on your lifestyle, living space, and activity level. Active families should consider breeds like Labradors or Golden Retrievers. For apartment living, small breeds like Pugs or Shih Tzus are ideal.</p></div>
<div class="tip-card"><span class="category-tag">Cats</span><h3>Essential Cat Care Tips for New Owners</h3><p>New cat owners should ensure they have a litter box, scratching post, and proper food bowls ready. Cats need regular vet check-ups, proper nutrition, and mental stimulation.</p></div>
<div class="tip-card"><span class="category-tag">Fish</span><h3>Setting Up Your First Aquarium</h3><p>Start with a tank of at least 20 gallons for beginners. Cycle your tank for 4-6 weeks before adding fish. Invest in a good filter, heater, and thermometer.</p></div>
<div class="tip-card"><span class="category-tag">Birds</span><h3>Bird Nutrition: What to Feed Your Feathered Friend</h3><p>A balanced bird diet includes quality seed mix, fresh fruits, and vegetables. Avoid avocado, chocolate, and caffeine as they are toxic to birds.</p></div>
<div class="tip-card"><span class="category-tag">Dogs</span><h3>Vaccination Schedule for Puppies</h3><p>Puppies need their first vaccines at 6-8 weeks of age, followed by boosters every 3-4 weeks until 16 weeks old. Core vaccines include Distemper, Parvovirus, Hepatitis, and Rabies.</p></div>
<div class="tip-card"><span class="category-tag">General</span><h3>Signs Your Pet Needs a Vet Visit</h3><p>Watch for: loss of appetite, lethargy, vomiting, difficulty breathing, excessive thirst, sudden weight loss, lumps, limping, behavioral changes, and discharge from eyes or nose.</p></div>
<div class="tip-card"><span class="category-tag">Rabbits</span><h3>Rabbit Care 101: Housing and Diet</h3><p>Rabbits need spacious enclosures with room to hop. Hay should make up 80% of their diet, supplemented with fresh vegetables and pellets. Provide exercise time daily.</p></div>
<div class="tip-card"><span class="category-tag">Dogs</span><h3>Grooming Your Dog at Home</h3><p>Regular grooming keeps your dog healthy. Brush 2-3 times per week, trim nails every 2-3 weeks, clean ears weekly, and bathe monthly. Use dog-specific products only.</p></div>
</div>
<jsp:include page="/jsp/common/footer.jsp"/>
