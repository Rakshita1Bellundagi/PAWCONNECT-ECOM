package com.pawconnect.servlet.admin;

import com.pawconnect.dao.PaymentDAO;
import com.pawconnect.dao.ReviewDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ViewTransactionsServlet", urlPatterns = {"/admin/transactions", "/admin/reviews"})
public class ViewTransactionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.endsWith("/transactions")) {
            PaymentDAO paymentDAO = new PaymentDAO();
            request.setAttribute("payments", paymentDAO.getAllPayments());
            request.setAttribute("totalRevenue", paymentDAO.getTotalRevenue());
            request.getRequestDispatcher("/jsp/admin/view-transactions.jsp").forward(request, response);
        } else if (uri.endsWith("/reviews")) {
            ReviewDAO reviewDAO = new ReviewDAO();
            request.setAttribute("reviews", reviewDAO.getAllReviews());
            request.getRequestDispatcher("/jsp/admin/view-reviews.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("deleteReview".equals(action)) {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            ReviewDAO reviewDAO = new ReviewDAO();
            reviewDAO.deleteReview(reviewId);
            response.sendRedirect(request.getContextPath() + "/admin/reviews");
        }
    }
}
