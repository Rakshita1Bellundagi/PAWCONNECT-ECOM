package com.pawconnect.servlet.user;

import com.pawconnect.dao.NotificationDAO;
import com.pawconnect.model.Notification;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications/*"})
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        NotificationDAO notificationDAO = new NotificationDAO();
        List<Notification> notifications = notificationDAO.getUserNotifications(userId);
        int unreadCount = notificationDAO.getUnreadCount(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/jsp/user/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        String action = request.getParameter("action");
        NotificationDAO notificationDAO = new NotificationDAO();

        if ("markRead".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("notificationId"));
            notificationDAO.markAsRead(notificationId, userId);
        } else if ("markAllRead".equals(action)) {
            notificationDAO.markAllAsRead(userId);
        }

        response.sendRedirect(request.getContextPath() + "/notifications/");
    }
}
