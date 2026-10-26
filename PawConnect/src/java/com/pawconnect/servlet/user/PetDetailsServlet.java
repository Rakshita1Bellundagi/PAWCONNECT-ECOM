package com.pawconnect.servlet.user;

import com.pawconnect.dao.PetDAO;
import com.pawconnect.dao.ReviewDAO;
import com.pawconnect.dao.WishlistDAO;
import com.pawconnect.model.Pet;
import com.pawconnect.model.Review;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PetDetailsServlet", urlPatterns = {"/pet-details"})
public class PetDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String petIdStr = request.getParameter("id");
        if (petIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }

        int petId = Integer.parseInt(petIdStr);
        PetDAO petDAO = new PetDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        Pet pet = petDAO.getPetById(petId);

        if (pet == null) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }

        List<Review> reviews = reviewDAO.getReviewsByPetId(petId);

        // Check if in wishlist
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (Integer) session.getAttribute("userId");
            WishlistDAO wishlistDAO = new WishlistDAO();
            request.setAttribute("inWishlist", wishlistDAO.isInWishlist(userId, petId));
        }

        request.setAttribute("pet", pet);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/jsp/user/pet-details.jsp").forward(request, response);
    }
}
