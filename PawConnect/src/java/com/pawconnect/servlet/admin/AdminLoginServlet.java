package com.pawconnect.servlet.admin;

import com.pawconnect.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminLoginServlet", urlPatterns = {"/admin/login"})
public class AdminLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminId") != null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        request.getRequestDispatcher("/jsp/admin/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        String[] adminData = userDAO.adminLogin(username, password);

        if (adminData != null) {
            HttpSession session = request.getSession();
            session.setAttribute("adminId", Integer.parseInt(adminData[0]));
            session.setAttribute("adminUsername", adminData[1]);
            session.setAttribute("adminName", adminData[2]);
            session.setAttribute("adminEmail", adminData[3]);
            session.setAttribute("adminRole", adminData[4]);
            session.setMaxInactiveInterval(60 * 60); // 1 hour

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("/jsp/admin/admin-login.jsp").forward(request, response);
        }
    }
}
