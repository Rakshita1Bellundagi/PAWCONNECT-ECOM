package com.pawconnect.dao;

import com.pawconnect.model.Pet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PetDAO {

    public List<Pet> getAllPets() {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.pet_id = r.pet_id " +
                     "WHERE p.is_available = TRUE GROUP BY p.pet_id, c.category_name ORDER BY p.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                pets.add(mapPet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pets;
    }

    public List<Pet> getAllPetsAdmin() {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.pet_id = r.pet_id " +
                     "GROUP BY p.pet_id, c.category_name ORDER BY p.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                pets.add(mapPet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pets;
    }

    public Pet getPetById(int petId) {
        String sql = "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.pet_id = r.pet_id " +
                     "WHERE p.pet_id = ? GROUP BY p.pet_id, c.category_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, petId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapPet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Pet> searchPets(String keyword, int categoryId, String location, double minPrice, double maxPrice, String gender) {
        List<Pet> pets = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
            "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
            "LEFT JOIN reviews r ON p.pet_id = r.pet_id WHERE p.is_available = TRUE ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (p.pet_name LIKE ? OR p.breed LIKE ? OR p.description LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw); params.add(kw); params.add(kw);
        }
        if (categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }
        if (location != null && !location.trim().isEmpty() && !location.equalsIgnoreCase("All") && !location.equalsIgnoreCase("All Locations")) {
            sql.append("AND p.location = ? ");
            params.add(location.trim());
        }
        if (minPrice > 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }
        if (gender != null && !gender.trim().isEmpty() && !gender.equalsIgnoreCase("All")) {
            sql.append("AND p.gender = ? ");
            params.add(gender.trim());
        }

        sql.append("GROUP BY p.pet_id, c.category_name ORDER BY p.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                pets.add(mapPet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pets;
    }

    public List<Pet> getPetsByCategory(int categoryId) {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.pet_id = r.pet_id " +
                     "WHERE p.category_id = ? AND p.is_available = TRUE GROUP BY p.pet_id, c.category_name ORDER BY p.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                pets.add(mapPet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pets;
    }

    public List<Pet> getFeaturedPets(int limit) {
        List<Pet> pets = new ArrayList<>();
        String sql = "SELECT p.*, c.category_name, COALESCE(AVG(r.rating), 0) as avg_rating, COUNT(r.review_id) as review_count " +
                     "FROM pets p LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "LEFT JOIN reviews r ON p.pet_id = r.pet_id " +
                     "WHERE p.is_available = TRUE GROUP BY p.pet_id, c.category_name ORDER BY avg_rating DESC, p.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                pets.add(mapPet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pets;
    }

    public boolean addPet(Pet pet) {
        String sql = "INSERT INTO pets (pet_name, category_id, breed, age, gender, color, weight, price, description, health_status, vaccination_status, location, image_url, image_url_2, care_guide, food_guide, health_tips, do_list, dont_list) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pet.getPetName());
            ps.setInt(2, pet.getCategoryId());
            ps.setString(3, pet.getBreed());
            ps.setString(4, pet.getAge());
            ps.setString(5, pet.getGender());
            ps.setString(6, pet.getColor());
            ps.setDouble(7, pet.getWeight());
            ps.setDouble(8, pet.getPrice());
            ps.setString(9, pet.getDescription());
            ps.setString(10, pet.getHealthStatus());
            ps.setBoolean(11, pet.isVaccinationStatus());
            ps.setString(12, pet.getLocation());
            ps.setString(13, pet.getImageUrl());
            ps.setString(14, pet.getImageUrl2());
            ps.setString(15, pet.getCareGuide());
            ps.setString(16, pet.getFoodGuide());
            ps.setString(17, pet.getHealthTips());
            ps.setString(18, pet.getDoList());
            ps.setString(19, pet.getDontList());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePet(Pet pet) {
        String sql = "UPDATE pets SET pet_name=?, category_id=?, breed=?, age=?, gender=?, color=?, weight=?, price=?, description=?, health_status=?, vaccination_status=?, location=?, image_url=?, image_url_2=?, care_guide=?, food_guide=?, health_tips=?, do_list=?, dont_list=?, is_available=? WHERE pet_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pet.getPetName());
            ps.setInt(2, pet.getCategoryId());
            ps.setString(3, pet.getBreed());
            ps.setString(4, pet.getAge());
            ps.setString(5, pet.getGender());
            ps.setString(6, pet.getColor());
            ps.setDouble(7, pet.getWeight());
            ps.setDouble(8, pet.getPrice());
            ps.setString(9, pet.getDescription());
            ps.setString(10, pet.getHealthStatus());
            ps.setBoolean(11, pet.isVaccinationStatus());
            ps.setString(12, pet.getLocation());
            ps.setString(13, pet.getImageUrl());
            ps.setString(14, pet.getImageUrl2());
            ps.setString(15, pet.getCareGuide());
            ps.setString(16, pet.getFoodGuide());
            ps.setString(17, pet.getHealthTips());
            ps.setString(18, pet.getDoList());
            ps.setString(19, pet.getDontList());
            ps.setBoolean(20, pet.isAvailable());
            ps.setInt(21, pet.getPetId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePet(int petId) {
        String sql = "DELETE FROM pets WHERE pet_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, petId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalPets() {
        String sql = "SELECT COUNT(*) FROM pets";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<String> getAllLocations() {
        List<String> locations = new ArrayList<>();
        String sql = "SELECT DISTINCT location FROM pets WHERE location IS NOT NULL ORDER BY location";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                locations.add(rs.getString("location"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return locations;
    }

    private Pet mapPet(ResultSet rs) throws SQLException {
        Pet pet = new Pet();
        pet.setPetId(rs.getInt("pet_id"));
        pet.setPetName(rs.getString("pet_name"));
        pet.setCategoryId(rs.getInt("category_id"));
        pet.setCategoryName(rs.getString("category_name"));
        pet.setBreed(rs.getString("breed"));
        pet.setAge(rs.getString("age"));
        pet.setGender(rs.getString("gender"));
        pet.setColor(rs.getString("color"));
        pet.setWeight(rs.getDouble("weight"));
        pet.setPrice(rs.getDouble("price"));
        pet.setDescription(rs.getString("description"));
        pet.setHealthStatus(rs.getString("health_status"));
        pet.setVaccinationStatus(rs.getBoolean("vaccination_status"));
        pet.setLocation(rs.getString("location"));
        pet.setImageUrl(rs.getString("image_url"));
        pet.setAvailable(rs.getBoolean("is_available"));
        pet.setCreatedAt(rs.getTimestamp("created_at"));
        pet.setAvgRating(rs.getDouble("avg_rating"));
        pet.setReviewCount(rs.getInt("review_count"));
        // New fields - safe read with fallback
        try {
            pet.setImageUrl2(rs.getString("image_url_2"));
            pet.setCareGuide(rs.getString("care_guide"));
            pet.setFoodGuide(rs.getString("food_guide"));
            pet.setHealthTips(rs.getString("health_tips"));
            pet.setDoList(rs.getString("do_list"));
            pet.setDontList(rs.getString("dont_list"));
        } catch (SQLException e) {
            // Columns may not exist yet if DB upgrade hasn't been run
        }
        return pet;
    }
}
