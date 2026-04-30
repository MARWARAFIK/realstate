package property.dao;

import property.model.Property;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    public boolean add(Property p) {
        String sql = "INSERT INTO properties(titre, ville, adresse, type, operation, prix, surface, chambres, image, agence_id, statut) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getTitre());
            ps.setString(2, p.getVille());
            ps.setString(3, p.getAdresse());
            ps.setString(4, p.getType());
            ps.setString(5, p.getOperation());
            ps.setDouble(6, p.getPrix());
            ps.setDouble(7, p.getSurface());
            ps.setInt(8, p.getChambres());
            ps.setString(9, p.getImage());
            ps.setInt(10, p.getAgenceId());
            ps.setString(11, p.getStatut() != null ? p.getStatut() : "disponible");

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean update(Property p) {
        String sql = "UPDATE properties SET titre=?, ville=?, adresse=?, type=?, operation=?, prix=?, surface=?, chambres=?, image=?, statut=? WHERE id=? AND agence_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getTitre());
            ps.setString(2, p.getVille());
            ps.setString(3, p.getAdresse());
            ps.setString(4, p.getType());
            ps.setString(5, p.getOperation());
            ps.setDouble(6, p.getPrix());
            ps.setDouble(7, p.getSurface());
            ps.setInt(8, p.getChambres());
            ps.setString(9, p.getImage());
            ps.setString(10, p.getStatut());
            ps.setInt(11, p.getId());
            ps.setInt(12, p.getAgenceId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean delete(int id, int agenceId) {
        String sql = "DELETE FROM properties WHERE id=? AND agence_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, agenceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Property getById(int id) {
        String sql = "SELECT * FROM properties WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapProperty(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Property> getAll() {
        List<Property> list = new ArrayList<>();
        String sql = "SELECT * FROM properties ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapProperty(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Property> getByAgencePaginated(int agenceId, int offset, int limit) {
        List<Property> list = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE agence_id=? ORDER BY id DESC LIMIT ? OFFSET ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, agenceId);
            ps.setInt(2, limit);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapProperty(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countByAgence(int agenceId) {
        String sql = "SELECT COUNT(*) FROM properties WHERE agence_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, agenceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean updateStatut(int id, String statut, int agenceId) {
        String sql = "UPDATE properties SET statut=? WHERE id=? AND agence_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, statut);
            ps.setInt(2, id);
            ps.setInt(3, agenceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public int addAndReturnId(Property p) {
        String sql = "INSERT INTO properties(titre, ville, adresse, type, operation, prix, surface, chambres, image, agence_id, statut) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getTitre());
            ps.setString(2, p.getVille());
            ps.setString(3, p.getAdresse());
            ps.setString(4, p.getType());
            ps.setString(5, p.getOperation());
            ps.setDouble(6, p.getPrix());
            ps.setDouble(7, p.getSurface());
            ps.setInt(8, p.getChambres());
            ps.setString(9, p.getImage());
            ps.setInt(10, p.getAgenceId());
            ps.setString(11, p.getStatut() != null ? p.getStatut() : "disponible");

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean addPropertyImage(int propertyId, String imageUrl) {
        String sql = "INSERT INTO property_images(property_id, image_url) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, propertyId);
            ps.setString(2, imageUrl);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<String> getImagesByProperty(int propertyId) {
        List<String> images = new ArrayList<>();

        String sql = "SELECT image_url FROM property_images WHERE property_id=? ORDER BY id ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, propertyId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return images;
    }

    public List<Property> getMostLiked(int limit) {
        List<Property> list = new ArrayList<>();

        String sql =
                "SELECT p.*, COUNT(pl.id) AS likes_count " +
                        "FROM properties p " +
                        "LEFT JOIN property_likes pl ON p.id = pl.property_id " +
                        "GROUP BY p.id " +
                        "ORDER BY likes_count DESC, p.id DESC " +
                        "LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapProperty(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countLikes(int propertyId) {
        String sql = "SELECT COUNT(*) FROM property_likes WHERE property_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    public boolean isLikedByClient(int propertyId, int clientId) {
        String sql = "SELECT id FROM property_likes WHERE property_id=? AND client_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, propertyId);
            ps.setInt(2, clientId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    private Property mapProperty(ResultSet rs) throws SQLException {
        Property p = new Property();

        p.setId(rs.getInt("id"));
        p.setTitre(rs.getString("titre"));
        p.setVille(rs.getString("ville"));
        p.setAdresse(rs.getString("adresse"));
        p.setType(rs.getString("type"));
        p.setOperation(rs.getString("operation"));
        p.setPrix(rs.getDouble("prix"));
        p.setSurface(rs.getDouble("surface"));
        p.setChambres(rs.getInt("chambres"));
        p.setImage(rs.getString("image"));
        p.setAgenceId(rs.getInt("agence_id"));
        p.setStatut(rs.getString("statut"));

        return p;
    }
}