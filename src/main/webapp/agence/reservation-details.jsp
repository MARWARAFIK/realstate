<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="message.model.Message" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");
    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    String idParam = request.getParameter("id");

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/agence/reservations.jsp");
        return;
    }

    int id = Integer.parseInt(idParam);

    MessageDAO dao = new MessageDAO();
    Message r = dao.getById(id);

    if (r == null || r.getAgenceId() != agence.getId()) {
        response.sendRedirect(request.getContextPath() + "/agence/reservations.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails réservation</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=300">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <a class="back-admin" href="<%=request.getContextPath()%>/agence/reservations.jsp">
            ← Retour aux réservations
        </a>

        <section class="details-admin-card">

            <span class="message-type">Réservation</span>

            <h1>Détails de la réservation</h1>

            <p class="message-date"><%= r.getDateMessage() %></p>

            <div class="reservation-property big-property">
                <img src="<%= r.getPropertyImage() %>" alt="Image propriété">

                <div>
                    <h2><%= r.getPropertyTitle() %></h2>
                    <p><%= r.getPropertyVille() %> - <%= r.getPropertyAdresse() %></p>
                    <p><b>Type:</b> <%= r.getPropertyType() %></p>
                    <p><b>Prix:</b> <%= r.getPropertyPrix() %> DH</p>
                </div>
            </div>

            <div class="client-info big">
                <p><b>Client:</b> <%= r.getNom() %></p>
                <p><b>Email:</b> <%= r.getEmail() %></p>
                <p><b>Téléphone:</b> <%= r.getTelephone() %></p>
                <p><b>Statut:</b> <%= r.getStatut() %></p>
            </div>

            <div class="message-text">
                <%= r.getMessage() %>
            </div>
            <div class="reply-actions">

                <a class="reply-email"
                   href="<%=request.getContextPath()%>/agence/reply.jsp?id=<%= r.getId() %>">

                    <i class="fa-solid fa-paper-plane"></i>
                    Répondre

                </a>

                <a class="reply-phone"
                   href="tel:<%= r.getTelephone() %>">

                    <i class="fa-solid fa-phone"></i>
                    Appeler

                </a>

            </div>

        </section>

    </main>

</div>

</body>
</html>