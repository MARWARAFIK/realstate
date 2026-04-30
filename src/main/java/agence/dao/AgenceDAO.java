package agence.dao;

import agence.model.Agence;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AgenceDAO {

    public Agence login(String email, String password) {
        String sql = "SELECT * FROM agences WHERE LOWER(email)=LOWER(?) AND password=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            ps.setString(2, password.trim());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapAgence(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Agence getById(int id) {
        String sql = "SELECT * FROM agences WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapAgence(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Agence getFirstAgence() {
        String sql = "SELECT * FROM agences LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return mapAgence(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateSettings(Agence agence) {
        String sql = "UPDATE agences SET nom=?, email=?, telephone=?, adresse=?, ville=?, description=?, map_location=?, image=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, agence.getNom());
            ps.setString(2, agence.getEmail());
            ps.setString(3, agence.getTelephone());
            ps.setString(4, agence.getAdresse());
            ps.setString(5, agence.getVille());
            ps.setString(6, agence.getDescription());
            ps.setString(7, agence.getMapLocation());
            ps.setString(8, agence.getImage());
            ps.setInt(9, agence.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Agence mapAgence(ResultSet rs) {
        try {
            Agence a = new Agence();

            a.setId(rs.getInt("id"));
            a.setNom(rs.getString("nom"));
            a.setEmail(rs.getString("email"));
            a.setPassword(rs.getString("password"));
            a.setTelephone(rs.getString("telephone"));
            a.setAdresse(rs.getString("adresse"));
            a.setVille(rs.getString("ville"));
            a.setDescription(rs.getString("description"));
            a.setMapLocation(rs.getString("map_location"));
            a.setImage(rs.getString("image"));

            return a;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}