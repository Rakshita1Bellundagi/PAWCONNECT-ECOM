package com.pawconnect.servlet.user;

import com.pawconnect.dao.CartDAO;
import com.pawconnect.dao.UserDAO;
import com.pawconnect.model.CartItem;
import com.pawconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout/*"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        CartDAO cartDAO = new CartDAO();
        UserDAO userDAO = new UserDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }

        double cartTotal = cartDAO.getCartTotal(userId);
        User user = userDAO.getUserById(userId);

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/user/checkout.jsp").forward(request, response);
    }
}
