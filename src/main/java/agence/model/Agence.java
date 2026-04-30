package agence.model;

public class Agence {
    private int id;
    private String nom;
    private String email;
    private String password;
    private String telephone;
    private String adresse;
    private String ville;
    private String description;
    private String mapLocation;
    private String image;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getMapLocation() { return mapLocation; }
    public void setMapLocation(String mapLocation) { this.mapLocation = mapLocation; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}