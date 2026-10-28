package com.pawconnect.dao;

import com.pawconnect.model.User;
import com.pawconnect.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static volatile boolean columnsEnsured = false;

    /**
     * Best-effort check to make sure latitude & longitude columns exist in users table.
     */
    private static void ensureUserColumnsExist() {
        if (columnsEnsured) return;
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            try {
                st.execute("ALTER TABLE users ADD COLUMN latitude DOUBLE");
            } catch (Exception ignored) {}
            try {
                st.execute("ALTER TABLE users ADD COLUMN longitude DOUBLE");
            } catch (Exception ignored) {}
            columnsEnsured = true;
        } catch (Exception ignored) {}
    }

    public User login(String email, String password) {
        if (email == null || password == null) return null;
        String cleanEmail = email.trim();
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Support both MD5 hash and legacy/seed plain-text password, case-insensitive email,
        // and is_active check (TRUE, 1, or default NULL).
        String sql = "SELECT * FROM users " +
                     "WHERE LOWER(TRIM(email)) = LOWER(?) " +
                     "AND (password = ? OR password = ?) " +
                     "AND (is_active = TRUE OR is_active = 1 OR is_active IS NULL)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cleanEmail);
            ps.setString(2, hashedPassword);
            ps.setString(3, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = mapUser(rs);
                // If stored password was plain text, silently upgrade to hash
                String storedPwd = rs.getString("password");
                if (password.equals(storedPwd) && !hashedPassword.equals(storedPwd)) {
                    try {
                        updatePassword(user.getUserId(), password);
                    } catch (Exception ignored) {}
                }
                return user;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.login] Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(User user) {
        if (user == null || user.getEmail() == null || user.getPassword() == null) return false;
        ensureUserColumnsExist();

        String cleanEmail = user.getEmail().trim().toLowerCase();
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());

        String sqlWithCoords = "INSERT INTO users (full_name, email, password, phone, address, city, state, pincode, is_active, latitude, longitude) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?, TRUE, ?, ?)";
        String sqlWithoutCoords = "INSERT INTO users (full_name, email, password, phone, address, city, state, pincode, is_active) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, TRUE)";

        try (Connection conn = DBConnection.getConnection()) {
            // First attempt with coordinates
            try (PreparedStatement ps = conn.prepareStatement(sqlWithCoords)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, cleanEmail);
                ps.setString(3, hashedPassword);
                ps.setString(4, user.getPhone());
                ps.setString(5, user.getAddress());
                ps.setString(6, user.getCity());
                ps.setString(7, user.getState());
                ps.setString(8, user.getPincode());
                if (user.getLatitude() != null) {
                    ps.setDouble(9, user.getLatitude());
                } else {
                    ps.setNull(9, java.sql.Types.DOUBLE);
                }
                if (user.getLongitude() != null) {
                    ps.setDouble(10, user.getLongitude());
                } else {
                    ps.setNull(10, java.sql.Types.DOUBLE);
                }
                return ps.executeUpdate() > 0;
            } catch (SQLException ex) {
                System.err.println("[UserDAO.register] Primary insert with coordinates failed, attempting fallback without coordinates: " + ex.getMessage());
                // Fallback attempt without coordinates
                try (PreparedStatement ps2 = conn.prepareStatement(sqlWithoutCoords)) {
                    ps2.setString(1, user.getFullName());
                    ps2.setString(2, cleanEmail);
                    ps2.setString(3, hashedPassword);
                    ps2.setString(4, user.getPhone());
                    ps2.setString(5, user.getAddress());
                    ps2.setString(6, user.getCity());
                    ps2.setString(7, user.getState());
                    ps2.setString(8, user.getPincode());
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO.register] Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        ensureUserColumnsExist();
        String sqlWithCoords = "UPDATE users SET full_name=?, phone=?, address=?, city=?, state=?, pincode=?, latitude=?, longitude=? WHERE user_id=?";
        String sqlWithoutCoords = "UPDATE users SET full_name=?, phone=?, address=?, city=?, state=?, pincode=? WHERE user_id=?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlWithCoords)) {
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getPhone());
                ps.setString(3, user.getAddress());
                ps.setString(4, user.getCity());
                ps.setString(5, user.getState());
                ps.setString(6, user.getPincode());
                if (user.getLatitude() != null) {
                    ps.setDouble(7, user.getLatitude());
                } else {
                    ps.setNull(7, java.sql.Types.DOUBLE);
                }
                if (user.getLongitude() != null) {
                    ps.setDouble(8, user.getLongitude());
                } else {
                    ps.setNull(8, java.sql.Types.DOUBLE);
                }
                ps.setInt(9, user.getUserId());
                return ps.executeUpdate() > 0;
            } catch (SQLException ex) {
                System.err.println("[UserDAO.updateUser] Primary update failed, fallback without coords: " + ex.getMessage());
                try (PreparedStatement ps2 = conn.prepareStatement(sqlWithoutCoords)) {
                    ps2.setString(1, user.getFullName());
                    ps2.setString(2, user.getPhone());
                    ps2.setString(3, user.getAddress());
                    ps2.setString(4, user.getCity());
                    ps2.setString(5, user.getState());
                    ps2.setString(6, user.getPincode());
                    ps2.setInt(7, user.getUserId());
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hashPassword(newPassword));
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM users WHERE LOWER(TRIM(email)) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Checks user active status. Returns:
     * - Boolean.TRUE if active
     * - Boolean.FALSE if deactivated
     * - null if user does not exist
     */
    public Boolean checkUserActiveStatus(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        String sql = "SELECT is_active FROM users WHERE LOWER(TRIM(email)) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("is_active");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean toggleUserStatus(int userId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Admin login
    public String[] adminLogin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new String[]{
                    String.valueOf(rs.getInt("admin_id")),
                    rs.getString("username"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("role")
                };
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setCity(rs.getString("city"));
        user.setState(rs.getString("state"));
        user.setPincode(rs.getString("pincode"));
        user.setProfileImage(rs.getString("profile_image"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            double lat = rs.getDouble("latitude");
            if (!rs.wasNull()) user.setLatitude(lat);

            double lng = rs.getDouble("longitude");
            if (!rs.wasNull()) user.setLongitude(lng);
        } catch (SQLException e) {
            // Fallback if columns don't exist
        }
        return user;
    }
}
