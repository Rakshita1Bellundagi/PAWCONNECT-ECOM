package com.pawconnect.servlet.user;

import com.pawconnect.dao.CartDAO;
import com.pawconnect.model.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart/*"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        CartDAO cartDAO = new CartDAO();
        List<CartItem> items = cartDAO.getCartItems(userId);
        double total = cartDAO.getCartTotal(userId);

        request.setAttribute("cartItems", items);
        request.setAttribute("cartTotal", total);
        request.getRequestDispatcher("/jsp/user/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        String action = request.getParameter("action");
        CartDAO cartDAO = new CartDAO();

        if ("add".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("petId"));
            cartDAO.addToCart(userId, petId);
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/browse");
        } else if ("remove".equals(action)) {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            cartDAO.removeFromCart(cartId, userId);
            response.sendRedirect(request.getContextPath() + "/cart/");
        } else if ("clear".equals(action)) {
            cartDAO.clearCart(userId);
            response.sendRedirect(request.getContextPath() + "/cart/");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart/");
        }
    }
}
