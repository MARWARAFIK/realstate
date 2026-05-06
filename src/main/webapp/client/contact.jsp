<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="agence.dao.AgenceDAO" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="java.net.URLEncoder" %>

<%
    Client client = (Client) session.getAttribute("client");

    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    AgenceDAO dao = new AgenceDAO();
    Agence agence = dao.getFirstAgence();

    MessageDAO notifDao = new MessageDAO();
    int notifCount = notifDao.countClientNotifications(client.getId());

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
    <meta charset="UTF-8">
    <title>Contact agence</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css?v=9000">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-contact.css?v=11000">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<header class="contact-hero animate-hero">

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

        <a href="<%=request.getContextPath()%>/client/notifications.jsp" class="notif-btn">
            <i class="fa-solid fa-bell"></i>
            <% if(notifCount > 0) { %>
            <span><%= notifCount %></span>
            <% } %>
        </a>
    </nav>

    <div class="contact-hero-content animate-content">
        <h1>CONTACT <br> AGENCE</h1>
        <div class="mh-line"></div>
        <p>Nous sommes à votre écoute</p>
        <span>Contactez notre agence pour une visite ou réservation</span>
    </div>

</header>

<section class="contact-container">

    <div class="contact-form">
        <h2>Envoyer un message</h2>

        <div id="ajaxMessage"></div>

        <% if(agence == null) { %>

        <div class="error-message">
            Aucune agence trouvée.
        </div>

        <% } else { %>

        <form id="contactAjaxForm">

            <input type="hidden" name="agenceId" value="<%= agence.getId() %>">
            <input type="hidden" name="typeMessage" value="Contact">
            <input type="hidden" name="back" value="contact">

            <div class="row">
                <input type="text" name="nom" value="<%= client.getNom() %>" placeholder="Nom" required>
                <input type="email" name="email" value="<%= client.getEmail() %>" placeholder="Email" required>
            </div>

            <input type="text"
                   name="telephone"
                   value="<%= client.getTelephone() != null ? client.getTelephone() : "" %>"
                   placeholder="Téléphone"
                   required>

            <textarea name="message" placeholder="Votre message..." required></textarea>

            <button type="submit" class="send-main-btn" id="sendBtn">
                <i class="fa-solid fa-paper-plane"></i>
                Envoyer message
            </button>

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

<script>
    const contactForm = document.getElementById("contactAjaxForm");

    if (contactForm) {
        contactForm.addEventListener("submit", function(e) {
            e.preventDefault();

            const form = this;
            const btn = document.getElementById("sendBtn");
            const box = document.getElementById("ajaxMessage");

            btn.disabled = true;
            btn.innerHTML = "<i class='fa-solid fa-spinner fa-spin'></i> Envoi...";

            fetch("<%=request.getContextPath()%>/client/send-message", {
                method: "POST",
                body: new FormData(form)
            })
                .then(response => response.text())
                .then(data => {
                    box.innerHTML = "<div class='success-message'>Message envoyé à l'agence avec succès.</div>";

                    form.querySelector("textarea[name='message']").value = "";

                    btn.disabled = false;
                    btn.innerHTML = "<i class='fa-solid fa-paper-plane'></i> Envoyer message";
                })
                .catch(error => {
                    box.innerHTML = "<div class='error-message'>Erreur serveur. Réessayez.</div>";

                    btn.disabled = false;
                    btn.innerHTML = "<i class='fa-solid fa-paper-plane'></i> Envoyer message";

                    console.log(error);
                });
        });
    }
</script>

</body>
</html>