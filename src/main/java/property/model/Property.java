package property.model;

public class Property {
    private int id;
    private String titre;
    private String ville;
    private String adresse;
    private String type;
    private String operation;
    private double prix;
    private double surface;
    private int chambres;
    private String image;
    private int agenceId;
    private String statut;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getOperation() { return operation; }
    public void setOperation(String operation) { this.operation = operation; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    public double getSurface() { return surface; }
    public void setSurface(double surface) { this.surface = surface; }

    public int getChambres() { return chambres; }
    public void setChambres(int chambres) { this.chambres = chambres; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public int getAgenceId() { return agenceId; }
    public void setAgenceId(int agenceId) { this.agenceId = agenceId; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
}