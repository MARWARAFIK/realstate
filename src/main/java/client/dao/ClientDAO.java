package client.dao;

import client.model.Client;
import property.model.Property;
import utils.DBConnection;
import client.model.ClientView;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    public void toggleLike(int clientId, int propertyId) {
        if (isLiked(clientId, propertyId)) {
            unlikeProperty(clientId, propertyId);
        } else {
            likeProperty(clientId, propertyId);
        }
    }
    public List<Client> getAll() {
        List<Client> list = new ArrayList<>();

        String sql = "SELECT * FROM clients ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Client c = new Client();

                c.setId(rs.getInt("id"));
                c.setNom(rs.getString("nom"));
                c.setEmail(rs.getString("email"));
                c.setTelephone(rs.getString("telephone"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM clients WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean checkPassword(int clientId, String oldPassword) {
        String sql = "SELECT id FROM clients WHERE id=? AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setString(2, oldPassword);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int clientId, String newPassword) {
        String sql = "UPDATE clients SET password=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, clientId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public Client getByEmail(String email) {
        String sql = "SELECT * FROM clients WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Client c = new Client();
                c.setId(rs.getInt("id"));
                c.setNom(rs.getString("nom"));
                c.setEmail(rs.getString("email"));
                return c;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean updatePasswordByEmail(String email, String password) {
        String sql = "UPDATE clients SET password=? WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, password);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean insert(Client c) {
        String sql = "INSERT INTO clients(nom, email, password, telephone) VALUES(?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNom());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getPassword());
            ps.setString(4, c.getTelephone());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isLiked(int clientId, int propertyId) {
        String sql = "SELECT id FROM property_likes WHERE client_id=? AND property_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, propertyId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean likeProperty(int clientId, int propertyId) {
        String sql = "INSERT INTO property_likes(client_id, property_id) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, propertyId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private boolean unlikeProperty(int clientId, int propertyId) {
        String sql = "DELETE FROM property_likes WHERE client_id=? AND property_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setInt(2, propertyId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Property> getLikedProperties(int clientId) {
        List<Property> list = new ArrayList<>();

        String sql = "SELECT p.* FROM properties p " +
                "JOIN property_likes pl ON p.id = pl.property_id " +
                "WHERE pl.client_id = ? ORDER BY pl.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapProperty(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean register(Client client) {
        String sql = "INSERT INTO clients(nom, email, password, telephone) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, client.getNom());
            ps.setString(2, client.getEmail());
            ps.setString(3, client.getPassword());
            ps.setString(4, client.getTelephone());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Client login(String email, String password) {
        String sql = "SELECT * FROM clients WHERE LOWER(email)=LOWER(?) AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            ps.setString(2, password.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapClient(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public List<ClientView> getAllWithStats() {
        List<ClientView> list = new ArrayList<>();

        String sql =
                "SELECT c.id, c.nom, c.email, c.telephone, " +
                        "COUNT(DISTINCT pl.id) AS likes_count, " +
                        "COUNT(DISTINCT m.id) AS messages_count, " +
                        "SUM(CASE WHEN m.type_message = 'Reservation' THEN 1 ELSE 0 END) AS reservations_count " +
                        "FROM clients c " +
                        "LEFT JOIN property_likes pl ON c.id = pl.client_id " +
                        "LEFT JOIN messages m ON c.id = m.client_id " +
                        "GROUP BY c.id, c.nom, c.email, c.telephone " +
                        "ORDER BY c.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ClientView cv = new ClientView();

                cv.setId(rs.getInt("id"));
                cv.setNom(rs.getString("nom"));
                cv.setEmail(rs.getString("email"));
                cv.setTelephone(rs.getString("telephone"));

                cv.setLikesCount(rs.getInt("likes_count"));
                cv.setMessagesCount(rs.getInt("messages_count"));
                cv.setReservationsCount(rs.getInt("reservations_count"));

                list.add(cv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    private Client mapClient(ResultSet rs) throws SQLException {
        Client c = new Client();

        c.setId(rs.getInt("id"));
        c.setNom(rs.getString("nom"));
        c.setEmail(rs.getString("email"));
        c.setTelephone(rs.getString("telephone"));

        return c;
    }

    private Property mapProperty(ResultSet rs) throws SQLException {
        Property p = new Property();

        p.setId(rs.getInt("id"));
        p.setTitre(rs.getString("titre"));
        p.setPrix(rs.getDouble("prix"));
        p.setImage(rs.getString("image"));
        p.setVille(rs.getString("ville"));
        p.setAdresse(rs.getString("adresse"));
        p.setType(rs.getString("type"));
        p.setSurface(rs.getDouble("surface"));
        p.setChambres(rs.getInt("chambres"));
        p.setOperation(rs.getString("operation"));
        p.setAgenceId(rs.getInt("agence_id"));

        return p;
    }
}