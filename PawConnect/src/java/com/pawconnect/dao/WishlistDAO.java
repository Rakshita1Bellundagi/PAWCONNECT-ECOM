package com.pawconnect.dao;

import com.pawconnect.model.WishlistItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean addToWishlist(int userId, int petId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, pet_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(int wishlistId, int userId) {
        String sql = "DELETE FROM wishlist WHERE wishlist_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wishlistId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<WishlistItem> getWishlistItems(int userId) {
        List<WishlistItem> items = new ArrayList<>();
        String sql = "SELECT w.*, p.pet_name, p.breed, p.price, p.image_url, p.is_available, c.category_name " +
                     "FROM wishlist w JOIN pets p ON w.pet_id = p.pet_id " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE w.user_id = ? ORDER BY w.added_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WishlistItem item = new WishlistItem();
                item.setWishlistId(rs.getInt("wishlist_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setPetId(rs.getInt("pet_id"));
                item.setAddedAt(rs.getTimestamp("added_at"));
                item.setPetName(rs.getString("pet_name"));
                item.setBreed(rs.getString("breed"));
                item.setPrice(rs.getDouble("price"));
                item.setImageUrl(rs.getString("image_url"));
                item.setAvailable(rs.getBoolean("is_available"));
                item.setCategoryName(rs.getString("category_name"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public int getWishlistCount(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isInWishlist(int userId, int petId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND pet_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, petId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
