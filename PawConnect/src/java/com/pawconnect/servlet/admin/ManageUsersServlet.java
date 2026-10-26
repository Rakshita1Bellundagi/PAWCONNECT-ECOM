package com.pawconnect.servlet.admin;

import com.pawconnect.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ManageUsersServlet", urlPatterns = {"/admin/users"})
public class ManageUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher("/jsp/admin/manage-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("toggleStatus".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            boolean isActive = "true".equals(request.getParameter("isActive"));
            userDAO.toggleUserStatus(userId, !isActive);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
