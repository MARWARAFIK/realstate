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
    <meta charset="UTF-8">
    <title>REAL ESTATE</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/home.css?v=1200">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>

<header class="home-hero">

    <nav class="mh-navbar">
        <a class="mh-logo" href="<%=request.getContextPath()%>/client/home.jsp">
            REAL <br><span>ESTATE</span>
        </a>

        <div class="mh-menu">
            <a class="active" href="<%=request.getContextPath()%>/client/home.jsp">Home</a>
            <a href="#about">About</a>
            <a href="#services">Services</a>
            <a href="<%=request.getContextPath()%>/client/properties.jsp">Properties</a>

            <a href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
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

    <div class="home-content">
        <h1>FIND YOUR <br> FUTURE HOME</h1>

        <div class="mh-line"></div>

        <p>Luxury Real Estate Experience</p>

        <span>
            Découvrez les meilleures villas, appartements et maisons modernes
            avec une expérience immersive et premium.
        </span>

        <div class="hero-buttons">
            <a href="<%=request.getContextPath()%>/client/properties.jsp" class="hero-btn">
                Explorer les biens
            </a>

            <a href="#virtual" class="hero-btn-outline">
                Visite 3D
            </a>
        </div>
    </div>

</header>

<section class="about-section" id="about">
    <div class="about-img"></div>

    <div class="about-content">
        <span>ABOUT US</span>
        <h2>Votre agence immobilière moderne</h2>
        <p>
            REAL ESTATE vous accompagne dans la recherche, la vente et la location
            de biens immobiliers avec un service professionnel et moderne.
        </p>
    </div>
</section>

<section class="services-section" id="services">
    <div class="section-heading">
        <span>WHAT WE DO</span>
        <h2>Nos Services</h2>
        <p>Achat, location, réservation et visite virtuelle.</p>
    </div>

    <div class="services-grid">
        <div class="service-card service-1">
            <h3>Achat</h3>
            <p>Trouvez la maison idéale selon votre budget.</p>
        </div>

        <div class="service-card service-2">
            <h3>Location</h3>
            <p>Consultez les meilleures offres disponibles.</p>
        </div>

        <div class="service-card service-3">
            <h3>Réservation</h3>
            <p>Réservez directement un bien immobilier.</p>
        </div>
    </div>
</section>

<section class="virtual-section" id="virtual">
    <div class="virtual-content">
        <span>IMMERSIVE EXPERIENCE</span>
        <h2>Visite virtuelle 3D</h2>
        <p>
            Explorez les biens immobiliers avant de vous déplacer grâce à la
            technologie 3D.
        </p>

        <a href="<%=request.getContextPath()%>/client/properties.jsp" class="hero-btn">
            Voir les visites 3D
        </a>
    </div>

    <div class="phone-mockup">
        <div class="phone-screen">
            <i class="fa-solid fa-cube"></i>
            <h3>3D TOUR</h3>
            <p>Kitchen • Salon • Bedroom</p>
        </div>
    </div>
</section>

<section class="trending-section">
    <div class="section-heading">
        <span>TRENDING ESTATE</span>
        <h2>Most Liked Properties</h2>
        <p>Les biens immobiliers les plus aimés.</p>
    </div>

    <div class="trending-grid">

        <% if(trendingProperties == null || trendingProperties.isEmpty()) { %>
        <div class="empty-trending">
            Aucune propriété populaire.
        </div>
        <% } else { %>

        <% for(Property p : trendingProperties) { %>

        <div class="trending-card">
            <img src="<%= p.getImage() %>" alt="property">

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

                <div class="card-actions">
                    <a href="<%=request.getContextPath()%>/client/property-details.jsp?id=<%= p.getId() %>">
                        Voir détails
                    </a>

                    <a class="tour-link" href="#virtual">
                        3D Tour
                    </a>
                </div>
            </div>
        </div>

        <% } %>

        <% } %>

    </div>
</section>

<%@ include file="footer.jsp" %>
</body>
</html>