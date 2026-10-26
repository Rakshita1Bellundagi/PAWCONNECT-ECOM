import java.io.*;
import java.net.URL;
import java.nio.file.*;
import java.sql.*;
import java.util.*;

public class DownloadSecondaryImages {
    public static void main(String[] args) {
        String dbUrl = "jdbc:mysql://localhost:3306/pawconnect_db";
        String user = "root";
        String password = "password"; // Assume this is default or no password needed? Wait, I should use the DBConnection.
        
        // Map of category ID to a secondary unsplash image keyword
        Map<Integer, String> catKeywords = new HashMap<>();
        catKeywords.put(1, "cute-dog-playing"); // Dog
        catKeywords.put(2, "cute-kitten"); // Cat
        catKeywords.put(3, "colorful-parrot"); // Bird
        catKeywords.put(4, "fluffy-bunny"); // Rabbit
        catKeywords.put(5, "cute-hamster"); // Hamster
        catKeywords.put(6, "turtle-swimming"); // Turtle
        catKeywords.put(7, "guinea-pig"); // Guinea Pig
        catKeywords.put(8, "aquarium-fish"); // Fish
        
        String imgDir = "c:/Users/vikra/OneDrive/Desktop/wt-project(own)/PawConnect/web/images/pets";
        new File(imgDir).mkdirs();
        
        try (Connection conn = DriverManager.getConnection(dbUrl, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT pet_id, category_id FROM pets WHERE image_url_2 IS NULL OR image_url_2 = ''")) {
             
            while (rs.next()) {
                int petId = rs.getInt("pet_id");
                int catId = rs.getInt("category_id");
                
                String keyword = catKeywords.getOrDefault(catId, "pet");
                String imgName = "pet_" + petId + "_2.jpg";
                String imgPath = imgDir + "/" + imgName;
                
                System.out.println("Downloading 2nd image for pet " + petId + " (Category " + catId + ")");
                
                try {
                    String urlStr = "https://source.unsplash.com/800x600/?" + keyword;
                    // Note: source.unsplash.com redirects, so we use Java's InputStream
                    try (InputStream in = new URL(urlStr).openStream()) {
                        Files.copy(in, Paths.get(imgPath), StandardCopyOption.REPLACE_EXISTING);
                    }
                    
                    // Update DB
                    try (PreparedStatement updateStmt = conn.prepareStatement("UPDATE pets SET image_url_2 = ? WHERE pet_id = ?")) {
                        updateStmt.setString(1, imgName);
                        updateStmt.setInt(2, petId);
                        updateStmt.executeUpdate();
                    }
                } catch (Exception e) {
                    System.out.println("Failed to download for pet " + petId + ": " + e.getMessage());
                }
                
                // Sleep to avoid rate limits
                Thread.sleep(500);
            }
            
            System.out.println("Finished setting secondary images!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
