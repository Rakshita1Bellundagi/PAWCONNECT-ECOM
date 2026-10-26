package com.pawconnect.servlet.admin;

import com.pawconnect.dao.CategoryDAO;
import com.pawconnect.model.Category;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ManageCategoriesServlet", urlPatterns = {"/admin/categories"})
public class ManageCategoriesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/jsp/admin/manage-categories.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("add".equals(action)) {
            Category cat = new Category();
            cat.setCategoryName(request.getParameter("categoryName"));
            cat.setDescription(request.getParameter("description"));
            cat.setImageUrl(request.getParameter("imageUrl"));
            categoryDAO.addCategory(cat);
        } else if ("update".equals(action)) {
            Category cat = new Category();
            cat.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            cat.setCategoryName(request.getParameter("categoryName"));
            cat.setDescription(request.getParameter("description"));
            cat.setImageUrl(request.getParameter("imageUrl"));
            categoryDAO.updateCategory(cat);
        } else if ("delete".equals(action)) {
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            categoryDAO.deleteCategory(categoryId);
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
