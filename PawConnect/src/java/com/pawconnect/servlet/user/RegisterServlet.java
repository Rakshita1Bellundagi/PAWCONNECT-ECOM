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
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }
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

        // Clean & normalize inputs
        fullName = fullName != null ? fullName.trim() : "";
        email = email != null ? email.trim().toLowerCase() : "";
        phone = phone != null ? phone.trim() : "";
        address = address != null ? address.trim() : "";
        city = city != null ? city.trim() : "";
        state = state != null ? state.trim() : "";
        pincode = pincode != null ? pincode.trim() : "";

        // Preserve input values for re-display on error
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.setAttribute("city", city);
        request.setAttribute("state", state);
        request.setAttribute("pincode", pincode);

        // Validations
        if (fullName.isEmpty()) {
            request.setAttribute("error", "Full name is required!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (email.isEmpty() || !email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email address!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        if (confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "An account with this email is already registered! Please sign in.");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone.isEmpty() ? null : phone);
        user.setAddress(address.isEmpty() ? null : address);
        user.setCity(city.isEmpty() ? null : city);
        user.setState(state.isEmpty() ? null : state);
        user.setPincode(pincode.isEmpty() ? null : pincode);

        try {
            if (latitudeStr != null && !latitudeStr.trim().isEmpty()) {
                user.setLatitude(Double.parseDouble(latitudeStr.trim()));
            }
            if (longitudeStr != null && !longitudeStr.trim().isEmpty()) {
                user.setLongitude(Double.parseDouble(longitudeStr.trim()));
            }
        } catch (NumberFormatException e) {
            // Ignore invalid coordinates
        }

        if (userDAO.register(user)) {
            // Auto-login after successful registration
            User loggedInUser = userDAO.login(email, password);
            if (loggedInUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", loggedInUser.getUserId());
                session.setAttribute("userName", loggedInUser.getFullName());
                session.setAttribute("userEmail", loggedInUser.getEmail());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                response.sendRedirect(request.getContextPath() + "/browse");
            } else {
                request.setAttribute("success", "Registration successful! Please sign in.");
                request.getRequestDispatcher("/jsp/user/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Registration failed! Please check your information and try again.");
            request.getRequestDispatcher("/jsp/user/register.jsp").forward(request, response);
        }
    }
}
