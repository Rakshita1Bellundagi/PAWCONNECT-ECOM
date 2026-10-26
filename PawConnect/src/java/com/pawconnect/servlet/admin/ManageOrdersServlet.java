package com.pawconnect.servlet.admin;

import com.pawconnect.dao.OrderDAO;
import com.pawconnect.dao.PaymentDAO;
import com.pawconnect.model.Order;
import com.pawconnect.model.Payment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ManageOrdersServlet", urlPatterns = {"/admin/orders"})
public class ManageOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        OrderDAO orderDAO = new OrderDAO();

        if ("view".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            Order order = orderDAO.getOrderById(orderId);
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = paymentDAO.getPaymentByOrderId(orderId);
            order.setPayment(payment);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/jsp/admin/order-details.jsp").forward(request, response);
        } else {
            request.setAttribute("orders", orderDAO.getAllOrders());
            request.getRequestDispatcher("/jsp/admin/manage-orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        OrderDAO orderDAO = new OrderDAO();

        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            orderDAO.updateOrderStatus(orderId, status);
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        } else if ("sendBillAlert".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            com.pawconnect.dao.NotificationDAO notifDAO = new com.pawconnect.dao.NotificationDAO();
            notifDAO.addNotification(userId, "Bill Available", "Your official bill for Order #" + orderId + " is ready to download.", "bill");
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
        } else if ("markPaymentCompleted".equals(action)) {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            PaymentDAO paymentDAO = new PaymentDAO();
            paymentDAO.updatePaymentStatus(paymentId, "Completed");
            response.sendRedirect(request.getContextPath() + "/admin/orders?action=view&id=" + orderId);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
