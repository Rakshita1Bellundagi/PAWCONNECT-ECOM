package com.pawconnect.servlet.user;

import com.pawconnect.dao.UserDAO;
import com.pawconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String pincode = request.getParameter("pincode");

        String latitudeStr = request.getParameter("latitude");
        String longitudeStr = request.getParameter("longitude");

        UserDAO userDAO = new UserDAO();

        // Validation
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match or are empty!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty() || userDAO.emailExists(email)) {
            request.setAttribute("error", "Invalid email or already registered!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);
        user.setCity(city);
        user.setState(state);
        user.setPincode(pincode);
        
        try {
            if (latitudeStr != null && !latitudeStr.isEmpty()) user.setLatitude(Double.parseDouble(latitudeStr));
            if (longitudeStr != null && !longitudeStr.isEmpty()) user.setLongitude(Double.parseDouble(longitudeStr));
        } catch (NumberFormatException e) {
            // ignore invalid coordinates
        }

        if (userDAO.register(user)) {
            // Auto login after registration
            User loggedInUser = userDAO.login(email, password);
            if (loggedInUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", loggedInUser.getUserId());
                session.setAttribute("userName", loggedInUser.getFullName());
                session.setAttribute("userEmail", loggedInUser.getEmail());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                response.sendRedirect(request.getContextPath() + "/browse");
            } else {
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
        }
    }
}
