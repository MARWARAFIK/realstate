<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="agence.dao.AgenceDAO" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="java.net.URLEncoder" %>

<%
    Client client = (Client) session.getAttribute("client");

    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    AgenceDAO dao = new AgenceDAO();
    Agence agence = dao.getFirstAgence();

    String location = agence != null && agence.getMapLocation() != null && !agence.getMapLocation().isEmpty()
            ? agence.getMapLocation()
            : "Casablanca Maroc";

    String image = agence != null && agence.getImage() != null && !agence.getImage().isEmpty()
            ? agence.getImage()
            : "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80";
%>

<!DOCTYPE html>
<html lang="fr">
<head>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css">
    <meta charset="UTF-8">
    <title>Contact agence</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-contact.css">
</head>
<body>

<header class="contact-hero animate-hero">

    <!-- NAVBAR -->
    <nav class="mh-navbar">
        <a class="mh-logo" href="<%=request.getContextPath()%>/client/home.jsp">
            REAL <br><span>ESTATE</span>
        </a>

        <div class="mh-menu">
            <a href="<%=request.getContextPath()%>/client/home.jsp">Home</a>
            <a href="<%=request.getContextPath()%>/client/properties.jsp">Properties</a>
            <a href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
            <a class="active" href="<%=request.getContextPath()%>/client/contact.jsp">Contact</a>
            <a href="<%=request.getContextPath()%>/client/logout">Logout</a>
        </div>
    </nav>

    <!-- HERO CONTENT -->
    <div class="contact-hero-content animate-content">
        <h1>CONTACT<br>AGENCE</h1>
        <div class="mh-line"></div>
        <p>Nous sommes à votre écoute</p>
        <span>Contactez notre agence pour une visite ou réservation</span>
    </div>

</header>

<section class="contact-container">

    <div class="contact-form">
        <h2>Envoyer un message</h2>

        <% if(request.getParameter("success") != null) { %>
        <p class="success">Message envoyé à l'agence avec succès.</p>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
        <p class="error">Erreur lors de l'envoi du message.</p>
        <% } %>

        <% if(agence == null) { %>
        <p class="error">Aucune agence trouvée.</p>
        <% } else { %>
        <% if(request.getParameter("success") != null) { %>
        <div class="success-message">
            Message envoyé à l'agence avec succès.
        </div>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
        <div class="error-message">
            Erreur lors de l'envoi du message.
        </div>
        <% } %>
        <form action="<%=request.getContextPath()%>/client/send-message" method="post">

            <input type="hidden" name="agenceId" value="<%= agence.getId() %>">
            <input type="hidden" name="typeMessage" value="Contact">
            <input type="hidden" name="back" value="contact">

            <div class="row">
                <input type="text" name="nom" value="<%= client.getNom() %>" placeholder="Nom" required>
                <input type="email" name="email" value="<%= client.getEmail() %>" placeholder="Email" required>
            </div>

            <input type="text" name="telephone" value="<%= client.getTelephone() != null ? client.getTelephone() : "" %>" placeholder="Téléphone" required>
            <textarea name="message" placeholder="Votre message..." required></textarea>

            <button type="submit">Envoyer message</button>
        </form>

        <% } %>
    </div>

    <div class="contact-info">
        <img src="<%= image %>" class="agency-img" alt="Agence image">

        <% if(agence != null) { %>
        <h2><%= agence.getNom() %></h2>
        <p><b>Email:</b> <%= agence.getEmail() %></p>
        <p><b>Téléphone:</b> <%= agence.getTelephone() != null ? agence.getTelephone() : "Non défini" %></p>
        <p><b>Ville:</b> <%= agence.getVille() != null ? agence.getVille() : "Non définie" %></p>
        <p><b>Adresse:</b> <%= agence.getAdresse() != null ? agence.getAdresse() : "Non définie" %></p>

        <p class="desc">
            <%= agence.getDescription() != null ? agence.getDescription() : "" %>
        </p>

        <div class="actions">
            <a href="mailto:<%= agence.getEmail() %>">Email</a>
            <a href="tel:<%= agence.getTelephone() %>">Appeler</a>
        </div>
        <% } %>
    </div>

</section>

<section class="map-box">
    <h2>Notre localisation</h2>

    <iframe
            src="https://www.google.com/maps?q=<%= URLEncoder.encode(location, "UTF-8") %>&output=embed"
            width="100%"
            height="360"
            style="border:0;"
            allowfullscreen
            loading="lazy">
    </iframe>
</section>
<%@ include file="footer.jsp" %>
</body>
</html>