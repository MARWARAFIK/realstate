<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="client.model.Client" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="message.model.Message" %>
<%@ page import="java.util.List" %>

<%
    Client client = (Client) session.getAttribute("client");

    if (client == null) {
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
        return;
    }

    MessageDAO dao = new MessageDAO();
    List<Message> notifications = dao.getRepliesByClient(client.getId());

    dao.markRepliesSeen(client.getId());
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/client-properties.css?v=5000">
</head>

<body>

<!-- HERO -->
<header class="contact-hero">
    <nav class="mh-navbar">
        <a class="mh-logo" href="<%=request.getContextPath()%>/client/home.jsp">
            REAL <br><span>ESTATE</span>
        </a>

        <div class="mh-menu">
            <a href="<%=request.getContextPath()%>/client/home.jsp">Home</a>
            <a href="<%=request.getContextPath()%>/client/properties.jsp">Properties</a>
            <a href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
            <a href="<%=request.getContextPath()%>/client/contact.jsp">Contact</a>
            <a class="active" href="#">🔔</a>
            <a href="<%=request.getContextPath()%>/client/logout">Logout</a>
        </div>
    </nav>

    <div class="contact-hero-content">
        <h1>NOTIFICATIONS</h1>
        <div class="mh-line"></div>
        <p>Vos réponses et alertes</p>
        <span>Restez informé des réponses des agences</span>
    </div>
</header>

<!-- PAGE -->
<div class="client-page">

    <h2>Vos notifications</h2>
    <p class="subtitle">Réponses reçues de l'agence.</p>

    <div class="notif-container">

        <% if(notifications.isEmpty()) { %>
        <div class="empty-profile">
            Aucune notification pour le moment.
        </div>
        <% } %>

        <% for(Message m : notifications) { %>

        <div class="notif-card">

            <div class="notif-icon">🔔</div>

            <div class="notif-content">
                <h3>Réponse agence</h3>

                <p class="notif-msg">
                    <b>Votre message:</b><br>
                    <%= m.getMessage() %>
                </p>

                <p class="notif-reply">
                    <b>Réponse:</b><br>
                    <%= m.getReply() %>
                </p>

                <span class="notif-date">
                    <%= m.getReplyDate() %>
                </span>
            </div>

        </div>

        <% } %>

    </div>

</div>

</body>
</html>