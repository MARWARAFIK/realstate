package client.model;

public class ClientView {
    private int id;
    private String nom;
    private String email;
    private String telephone;
    private int likesCount;
    private int messagesCount;
    private int reservationsCount;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public int getLikesCount() { return likesCount; }
    public void setLikesCount(int likesCount) { this.likesCount = likesCount; }

    public int getMessagesCount() { return messagesCount; }
    public void setMessagesCount(int messagesCount) { this.messagesCount = messagesCount; }

    public int getReservationsCount() { return reservationsCount; }
    public void setReservationsCount(int reservationsCount) { this.reservationsCount = reservationsCount; }

    public int getTotalInteractions() {
        return likesCount + messagesCount + reservationsCount;
    }

    public boolean hasProfile() {
        return telephone != null && !telephone.trim().isEmpty();
    }

    public boolean isFidele() {
        return getTotalInteractions() >= 3;
    }
}