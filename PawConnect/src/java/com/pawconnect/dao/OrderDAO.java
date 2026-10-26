package com.pawconnect.dao;

import com.pawconnect.model.Order;
import com.pawconnect.model.OrderItem;
import com.pawconnect.model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order, List<CartItem> cartItems) {
        String orderSql = "INSERT INTO orders (user_id, total_amount, shipping_address, shipping_city, shipping_state, shipping_pincode, order_status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')";
        String itemSql = "INSERT INTO order_items (order_id, pet_id, pet_name, price, quantity) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, order.getUserId());
            orderPs.setDouble(2, order.getTotalAmount());
            orderPs.setString(3, order.getShippingAddress());
            orderPs.setString(4, order.getShippingCity());
            orderPs.setString(5, order.getShippingState());
            orderPs.setString(6, order.getShippingPincode());
            orderPs.executeUpdate();

            ResultSet keys = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (keys.next()) {
                orderId = keys.getInt(1);
            }

            PreparedStatement itemPs = conn.prepareStatement(itemSql);
            for (CartItem item : cartItems) {
                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getPetId());
                itemPs.setString(3, item.getPetName() + " - " + item.getBreed());
                itemPs.setDouble(4, item.getPrice());
                itemPs.setInt(5, item.getQuantity());
                itemPs.addBatch();
            }
            itemPs.executeBatch();

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return 0;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name as user_name, u.email as user_email FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id WHERE o.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setUserName(rs.getString("user_name"));
                order.setUserEmail(rs.getString("user_email"));
                order.setOrderItems(getOrderItems(orderId));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.image_url FROM order_items oi LEFT JOIN pets p ON oi.pet_id = p.pet_id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setItemId(rs.getInt("item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setPetId(rs.getInt("pet_id"));
                item.setPetName(rs.getString("pet_name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setImageUrl(rs.getString("image_url"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Order> getUserOrders(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as user_name, u.email as user_email FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setUserName(rs.getString("user_name"));
                order.setUserEmail(rs.getString("user_email"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name as user_name, u.email as user_email FROM orders o " +
                     "JOIN users u ON o.user_id = u.user_id ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setUserName(rs.getString("user_name"));
                order.setUserEmail(rs.getString("user_email"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE order_status != 'Cancelled'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setShippingCity(rs.getString("shipping_city"));
        order.setShippingState(rs.getString("shipping_state"));
        order.setShippingPincode(rs.getString("shipping_pincode"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        return order;
    }
}
