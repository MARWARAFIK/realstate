<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>
<%@ page import="java.util.List" %>

<%
    Client client = (Client) session.getAttribute("client");
    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    PropertyDAO dao = new PropertyDAO();
    List<Property> properties = dao.getAll();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Properties</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css?v=7000">
</head>
<body>

<header class="contact-hero animate-hero">
    <nav class="mh-navbar">
        <a class="mh-logo" href="<%=request.getContextPath()%>/client/home.jsp">
            REAL <br><span>ESTATE</span>
        </a>

        <div class="mh-menu">
            <a href="<%=request.getContextPath()%>/client/home.jsp">Home</a>
            <a class="active" href="<%=request.getContextPath()%>/client/properties.jsp">Properties</a>
            <a href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
            <a href="<%=request.getContextPath()%>/client/contact.jsp">Contact</a>
            <a href="<%=request.getContextPath()%>/client/logout">Logout</a>
        </div>
    </nav>

    <div class="contact-hero-content animate-content">
        <h1>REAL ESTATE<br>PROPERTIES</h1>
        <div class="mh-line"></div>
        <p>Propriétés disponibles</p>
        <span>Découvrez les meilleurs biens immobiliers</span>
    </div>
</header>

<div class="client-page">

    <h2>Propriétés disponibles</h2>
    <p class="subtitle">Toutes les propriétés ajoutées par les agences.</p>

    <div class="filters">
        <button class="active" onclick="filterCards('all', event)">Toutes</button>
        <button onclick="filterCards('À louer', event)">À louer</button>
        <button onclick="filterCards('À vendre', event)">À vendre</button>
        <button onclick="filterCards('Appartement', event)">Appartement</button>
        <button onclick="filterCards('Villa', event)">Villa</button>
        <button onclick="filterCards('Maison', event)">Maison</button>
        <input type="text" id="citySearch" placeholder="Chercher par ville..." onkeyup="searchCity()">
    </div>

    <div class="property-grid">

        <% if (properties.isEmpty()) { %>
        <div class="empty-profile">Aucune propriété disponible.</div>
        <% } %>

        <% for(Property p : properties){
            String statut = p.getStatut() != null ? p.getStatut() : "disponible";
            boolean liked = dao.isLikedByClient(p.getId(), client.getId());
        %>
        <div class="property-card"
             data-operation="<%= p.getOperation() != null ? p.getOperation().toLowerCase().trim() : "" %>"
             data-type="<%= p.getType() != null ? p.getType().toLowerCase().trim() : "" %>"
             data-ville="<%= p.getVille() != null ? p.getVille().toLowerCase().trim() : "" %>">

            <img src="<%= p.getImage() %>" alt="Image propriété">

            <div class="property-info">

                <div class="card-tags">
                    <span class="tag"><%= p.getOperation() %></span>
                    <span class="property-status <%= statut %>"><%= statut %></span>
                </div>

                <h3><%= p.getTitre() %></h3>
                <p><%= p.getVille() %> - <%= p.getAdresse() %></p>

                <div class="meta">
                    <span><%= p.getType() %></span>
                    <span><%= p.getSurface() %> m²</span>
                    <span><%= p.getChambres() %> chambres</span>
                </div>

                <h4><%= p.getPrix() %> DH</h4>

                <div class="actions">

                    <a href="javascript:void(0)"
                       class="like <%= liked ? "liked" : "" %>"
                       data-id="<%= p.getId() %>"
                       onclick="toggleLike(this)">
                        <%= liked ? "💔 Retirer" : "❤️ Like" %>
                    </a>

                    <a href="<%=request.getContextPath()%>/client/property-details.jsp?id=<%=p.getId()%>" class="details">
                        Voir détails
                    </a>
                </div>
            </div>
        </div>

        <% } %>

    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
    let currentFilter = "all";

    function filterCards(value, event) {
        currentFilter = value.toLowerCase().trim();

        document.querySelectorAll(".filters button").forEach(btn => {
            btn.classList.remove("active");
        });

        event.target.classList.add("active");
        applyFilters();
    }

    function searchCity() {
        applyFilters();
    }

    function applyFilters() {
        const cityInput = document.getElementById("citySearch").value.toLowerCase().trim();
        const cards = document.querySelectorAll(".property-card");

        cards.forEach(card => {
            const operation = card.getAttribute("data-operation") || "";
            const type = card.getAttribute("data-type") || "";
            const ville = card.getAttribute("data-ville") || "";

            const matchFilter =
                currentFilter === "all" ||
                operation === currentFilter ||
                type === currentFilter;

            const matchCity = ville.includes(cityInput);

            card.style.display = (matchFilter && matchCity) ? "block" : "none";
        });
    }

</script>
<script>
    function toggleLike(btn) {
        const propertyId = btn.getAttribute("data-id");

        fetch("<%=request.getContextPath()%>/client/like-property-ajax?id=" + propertyId)
            .then(response => response.text())
            .then(result => {
                if (result.trim() === "liked") {
                    btn.classList.add("liked");
                    btn.innerHTML = "💔 Retirer";
                } else if (result.trim() === "unliked") {
                    btn.classList.remove("liked");
                    btn.innerHTML = "❤️ Like";
                } else {
                    alert("Erreur like");
                }
            })
            .catch(error => {
                console.log(error);
                alert("Erreur serveur");
            });
    }
</script>
</body>
</html>