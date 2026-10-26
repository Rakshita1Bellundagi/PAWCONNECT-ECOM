package com.pawconnect.servlet.user;

import com.pawconnect.dao.WishlistDAO;
import com.pawconnect.model.WishlistItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist/*"})
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        WishlistDAO wishlistDAO = new WishlistDAO();
        List<WishlistItem> items = wishlistDAO.getWishlistItems(userId);
        request.setAttribute("wishlistItems", items);
        request.getRequestDispatcher("/jsp/user/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        String action = request.getParameter("action");
        WishlistDAO wishlistDAO = new WishlistDAO();

        if ("add".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("petId"));
            wishlistDAO.addToWishlist(userId, petId);
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/browse");
        } else if ("remove".equals(action)) {
            int wishlistId = Integer.parseInt(request.getParameter("wishlistId"));
            wishlistDAO.removeFromWishlist(wishlistId, userId);
            response.sendRedirect(request.getContextPath() + "/wishlist/");
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist/");
        }
    }
}
