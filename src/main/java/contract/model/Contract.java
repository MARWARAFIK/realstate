package contract.model;

public class Contract {
    private int id, agenceId, clientId, propertyId;
    private String typeContrat, dateDebut, dateFin, statut, conditions, dateCreation;
    private double montant;

    private String clientNom, clientEmail, propertyTitle, propertyVille;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAgenceId() { return agenceId; }
    public void setAgenceId(int agenceId) { this.agenceId = agenceId; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public String getTypeContrat() { return typeContrat; }
    public void setTypeContrat(String typeContrat) { this.typeContrat = typeContrat; }

    public String getDateDebut() { return dateDebut; }
    public void setDateDebut(String dateDebut) { this.dateDebut = dateDebut; }

    public String getDateFin() { return dateFin; }
    public void setDateFin(String dateFin) { this.dateFin = dateFin; }

    public double getMontant() { return montant; }
    public void setMontant(double montant) { this.montant = montant; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getConditions() { return conditions; }
    public void setConditions(String conditions) { this.conditions = conditions; }

    public String getDateCreation() { return dateCreation; }
    public void setDateCreation(String dateCreation) { this.dateCreation = dateCreation; }

    public String getClientNom() { return clientNom; }
    public void setClientNom(String clientNom) { this.clientNom = clientNom; }

    public String getClientEmail() { return clientEmail; }
    public void setClientEmail(String clientEmail) { this.clientEmail = clientEmail; }

    public String getPropertyTitle() { return propertyTitle; }
    public void setPropertyTitle(String propertyTitle) { this.propertyTitle = propertyTitle; }

    public String getPropertyVille() { return propertyVille; }
    public void setPropertyVille(String propertyVille) { this.propertyVille = propertyVille; }
}