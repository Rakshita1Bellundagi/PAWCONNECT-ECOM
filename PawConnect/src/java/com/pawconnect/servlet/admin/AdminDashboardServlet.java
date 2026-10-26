package com.pawconnect.servlet.admin;

import com.pawconnect.dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PetDAO petDAO = new PetDAO();
        UserDAO userDAO = new UserDAO();
        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        request.setAttribute("totalPets", petDAO.getTotalPets());
        request.setAttribute("totalUsers", userDAO.getTotalUsers());
        request.setAttribute("totalOrders", orderDAO.getTotalOrders());
        request.setAttribute("totalRevenue", paymentDAO.getTotalRevenue());

        // Process monthly revenue logic (Last 6 months)
        java.util.List<com.pawconnect.model.Payment> allPayments = paymentDAO.getAllPayments();
        double[] monthlyRevenue = new double[6];
        String[] monthLabels = new String[6];
        
        java.util.Calendar cal = java.util.Calendar.getInstance();
        java.text.SimpleDateFormat monthFormat = new java.text.SimpleDateFormat("MMM yy");
        
        for (int i = 5; i >= 0; i--) {
            monthLabels[i] = monthFormat.format(cal.getTime());
            
            // Calculate revenue for this month
            double monthTotal = 0;
            for (com.pawconnect.model.Payment p : allPayments) {
                if ("Completed".equals(p.getPaymentStatus()) || "Success".equals(p.getPaymentStatus())) {
                    java.util.Calendar pCal = java.util.Calendar.getInstance();
                    pCal.setTimeInMillis(p.getPaymentDate().getTime());
                    if (pCal.get(java.util.Calendar.YEAR) == cal.get(java.util.Calendar.YEAR) &&
                        pCal.get(java.util.Calendar.MONTH) == cal.get(java.util.Calendar.MONTH)) {
                        monthTotal += p.getAmount();
                    }
                }
            }
            monthlyRevenue[i] = monthTotal;
            cal.add(java.util.Calendar.MONTH, -1);
        }
        
        StringBuilder labelsJson = new StringBuilder("[");
        StringBuilder dataJson = new StringBuilder("[");
        for (int i = 0; i < 6; i++) {
            labelsJson.append("\"").append(monthLabels[i]).append("\"");
            dataJson.append(monthlyRevenue[i]);
            if (i < 5) {
                labelsJson.append(",");
                dataJson.append(",");
            }
        }
        labelsJson.append("]");
        dataJson.append("]");
        
        request.setAttribute("monthLabels", labelsJson.toString());
        request.setAttribute("monthlyRevenueData", dataJson.toString());

        // Recent orders
        request.setAttribute("recentOrders", orderDAO.getAllOrders());

        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }
}
