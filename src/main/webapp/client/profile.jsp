<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="property.model.Property" %>
<%@ page import="java.util.List" %>
<%@ page import="client.dao.ClientDAO" %>
<%@ page import="message.dao.MessageDAO" %>

<%
    Client client = (Client) session.getAttribute("client");

    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    ClientDAO dao = new ClientDAO();
    List<Property> likedProperties = dao.getLikedProperties(client.getId());

    MessageDAO notifDao = new MessageDAO();
    int notifCount = notifDao.countClientNotifications(client.getId());
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Profile Client</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css?v=12000">
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
            <a class="active" href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
            <a href="<%=request.getContextPath()%>/client/contact.jsp">Contact</a>
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
        <h1>MON<br>PROFILE</h1>
        <div class="mh-line"></div>
        <p>Bienvenue, <%= client.getNom() %></p>
        <span>Vos informations et propriétés aimées</span>
    </div>

</header>

<section class="client-page no-side">

    <div class="content">

        <div class="profile-card password-card">
            <div>
                <h2>Changer le mot de passe</h2>
                <p>Modifiez votre mot de passe actuel.</p>

                <% if(request.getParameter("passSuccess") != null) { %>
                <div class="success-message">Mot de passe modifié avec succès.</div>
                <% } %>

                <% if(request.getParameter("passError") != null) { %>
                <div class="error-message">Ancien mot de passe incorrect ou erreur.</div>
                <% } %>

                <form action="<%=request.getContextPath()%>/client/change-password" method="post" class="password-form">
                    <input type="password" name="oldPassword" placeholder="Ancien mot de passe" required>
                    <input type="password" name="newPassword" placeholder="Nouveau mot de passe" required>
                    <input type="password" name="confirmPassword" placeholder="Confirmer le mot de passe" required>

                    <button type="submit">Changer password</button>
                </form>
            </div>
        </div>

        <h2>Propriétés aimées</h2>
        <p class="subtitle">Les biens que vous avez ajoutés à vos favoris.</p>

        <div class="property-grid" id="likedGrid">

            <% if(likedProperties.isEmpty()) { %>
            <div class="empty-profile">
                Vous n'avez encore aimé aucune propriété.
            </div>
            <% } %>

            <% for(Property p : likedProperties) { %>

            <div class="property-card" id="property-<%= p.getId() %>">
                <img src="<%= p.getImage() %>" alt="Image propriété">

                <div class="property-info">
                    <span class="tag"><%= p.getOperation() %></span>

                    <h3><%= p.getTitre() %></h3>
                    <p><%= p.getVille() %> - <%= p.getAdresse() %></p>

                    <div class="meta">
                        <span><%= p.getType() %></span>
                        <span><%= p.getSurface() %> m²</span>
                        <span><%= p.getChambres() %> chambres</span>
                    </div>

                    <h4><%= p.getPrix() %> DH</h4>

                    <div class="client-card-actions">

                        <button class="like-btn liked ajax-remove-btn"
                                type="button"
                                data-id="<%= p.getId() %>"
                                onclick="removeFavorite(this)">
                            <i class="fa-solid fa-heart-crack"></i>
                            Retirer
                        </button>

                        <a class="btn-details"
                           href="<%=request.getContextPath()%>/client/property-details.jsp?id=<%= p.getId() %>">
                            Voir détails
                        </a>

                    </div>
                </div>
            </div>

            <% } %>

        </div>

    </div>

</section>

<%@ include file="footer.jsp" %>

<script>
    function removeFavorite(btn) {
        const propertyId = btn.getAttribute("data-id");
        const card = document.getElementById("property-" + propertyId);

        btn.disabled = true;
        btn.innerHTML = "<i class='fa-solid fa-spinner fa-spin'></i> Suppression...";

        fetch("<%=request.getContextPath()%>/client/like-property-ajax?id=" + propertyId)
            .then(response => response.text())
            .then(data => {
                if (data.trim() === "unliked") {
                    card.style.opacity = "0";
                    card.style.transform = "translateY(20px)";

                    setTimeout(() => {
                        card.remove();

                        const cards = document.querySelectorAll(".property-card");

                        if (cards.length === 0) {
                            document.getElementById("likedGrid").innerHTML =
                                "<div class='empty-profile'>Vous n'avez encore aimé aucune propriété.</div>";
                        }
                    }, 400);
                } else {
                    btn.disabled = false;
                    btn.innerHTML = "<i class='fa-solid fa-heart-crack'></i> Retirer";
                }
            })
            .catch(error => {
                console.log(error);
                btn.disabled = false;
                btn.innerHTML = "<i class='fa-solid fa-heart-crack'></i> Retirer";
            });
    }
</script>

</body>
</html>