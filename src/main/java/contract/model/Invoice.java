package contract.model;

public class Invoice {
    private int id, contratId, agenceId, clientId;
    private String numero, statut, dateFacture, dateCreation;
    private double montant;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getContratId() { return contratId; }
    public void setContratId(int contratId) { this.contratId = contratId; }

    public int getAgenceId() { return agenceId; }
    public void setAgenceId(int agenceId) { this.agenceId = agenceId; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getDateFacture() { return dateFacture; }
    public void setDateFacture(String dateFacture) { this.dateFacture = dateFacture; }

    public String getDateCreation() { return dateCreation; }
    public void setDateCreation(String dateCreation) { this.dateCreation = dateCreation; }
}