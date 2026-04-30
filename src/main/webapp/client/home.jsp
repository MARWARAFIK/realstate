<%@ page import="client.model.Client" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Client client = (Client) session.getAttribute("client");

    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    PropertyDAO propertyDAO = new PropertyDAO();
    List<Property> trendingProperties = propertyDAO.getMostLiked(3);

    MessageDAO notifDao = new MessageDAO();
    int notifCount = notifDao.countClientNotifications(client.getId());
%>

<!DOCTYPE html>
<html lang="fr">
<head>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css">
    <meta charset="UTF-8">
    <title>REAL ESTATE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css?v=200">
</head>
<body>

<section class="home-hero">

    <div class="home-menu-box">
        <h1 class="home-logo">
            REAL<br>ESTATE
        </h1>

        <nav class="home-side-menu">
            <a class="active" href="<%=request.getContextPath()%>/client/home.jsp">HOME</a>
            <a href="#about">ABOUT</a>
            <a href="#services">SERVICES</a>
            <a href="<%=request.getContextPath()%>/client/properties.jsp">PROPERTIES</a>
            <a href="<%=request.getContextPath()%>/client/profile.jsp">PROFILE</a>
            <a href="<%=request.getContextPath()%>/client/contact.jsp">CONTACTS</a>
            <a href="<%=request.getContextPath()%>/client/logout">LOGOUT</a>
        </nav>


        <p class="welcome">Bienvenue <%= client.getNom() %></p>
    </div>
    <a href="<%=request.getContextPath()%>/client/notifications.jsp" class="home-notif-icon">
        🔔
        <% if(notifCount > 0) { %>
        <span><%= notifCount %></span>
        <% } %>
    </a>

</section>

<section class="about-section" id="about">
    <h2>Votre agence immobilière moderne</h2>
    <p>
        REAL ESTATE vous accompagne dans la recherche, la vente et la location
        de biens immobiliers avec un service simple, rapide et professionnel.
        Découvrez des biens sélectionnés avec soin pour une expérience immobilière
        moderne et luxueuse.
    </p>
</section>

<section class="services-section" id="services">
    <h2>Nos Services</h2>

    <div class="services-grid">
        <div>
            <h3>Achat</h3>
            <p>Trouvez la maison, villa ou appartement idéal selon votre budget.</p>
        </div>

        <div>
            <h3>Location</h3>
            <p>Consultez les meilleures offres de location disponibles.</p>
        </div>

        <div>
            <h3>Réservation</h3>
            <p>Réservez un bien directement et contactez l’agence facilement.</p>
        </div>
    </div>
</section>

<section class="trending-section">
    <div class="section-heading">
        <span>TRENDING ESTATE</span>
        <h2>Most Liked Properties</h2>
        <p>Les biens immobiliers les plus aimés par nos clients.</p>
    </div>

    <div class="trending-grid">

        <% if(trendingProperties.isEmpty()) { %>
        <div class="empty-trending">
            Aucune propriété populaire pour le moment.
        </div>
        <% } %>

        <% for(Property p : trendingProperties) { %>

        <div class="trending-card">
            <img src="<%= p.getImage() %>" alt="Image propriété">

            <div class="trending-info">
                <div class="trending-top">
                    <span><%= p.getOperation() %></span>
                    <small>♥ <%= propertyDAO.countLikes(p.getId()) %></small>
                </div>

                <h3><%= p.getTitre() %></h3>
                <p><%= p.getVille() %> - <%= p.getAdresse() %></p>

                <div class="trending-meta">
                    <small><%= p.getType() %></small>
                    <small><%= p.getSurface() %> m²</small>
                    <small><%= p.getChambres() %> chambres</small>
                </div>

                <h4><%= p.getPrix() %> DH</h4>

                <a href="<%=request.getContextPath()%>/client/property-details.jsp?id=<%= p.getId() %>">
                    Voir détails
                </a>
            </div>
        </div>

        <% } %>

    </div>
</section>
<%@ include file="footer.jsp" %>
</body>
</html>