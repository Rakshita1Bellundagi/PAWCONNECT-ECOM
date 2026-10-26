package com.pawconnect.servlet.user;

import com.pawconnect.dao.OrderDAO;
import com.pawconnect.dao.PaymentDAO;
import com.pawconnect.model.Order;
import com.pawconnect.model.Payment;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orders/*"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        String pathInfo = request.getPathInfo();

        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        if (pathInfo != null && pathInfo.length() > 1) {
            // View single order details
            try {
                int orderId = Integer.parseInt(pathInfo.substring(1));
                Order order = orderDAO.getOrderById(orderId);
                if (order != null && order.getUserId() == userId) {
                    Payment payment = paymentDAO.getPaymentByOrderId(orderId);
                    order.setPayment(payment);
                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/jsp/user/order-details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // ignore
            }
        }

        // List all orders
        List<Order> orders = orderDAO.getUserOrders(userId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/jsp/user/order-history.jsp").forward(request, response);
    }
}
