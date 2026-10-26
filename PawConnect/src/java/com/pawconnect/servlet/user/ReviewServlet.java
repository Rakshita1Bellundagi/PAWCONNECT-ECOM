package com.pawconnect.servlet.user;

import com.pawconnect.dao.ReviewDAO;
import com.pawconnect.model.Review;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/review/*"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        int petId = Integer.parseInt(request.getParameter("petId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String reviewText = request.getParameter("reviewText");

        Review review = new Review();
        review.setUserId(userId);
        review.setPetId(petId);
        review.setRating(rating);
        review.setReviewText(reviewText);

        ReviewDAO reviewDAO = new ReviewDAO();
        reviewDAO.addReview(review);

        response.sendRedirect(request.getContextPath() + "/pet-details?id=" + petId);
    }
}
