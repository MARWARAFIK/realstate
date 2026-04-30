package message.model;

public class Message {

    private int id;
    private int clientId;
    private int propertyId;
    private int agenceId;

    private String nom;
    private String email;
    private String telephone;

    private String typeMessage;
    private String message;
    private String statut;
    private String dateMessage;

    // 🔥 property infos
    private String propertyTitle;
    private String propertyVille;
    private String propertyAdresse;
    private String propertyImage;
    private String propertyType;
    private double propertyPrix;

    private String reply;
    private String replyDate;

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public String getReplyDate() { return replyDate; }
    public void setReplyDate(String replyDate) { this.replyDate = replyDate; }

    // ===== GETTERS & SETTERS =====

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public int getAgenceId() { return agenceId; }
    public void setAgenceId(int agenceId) { this.agenceId = agenceId; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getTypeMessage() { return typeMessage; }
    public void setTypeMessage(String typeMessage) { this.typeMessage = typeMessage; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getDateMessage() { return dateMessage; }
    public void setDateMessage(String dateMessage) { this.dateMessage = dateMessage; }

    public String getPropertyTitle() { return propertyTitle; }
    public void setPropertyTitle(String propertyTitle) { this.propertyTitle = propertyTitle; }

    public String getPropertyVille() { return propertyVille; }
    public void setPropertyVille(String propertyVille) { this.propertyVille = propertyVille; }

    public String getPropertyAdresse() { return propertyAdresse; }
    public void setPropertyAdresse(String propertyAdresse) { this.propertyAdresse = propertyAdresse; }

    public String getPropertyImage() { return propertyImage; }
    public void setPropertyImage(String propertyImage) { this.propertyImage = propertyImage; }

    public String getPropertyType() { return propertyType; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }

    public double getPropertyPrix() { return propertyPrix; }
    public void setPropertyPrix(double propertyPrix) { this.propertyPrix = propertyPrix; }
}