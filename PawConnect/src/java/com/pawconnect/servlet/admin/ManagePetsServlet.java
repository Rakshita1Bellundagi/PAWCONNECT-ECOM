package com.pawconnect.servlet.admin;

import com.pawconnect.dao.PetDAO;
import com.pawconnect.dao.CategoryDAO;
import com.pawconnect.model.Pet;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ManagePetsServlet", urlPatterns = {"/admin/pets"})
public class ManagePetsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        PetDAO petDAO = new PetDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("add".equals(action)) {
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/jsp/admin/add-pet.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("id"));
            Pet pet = petDAO.getPetById(petId);
            request.setAttribute("pet", pet);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/jsp/admin/edit-pet.jsp").forward(request, response);
        } else if ("delete".equals(action)) {
            int petId = Integer.parseInt(request.getParameter("id"));
            petDAO.deletePet(petId);
            response.sendRedirect(request.getContextPath() + "/admin/pets");
        } else {
            request.setAttribute("pets", petDAO.getAllPetsAdmin());
            request.getRequestDispatcher("/jsp/admin/manage-pets.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        PetDAO petDAO = new PetDAO();

        Pet pet = new Pet();
        pet.setPetName(request.getParameter("petName"));
        pet.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        pet.setBreed(request.getParameter("breed"));
        pet.setAge(request.getParameter("age"));
        pet.setGender(request.getParameter("gender"));
        pet.setColor(request.getParameter("color"));
        pet.setWeight(Double.parseDouble(request.getParameter("weight")));
        pet.setPrice(Double.parseDouble(request.getParameter("price")));
        pet.setDescription(request.getParameter("description"));
        pet.setHealthStatus(request.getParameter("healthStatus"));
        pet.setVaccinationStatus("true".equals(request.getParameter("vaccinationStatus")));
        pet.setLocation(request.getParameter("location"));
        pet.setImageUrl(request.getParameter("imageUrl"));
        pet.setImageUrl2(request.getParameter("imageUrl2"));
        pet.setCareGuide(request.getParameter("careGuide"));
        pet.setFoodGuide(request.getParameter("foodGuide"));
        pet.setHealthTips(request.getParameter("healthTips"));
        pet.setDoList(request.getParameter("doList"));
        pet.setDontList(request.getParameter("dontList"));

        if ("add".equals(action)) {
            petDAO.addPet(pet);
        } else if ("update".equals(action)) {
            pet.setPetId(Integer.parseInt(request.getParameter("petId")));
            pet.setAvailable("true".equals(request.getParameter("isAvailable")));
            petDAO.updatePet(pet);
        }

        response.sendRedirect(request.getContextPath() + "/admin/pets");
    }
}
