package contract.dao;

import contract.model.Contract;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContractDAO {

    public int createContract(Contract c) {
        String sql = "INSERT INTO client_contracts " +
                "(agence_id, client_id, property_id, type_contrat, date_debut, date_fin, montant, statut, conditions) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'Actif', ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, c.getAgenceId());
            ps.setInt(2, c.getClientId());
            ps.setInt(3, c.getPropertyId());
            ps.setString(4, c.getTypeContrat());
            ps.setString(5, c.getDateDebut());

            if (c.getDateFin() == null || c.getDateFin().trim().isEmpty()) {
                ps.setNull(6, Types.DATE);
            } else {
                ps.setString(6, c.getDateFin());
            }

            ps.setDouble(7, c.getMontant());
            ps.setString(8, c.getConditions());

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

    public boolean createInvoice(int contratId, int agenceId, int clientId, double montant) {
        String sql = "INSERT INTO invoices(contrat_id, agence_id, client_id, numero, montant, statut, date_facture) " +
                "VALUES (?, ?, ?, ?, ?, 'Non payée', CURDATE())";

        String numero = "FAC-" + contratId + "-" + System.currentTimeMillis();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, contratId);
            ps.setInt(2, agenceId);
            ps.setInt(3, clientId);
            ps.setString(4, numero);
            ps.setDouble(5, montant);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public String getInvoiceNumeroByContract(int contratId) {
        String sql = "SELECT numero FROM invoices WHERE contrat_id = ? ORDER BY id DESC LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, contratId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("numero");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Contract getById(int id) {
        String sql =
                "SELECT cc.*, c.nom AS client_nom, c.email AS client_email, c.telephone AS client_telephone, " +
                        "p.titre AS property_title, p.ville AS property_ville, p.adresse AS property_adresse " +
                        "FROM client_contracts cc " +
                        "JOIN clients c ON cc.client_id = c.id " +
                        "JOIN properties p ON cc.property_id = p.id " +
                        "WHERE cc.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapContract(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Contract> getByAgence(int agenceId) {
        List<Contract> list = new ArrayList<>();

        String sql =
                "SELECT cc.*, c.nom AS client_nom, c.email AS client_email, c.telephone AS client_telephone, " +
                        "p.titre AS property_title, p.ville AS property_ville, p.adresse AS property_adresse " +
                        "FROM client_contracts cc " +
                        "JOIN clients c ON cc.client_id = c.id " +
                        "JOIN properties p ON cc.property_id = p.id " +
                        "WHERE cc.agence_id = ? " +
                        "ORDER BY cc.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, agenceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapContract(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean deleteContract(int id, int agenceId) {

        String sql = "DELETE FROM client_contracts WHERE id = ? AND agence_id = ?";

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

    public boolean markInvoicePaid(int contratId) {
        String sql = "UPDATE invoices SET statut='Payée' WHERE contrat_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, contratId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Contract mapContract(ResultSet rs) throws SQLException {
        Contract c = new Contract();

        c.setId(rs.getInt("id"));
        c.setAgenceId(rs.getInt("agence_id"));
        c.setClientId(rs.getInt("client_id"));
        c.setPropertyId(rs.getInt("property_id"));
        c.setTypeContrat(rs.getString("type_contrat"));
        c.setDateDebut(rs.getString("date_debut"));
        c.setDateFin(rs.getString("date_fin"));
        c.setMontant(rs.getDouble("montant"));
        c.setStatut(rs.getString("statut"));
        c.setConditions(rs.getString("conditions"));
        c.setDateCreation(rs.getString("date_creation"));

        c.setClientNom(rs.getString("client_nom"));
        c.setClientEmail(rs.getString("client_email"));
        c.setPropertyTitle(rs.getString("property_title"));
        c.setPropertyVille(rs.getString("property_ville"));

        return c;
    }
}