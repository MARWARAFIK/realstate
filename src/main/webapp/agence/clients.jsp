<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="client.dao.ClientDAO" %>
<%@ page import="client.model.ClientView" %>
<%@ page import="java.util.List" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    ClientDAO dao = new ClientDAO();
    List<ClientView> clients = dao.getAllWithStats();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Clients</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=20">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <div class="luxury-header">
            <span>REAL ESTATE</span>
            <h1>Gestion des clients</h1>
        </div>

        <div class="client-filters">
            <button class="active" onclick="filterClients('all', event)">Tous</button>
            <button onclick="filterClients('fidele', event)">Clients fidèles</button>
            <button onclick="filterClients('profile', event)">Avec profil</button>
            <button onclick="filterClients('interaction', event)">Avec interactions</button>

            <input type="text" id="clientSearch" placeholder="Chercher client..." onkeyup="searchClient()">
        </div>

        <section class="clients-grid-pro">

            <% if (clients.isEmpty()) { %>
            <div class="empty-box">Aucun client trouvé.</div>
            <% } %>

            <% for (ClientView c : clients) { %>

            <div class="client-card-pro"
                 data-name="<%= c.getNom().toLowerCase() %>"
                 data-email="<%= c.getEmail().toLowerCase() %>"
                 data-fidele="<%= c.isFidele() ? "yes" : "no" %>"
                 data-profile="<%= c.hasProfile() ? "yes" : "no" %>"
                 data-interaction="<%= c.getTotalInteractions() > 0 ? "yes" : "no" %>">

                <div class="client-avatar">
                    <%= c.getNom().substring(0, 1).toUpperCase() %>
                </div>

                <div class="client-body">

                    <div class="client-top">
                        <h3><%= c.getNom() %></h3>

                        <% if (c.isFidele()) { %>
                        <span class="client-badge gold">Fidèle</span>
                        <% } else if (c.getTotalInteractions() > 0) { %>
                        <span class="client-badge green">Actif</span>
                        <% } else { %>
                        <span class="client-badge gray">Nouveau</span>
                        <% } %>
                    </div>

                    <p><b>Email:</b> <%= c.getEmail() %></p>
                    <p><b>Téléphone:</b> <%= c.getTelephone() != null ? c.getTelephone() : "Non défini" %></p>

                    <div class="client-stats">
                        <div>
                            <strong><%= c.getLikesCount() %></strong>
                            <span>Likes</span>
                        </div>

                        <div>
                            <strong><%= c.getMessagesCount() %></strong>
                            <span>Messages</span>
                        </div>

                        <div>
                            <strong><%= c.getReservationsCount() %></strong>
                            <span>Réservations</span>
                        </div>
                    </div>

                    <div class="client-actions-pro">
                        <a href="mailto:<%= c.getEmail() %>">Email</a>

                        <% if (c.getTelephone() != null && !c.getTelephone().trim().isEmpty()) { %>
                        <a href="tel:<%= c.getTelephone() %>">Appeler</a>
                        <% } %>
                    </div>

                </div>
            </div>

            <% } %>

        </section>

    </main>

</div>

<script>
    function filterClients(type, event) {
        let cards = document.querySelectorAll(".client-card-pro");
        let buttons = document.querySelectorAll(".client-filters button");

        buttons.forEach(btn => btn.classList.remove("active"));
        event.target.classList.add("active");

        document.getElementById("clientSearch").value = "";

        cards.forEach(card => {
            if (type === "all") {
                card.style.display = "flex";
            } else if (type === "fidele") {
                card.style.display = card.dataset.fidele === "yes" ? "flex" : "none";
            } else if (type === "profile") {
                card.style.display = card.dataset.profile === "yes" ? "flex" : "none";
            } else if (type === "interaction") {
                card.style.display = card.dataset.interaction === "yes" ? "flex" : "none";
            }
        });
    }

    function searchClient() {
        let value = document.getElementById("clientSearch").value.toLowerCase().trim();
        let cards = document.querySelectorAll(".client-card-pro");

        cards.forEach(card => {
            let name = card.dataset.name;
            let email = card.dataset.email;

            card.style.display = (name.includes(value) || email.includes(value)) ? "flex" : "none";
        });
    }
</script>

</body>
</html>