package com.pawconnect.servlet.user;

import com.pawconnect.dao.*;
import com.pawconnect.model.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment/*"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }

        double cartTotal = cartDAO.getCartTotal(userId);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        // Get shipping info from session
        request.setAttribute("shippingAddress", request.getSession().getAttribute("shippingAddress"));
        request.setAttribute("shippingCity", request.getSession().getAttribute("shippingCity"));
        request.setAttribute("shippingState", request.getSession().getAttribute("shippingState"));
        request.setAttribute("shippingPincode", request.getSession().getAttribute("shippingPincode"));

        request.getRequestDispatcher("/jsp/user/payment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        String action = request.getParameter("action");

        if ("saveShipping".equals(action)) {
            // Save shipping details and show payment page
            request.getSession().setAttribute("shippingAddress", request.getParameter("shippingAddress"));
            request.getSession().setAttribute("shippingCity", request.getParameter("shippingCity"));
            request.getSession().setAttribute("shippingState", request.getParameter("shippingState"));
            request.getSession().setAttribute("shippingPincode", request.getParameter("shippingPincode"));
            response.sendRedirect(request.getContextPath() + "/payment/");
            return;
        }

        // Process payment
        String paymentMethod = request.getParameter("paymentMethod");
        String cardNumber = request.getParameter("cardNumber");
        String upiId = request.getParameter("upiId");

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        NotificationDAO notificationDAO = new NotificationDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        double totalAmount = cartDAO.getCartTotal(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/browse");
            return;
        }

        // Create Order
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalAmount(totalAmount);
        order.setShippingAddress((String) request.getSession().getAttribute("shippingAddress"));
        order.setShippingCity((String) request.getSession().getAttribute("shippingCity"));
        order.setShippingState((String) request.getSession().getAttribute("shippingState"));
        order.setShippingPincode((String) request.getSession().getAttribute("shippingPincode"));

        int orderId = orderDAO.createOrder(order, cartItems);

        if (orderId > 0) {
            // Process Payment
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setUserId(userId);
            payment.setAmount(totalAmount);
            payment.setPaymentMethod(paymentMethod);
            payment.setTransactionId(paymentDAO.generateTransactionId());

            if (cardNumber != null && cardNumber.length() >= 4) {
                payment.setCardLastFour(cardNumber.substring(cardNumber.length() - 4));
            }
            if (upiId != null && !upiId.isEmpty()) {
                payment.setUpiId(upiId);
            }

            // Simulate payment processing (always succeeds for demo)
            payment.setPaymentStatus("Success");
            boolean paymentSuccess = paymentDAO.processPayment(payment);

            if (paymentSuccess) {
                // Update order status
                orderDAO.updateOrderStatus(orderId, "Confirmed");

                // Clear cart
                cartDAO.clearCart(userId);

                // Create notification
                notificationDAO.addNotification(userId, "Order Confirmed",
                    "Your order #" + orderId + " has been confirmed. Amount: ₹" + String.format("%.2f", totalAmount) +
                    ". Transaction ID: " + payment.getTransactionId(), "Order");

                notificationDAO.addNotification(userId, "Payment Successful",
                    "Payment of ₹" + String.format("%.2f", totalAmount) + " received via " + paymentMethod +
                    ". Transaction ID: " + payment.getTransactionId(), "Payment");

                // Clean session shipping data
                request.getSession().removeAttribute("shippingAddress");
                request.getSession().removeAttribute("shippingCity");
                request.getSession().removeAttribute("shippingState");
                request.getSession().removeAttribute("shippingPincode");

                request.setAttribute("order", orderDAO.getOrderById(orderId));
                request.setAttribute("payment", payment);
                request.getRequestDispatcher("/jsp/user/payment-success.jsp").forward(request, response);
            } else {
                payment.setPaymentStatus("Failed");
                request.setAttribute("orderId", orderId);
                request.setAttribute("error", "Payment processing failed. Please try again.");
                request.getRequestDispatcher("/jsp/user/payment-failure.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Order creation failed. Please try again.");
            request.getRequestDispatcher("/jsp/user/payment-failure.jsp").forward(request, response);
        }
    }
}
