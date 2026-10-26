package com.pawconnect.servlet.user;

import com.pawconnect.dao.UserDAO;
import com.pawconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/user/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        
        User user = new User();
        user.setUserId(userId);
        user.setFullName(request.getParameter("fullName"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setCity(request.getParameter("city"));
        user.setState(request.getParameter("state"));
        user.setPincode(request.getParameter("pincode"));
        
        String latStr = request.getParameter("latitude");
        String lngStr = request.getParameter("longitude");
        if (latStr != null && !latStr.trim().isEmpty() && lngStr != null && !lngStr.trim().isEmpty()) {
            try {
                user.setLatitude(Double.parseDouble(latStr));
                user.setLongitude(Double.parseDouble(lngStr));
            } catch (NumberFormatException ignored) {}
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.updateUser(user)) {
            request.getSession().setAttribute("userName", user.getFullName());
            request.setAttribute("success", "Profile updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update profile!");
        }

        user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/user/profile.jsp").forward(request, response);
    }
}
