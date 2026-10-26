package com.pawconnect.servlet.admin;

import com.pawconnect.dao.OrderDAO;
import com.pawconnect.dao.UserDAO;
import com.pawconnect.model.Order;
import com.pawconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "DataExportServlet", urlPatterns = {"/admin/export"})
public class DataExportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        
        if ("orders".equals(type)) {
            exportOrders(response);
        } else if ("users".equals(type)) {
            exportUsers(response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid export type");
        }
    }

    private void exportOrders(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"orders_export.csv\"");

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getAllOrders();

        PrintWriter writer = response.getWriter();
        writer.println("Order ID,Customer Name,Customer Email,Total Amount,Status,Date,Shipping City");

        for (Order order : orders) {
            writer.printf("%d,\"%s\",\"%s\",%.2f,\"%s\",\"%s\",\"%s\"\n",
                    order.getOrderId(),
                    order.getUserName() != null ? order.getUserName() : "",
                    order.getUserEmail() != null ? order.getUserEmail() : "",
                    order.getTotalAmount(),
                    order.getOrderStatus(),
                    order.getOrderDate(),
                    order.getShippingCity() != null ? order.getShippingCity() : ""
            );
        }
    }

    private void exportUsers(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_export.csv\"");

        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();

        PrintWriter writer = response.getWriter();
        writer.println("User ID,Full Name,Email,Phone,Status,Join Date");

        for (User user : users) {
            writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"\n",
                    user.getUserId(),
                    user.getFullName() != null ? user.getFullName() : "",
                    user.getEmail() != null ? user.getEmail() : "",
                    user.getPhone() != null ? user.getPhone() : "",
                    user.isActive() ? "Active" : "Inactive",
                    user.getCreatedAt()
            );
        }
    }
}
