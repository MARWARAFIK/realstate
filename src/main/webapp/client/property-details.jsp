<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.List" %>

<%
    Client client = (Client) session.getAttribute("client");
    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    PropertyDAO dao = new PropertyDAO();
    Property p = dao.getById(id);

    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/client/properties.jsp");
        return;
    }

    List<String> images = dao.getImagesByProperty(p.getId());

    if (images.isEmpty()) {
        images.add(p.getImage());
    }

    String statut = p.getStatut() != null ? p.getStatut() : "disponible";
    String mapQuery = URLEncoder.encode(p.getAdresse() + " " + p.getVille(), "UTF-8");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails propriété</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/property-details.css?v=6000">
</head>
<body>

<div class="details-page">

    <a class="back" href="<%=request.getContextPath()%>/client/properties.jsp">← Retour aux propriétés</a>

    <div class="details-card">

        <div class="slider-box">
            <button class="slider-btn left" type="button" onclick="prevImage()">‹</button>

            <img id="sliderImage" class="main-img" src="<%= images.get(0) %>" alt="Image propriété">

            <button class="slider-btn right" type="button" onclick="nextImage()">›</button>
        </div>

        <div class="info">

            <div class="details-tags">
                <span class="tag"><%= p.getOperation() %></span>
                <span class="property-status <%= statut %>"><%= statut %></span>
            </div>

            <h1><%= p.getTitre() %></h1>
            <p class="location"><%= p.getVille() %> - <%= p.getAdresse() %></p>

            <div class="meta">
                <span>Type: <b><%= p.getType() %></b></span>
                <span>Surface: <b><%= p.getSurface() %> m²</b></span>
                <span>Chambres: <b><%= p.getChambres() %></b></span>
            </div>

            <h2><%= p.getPrix() %> DH</h2>

            <% if(request.getParameter("success") != null) { %>
            <p class="success">Votre demande a été envoyée à l'agence.</p>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
            <p class="error">Erreur lors de l'envoi.</p>
            <% } %>

            <div class="actions">
                <button type="button" onclick="showForm('Reservation')">Réserver ce bien</button>

                <a class="details-contact-btn"
                   href="<%=request.getContextPath()%>/client/contact.jsp?propertyId=<%= p.getId() %>&agenceId=<%= p.getAgenceId() %>">
                    Contacter l'agence
                </a>
            </div>

            <form id="contactForm" action="<%=request.getContextPath()%>/client/send-message" method="post">
                <input type="hidden" name="propertyId" value="<%= p.getId() %>">
                <input type="hidden" name="agenceId" value="<%= p.getAgenceId() %>">
                <input type="hidden" name="typeMessage" id="typeMessage" value="Reservation">

                <input type="text" name="nom" value="<%= client.getNom() %>" placeholder="Votre nom" required>
                <input type="email" name="email" value="<%= client.getEmail() %>" placeholder="Votre email" required>
                <input type="text" name="telephone" placeholder="Votre téléphone" required>

                <textarea name="message" id="messageBox" placeholder="Je souhaite réserver ce bien..." required></textarea>

                <button type="submit" id="submitBtn">Envoyer la réservation</button>
            </form>
        </div>
    </div>

    <div class="map-card">
        <h2>Localisation</h2>

        <iframe
                src="https://www.google.com/maps?q=<%= mapQuery %>&output=embed"
                width="100%"
                height="350"
                style="border:0;"
                allowfullscreen
                loading="lazy">
        </iframe>
    </div>

</div>

<script>
    const images = [
        <% for(int i = 0; i < images.size(); i++) { %>
        "<%= images.get(i) %>"<%= i < images.size() - 1 ? "," : "" %>
        <% } %>
    ];

    let currentIndex = 0;

    function showImage() {
        document.getElementById("sliderImage").src = images[currentIndex];
    }

    function nextImage() {
        currentIndex = (currentIndex + 1) % images.length;
        showImage();
    }

    function prevImage() {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
        showImage();
    }

    function showForm(type) {
        document.getElementById("typeMessage").value = type;
        document.getElementById("messageBox").placeholder = "Je souhaite réserver ce bien...";
        document.getElementById("submitBtn").innerText = "Envoyer la réservation";
        document.getElementById("contactForm").scrollIntoView({ behavior: "smooth" });
    }
</script>

</body>
</html>