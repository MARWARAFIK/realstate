package message.dao;

import message.model.Message;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean insert(Message m) {
        String sql = "INSERT INTO messages " +
                "(client_id, property_id, agence_id, nom, email, telephone, type_message, message, statut, date_message) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Non lu', NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, m.getClientId());

            if (m.getPropertyId() > 0) {
                ps.setInt(2, m.getPropertyId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }

            ps.setInt(3, m.getAgenceId());
            ps.setString(4, m.getNom());
            ps.setString(5, m.getEmail());
            ps.setString(6, m.getTelephone());
            ps.setString(7, m.getTypeMessage());
            ps.setString(8, m.getMessage());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getByAgenceAndType(int agenceId, String type) {
        return getByAgenceTypeAndStatus(agenceId, type, "all");
    }

    public List<Message> getByAgenceTypeAndStatus(int agenceId, String type, String statut) {
        List<Message> list = new ArrayList<>();

        String sql =
                "SELECT m.*, " +
                        "p.titre AS property_title, " +
                        "p.ville AS property_ville, " +
                        "p.adresse AS property_adresse, " +
                        "p.image AS property_image, " +
                        "p.type AS property_type, " +
                        "p.prix AS property_prix " +
                        "FROM messages m " +
                        "LEFT JOIN properties p ON m.property_id = p.id " +
                        "WHERE m.agence_id = ? AND m.type_message = ? ";

        if (statut != null && !statut.equals("all")) {
            sql += "AND m.statut = ? ";
        }

        sql += "ORDER BY m.date_message DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, agenceId);
            ps.setString(2, type);

            if (statut != null && !statut.equals("all")) {
                ps.setString(3, statut);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapMessage(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Message getById(int id) {
        String sql =
                "SELECT m.*, " +
                        "p.titre AS property_title, " +
                        "p.ville AS property_ville, " +
                        "p.adresse AS property_adresse, " +
                        "p.image AS property_image, " +
                        "p.type AS property_type, " +
                        "p.prix AS property_prix " +
                        "FROM messages m " +
                        "LEFT JOIN properties p ON m.property_id = p.id " +
                        "WHERE m.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapMessage(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateStatus(int id, int agenceId, String statut) {
        String sql = "UPDATE messages SET statut = ? WHERE id = ? AND agence_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, statut);
            ps.setInt(2, id);
            ps.setInt(3, agenceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public void saveReply(int messageId, String reply) {
        String sql = "UPDATE messages SET reply=?, reply_date=NOW(), statut='Répondu', client_seen_reply=0 WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, reply);
            ps.setInt(2, messageId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Message> getRepliesByClient(int clientId) {
        List<Message> list = new ArrayList<>();

        String sql = "SELECT * FROM messages WHERE client_id=? AND reply IS NOT NULL ORDER BY reply_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Message m = new Message();
                m.setId(rs.getInt("id"));
                m.setClientId(rs.getInt("client_id"));
                m.setMessage(rs.getString("message"));
                m.setReply(rs.getString("reply"));
                m.setReplyDate(rs.getString("reply_date"));
                list.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void markRepliesSeen(int clientId) {
        String sql = "UPDATE messages SET client_seen_reply=1 WHERE client_id=? AND reply IS NOT NULL";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int countClientNotifications(int clientId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE client_id=? AND reply IS NOT NULL AND client_seen_reply=0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean deleteMessage(int id, int agenceId) {
        String sql = "DELETE FROM messages WHERE id = ? AND agence_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, agenceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Message mapMessage(ResultSet rs) throws SQLException {
        Message m = new Message();

        m.setId(rs.getInt("id"));
        m.setClientId(rs.getInt("client_id"));

        int propertyId = rs.getInt("property_id");
        if (rs.wasNull()) {
            m.setPropertyId(0);
        } else {
            m.setPropertyId(propertyId);
        }

        m.setAgenceId(rs.getInt("agence_id"));
        m.setNom(rs.getString("nom"));
        m.setEmail(rs.getString("email"));
        m.setTelephone(rs.getString("telephone"));
        m.setTypeMessage(rs.getString("type_message"));
        m.setMessage(rs.getString("message"));
        m.setStatut(rs.getString("statut"));
        m.setDateMessage(rs.getString("date_message"));

        m.setPropertyTitle(rs.getString("property_title"));
        m.setPropertyVille(rs.getString("property_ville"));
        m.setPropertyAdresse(rs.getString("property_adresse"));
        m.setPropertyImage(rs.getString("property_image"));
        m.setPropertyType(rs.getString("property_type"));

        double prix = rs.getDouble("property_prix");
        if (rs.wasNull()) {
            m.setPropertyPrix(0);
        } else {
            m.setPropertyPrix(prix);
        }

        return m;
    }
}