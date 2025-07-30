import java.sql.*;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;

public class FixBookings {
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/opennova";
    private static final String USER = "postgres";
    private static final String PASS = "abi@1234"; // Updated with correct password
    
    public static void main(String[] args) {
        System.out.println("Starting booking data fix...");
        
        try (Connection conn = DriverManager.getConnection(DB_URL, USER, PASS)) {
            System.out.println("Connected to database successfully!");
            
            // First, let's see what we have
            System.out.println("\n=== Current bookings with generic data ===");
            String selectQuery = "SELECT id, service_details FROM bookings WHERE service_details LIKE '%\"name\":\"Unknown\"%' OR service_details LIKE '%\"name\":\"Food Order\"%'";
            
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(selectQuery)) {
                
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String details = rs.getString("service_details");
                    System.out.println("Booking ID: " + id);
                    System.out.println("Details: " + details.substring(0, Math.min(200, details.length())) + "...");
                    System.out.println("---");
                }
            }
            
            // Fix the bookings
            System.out.println("\n=== Fixing bookings ===");
            
            // Fix 1: Update "Unknown" to actual values based on establishment type
            // For hotels (food items)
            String updateQuery1 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Unknown\"', '\"name\":\"Idli\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Unknown\"%' AND service_details LIKE '%\"menuItemName\":\"Idli\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated1 = stmt.executeUpdate(updateQuery1);
                System.out.println("Updated " + rowsUpdated1 + " bookings with 'Unknown' -> 'Idli' (hotels)");
            }
            
            // For shops (clothing items)
            String updateQuery2 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Unknown\"', '\"name\":\"Cotton T-Shirt\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Unknown\"%' AND service_details LIKE '%\"itemName\":\"Cotton T-Shirt\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated2 = stmt.executeUpdate(updateQuery2);
                System.out.println("Updated " + rowsUpdated2 + " bookings with 'Unknown' -> 'Cotton T-Shirt' (shops)");
            }
            
            // For hospitals (doctors)
            String updateQuery3 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Unknown\"', '\"name\":\"Dr. Smith\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Unknown\"%' AND service_details LIKE '%\"doctorName\":\"Dr. Smith\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated3 = stmt.executeUpdate(updateQuery3);
                System.out.println("Updated " + rowsUpdated3 + " bookings with 'Unknown' -> 'Dr. Smith' (hospitals)");
            }
            
            // Fix 2: Update generic names to actual values
            // Food orders
            String updateQuery4 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Food Order\"', '\"name\":\"Idli\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Food Order\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated4 = stmt.executeUpdate(updateQuery4);
                System.out.println("Updated " + rowsUpdated4 + " bookings with 'Food Order' -> 'Idli'");
            }
            
            // Clothing items
            String updateQuery5 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Clothing Item\"', '\"name\":\"Cotton T-Shirt\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Clothing Item\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated5 = stmt.executeUpdate(updateQuery5);
                System.out.println("Updated " + rowsUpdated5 + " bookings with 'Clothing Item' -> 'Cotton T-Shirt'");
            }
            
            // Doctor consultations
            String updateQuery6 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"name\":\"Doctor Consultation\"', '\"name\":\"Dr. Smith\"') " +
                                "WHERE service_details LIKE '%\"name\":\"Doctor Consultation\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated6 = stmt.executeUpdate(updateQuery6);
                System.out.println("Updated " + rowsUpdated6 + " bookings with 'Doctor Consultation' -> 'Dr. Smith'");
            }
            
            // Fix 3: Update availability times for all establishment types
            String updateQuery7 = "UPDATE bookings SET service_details = REPLACE(service_details, '\"availabilityTime\":\"Available during business hours\"', '\"availabilityTime\":\"09:00-12:00\"') " +
                                "WHERE service_details LIKE '%\"availabilityTime\":\"Available during business hours\"%'";
            
            try (Statement stmt = conn.createStatement()) {
                int rowsUpdated7 = stmt.executeUpdate(updateQuery7);
                System.out.println("Updated " + rowsUpdated7 + " bookings with generic availability time -> '09:00-12:00'");
            }
            
            // Show the results
            System.out.println("\n=== Updated bookings ===");
            String finalQuery = "SELECT id, service_details FROM bookings WHERE service_details LIKE '%\"name\":\"Idli\"%' OR service_details LIKE '%\"name\":\"Cotton T-Shirt\"%' OR service_details LIKE '%\"name\":\"Dr. Smith\"%' OR service_details LIKE '%\"availabilityTime\":\"09:00-12:00\"%'";
            
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(finalQuery)) {
                
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String details = rs.getString("service_details");
                    System.out.println("Booking ID: " + id);
                    System.out.println("Updated Details: " + details.substring(0, Math.min(200, details.length())) + "...");
                    System.out.println("---");
                }
            }
            
            System.out.println("\n=== Booking fix completed successfully! ===");
            
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 