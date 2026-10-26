package com.pawconnect.dao;

import com.pawconnect.model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (user_id, pet_id, rating, review_text) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getPetId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getReviewText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Review> getReviewsByPetId(int petId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as user_name, u.profile_image as user_profile_image " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.pet_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, petId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                reviews.add(mapReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as user_name, u.profile_image as user_profile_image, p.pet_name " +
                     "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
                     "JOIN pets p ON r.pet_id = p.pet_id ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Review review = mapReview(rs);
                review.setPetName(rs.getString("pet_name"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    public boolean deleteReview(int reviewId) {
        String sql = "DELETE FROM reviews WHERE review_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Review mapReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getInt("review_id"));
        review.setUserId(rs.getInt("user_id"));
        review.setPetId(rs.getInt("pet_id"));
        review.setRating(rs.getInt("rating"));
        review.setReviewText(rs.getString("review_text"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUserName(rs.getString("user_name"));
        review.setUserProfileImage(rs.getString("user_profile_image"));
        return review;
    }
}
