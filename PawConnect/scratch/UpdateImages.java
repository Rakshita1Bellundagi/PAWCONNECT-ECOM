import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class UpdateImages {
    public static void main(String[] args) {
        String dbUrl = "jdbc:mysql://localhost:3301/pawconnect_db";
        String user = "root";
        String password = "Vikramg@1845"; 
        
        Map<Integer, String> catImages = new HashMap<>();
        // Unsplash images for each category
        catImages.put(1, "https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=800&q=80"); // Dog
        catImages.put(2, "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=800&q=80"); // Cat
        catImages.put(3, "https://images.unsplash.com/photo-1552728089-57105a8e7e17?auto=format&fit=crop&w=800&q=80"); // Bird
        catImages.put(4, "https://images.unsplash.com/photo-1585110396000-c9fd7e48afa1?auto=format&fit=crop&w=800&q=80"); // Rabbit
        catImages.put(5, "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?auto=format&fit=crop&w=800&q=80"); // Hamster
        catImages.put(6, "https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?auto=format&fit=crop&w=800&q=80"); // Turtle
        catImages.put(7, "https://images.unsplash.com/photo-1533152162573-93ad94eb20f6?auto=format&fit=crop&w=800&q=80"); // Guinea Pig
        catImages.put(8, "https://images.unsplash.com/photo-1524704654690-b56c05c78a00?auto=format&fit=crop&w=800&q=80"); // Fish
        
        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT pet_id, category_id FROM pets WHERE image_url_2 IS NULL OR image_url_2 = ''")) {
             
            int updated = 0;
            while (rs.next()) {
                int petId = rs.getInt("pet_id");
                int catId = rs.getInt("category_id");
                
                String imgUrl = catImages.getOrDefault(catId, "https://placehold.co/800x600?text=Pet+Image+2");
                
                try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE pets SET image_url_2 = ? WHERE pet_id = ?")) {
                    updateStmt.setString(1, imgUrl);
                    updateStmt.setInt(2, petId);
                    updateStmt.executeUpdate();
                    updated++;
                }
            }
            
            System.out.println("Finished setting secondary images for " + updated + " pets!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
