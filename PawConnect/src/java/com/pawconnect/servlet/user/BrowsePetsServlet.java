package com.pawconnect.servlet.user;

import com.pawconnect.dao.PetDAO;
import com.pawconnect.dao.CategoryDAO;
import com.pawconnect.model.Pet;
import com.pawconnect.model.Category;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BrowsePetsServlet", urlPatterns = { "/browse" })
public class BrowsePetsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PetDAO petDAO = new PetDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String keyword = request.getParameter("keyword");
        String categoryParam = request.getParameter("category");
        String location = request.getParameter("location");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String gender = request.getParameter("gender");

        int categoryId = 0;
        double minPrice = 0;
        double maxPrice = 0;

        try {
            if (categoryParam != null && !categoryParam.isEmpty())
                categoryId = Integer.parseInt(categoryParam);
            if (minPriceStr != null && !minPriceStr.isEmpty())
                minPrice = Double.parseDouble(minPriceStr);
            if (maxPriceStr != null && !maxPriceStr.isEmpty())
                maxPrice = Double.parseDouble(maxPriceStr);
        } catch (NumberFormatException e) {
            // Ignore
        }

        boolean hasFilter = (keyword != null && !keyword.trim().isEmpty())
                || categoryId > 0
                || (location != null && !location.trim().isEmpty() && !location.equalsIgnoreCase("All"))
                || minPrice > 0
                || (maxPriceStr != null && !maxPriceStr.trim().isEmpty() && maxPrice > 0 && maxPrice < 99999)
                || (gender != null && !gender.trim().isEmpty() && !gender.equalsIgnoreCase("All"));

        List<Pet> pets;
        if (hasFilter) {
            pets = petDAO.searchPets(keyword, categoryId, location, minPrice, maxPrice, gender);
        } else {
            pets = petDAO.getAllPets();
        }

        List<Category> categories = categoryDAO.getAllCategories();
        List<String> locations = petDAO.getAllLocations();

        request.setAttribute("pets", pets);
        request.setAttribute("categories", categories);
        request.setAttribute("locations", locations);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedLocation", location);
        request.setAttribute("minPrice", minPriceStr);
        request.setAttribute("maxPrice", maxPriceStr);
        request.setAttribute("selectedGender", gender);

        request.getRequestDispatcher("/jsp/user/browse-pets.jsp").forward(request, response);
    }
}
