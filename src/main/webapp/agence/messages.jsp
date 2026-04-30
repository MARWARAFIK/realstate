<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="message.model.Message" %>
<%@ page import="java.util.List" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    String status = request.getParameter("status");
    if (status == null || status.trim().isEmpty()) {
        status = "all";
    }

    MessageDAO dao = new MessageDAO();
    List<Message> messages = dao.getByAgenceTypeAndStatus(agence.getId(), "Contact", status);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Messages Clients</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css">
</head>
<body>

<div class="admin-page">
    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <!-- HEADER -->
        <div class="page-header luxury-header">
            <span>CLIENT MESSAGES</span>
            <h1>Messages Clients</h1>
            <p>Gérez vos messages facilement</p>
        </div>

        <!-- FILTER -->
        <div class="filter-box">
            <a class="<%= "all".equals(status) ? "active" : "" %>"
               href="?status=all">Tous</a>

            <a class="<%= "Non lu".equals(status) ? "active" : "" %>"
               href="?status=Non%20lu">Non lu</a>

            <a class="<%= "Lu".equals(status) ? "active" : "" %>"
               href="?status=Lu">Lu</a>
        </div>

        <!-- LIST -->
        <section class="messages-list luxury-list">

            <% if (messages.isEmpty()) { %>
            <div class="empty-box">Aucun message pour le moment.</div>
            <% } %>

            <% for (Message m : messages) { %>

            <div class="message-card luxury-message-card <%= "Non lu".equals(m.getStatut()) ? "unread" : "read" %>">

                <!-- MENU -->
                <div class="card-menu">
                    <button class="menu-dots" onclick="toggleMenu(this)">⋯</button>

                    <div class="menu-content">
                        <a href="<%=request.getContextPath()%>/agence/reply.jsp?id=<%= m.getId() %>" class="reply-email">
                             Répondre par email
                        </a>

                        <a href="tel:<%= m.getTelephone() %>" class="reply-phone">
                             Appeler
                        </a>

                        <% if ("Non lu".equals(m.getStatut())) { %>
                        <a href="message-status?id=<%= m.getId() %>&statut=Lu&back=messages">
                             Marquer lu
                        </a>
                        <% } else { %>
                        <a href="message-status?id=<%= m.getId() %>&statut=Non%20lu&back=messages">
                             Marquer non lu
                        </a>
                        <% } %>

                        <a class="danger"
                           onclick="return confirm('Supprimer ce message ?')"
                           href="delete-message?id=<%= m.getId() %>&back=messages">
                             Supprimer
                        </a>
                    </div>
                </div>


                <!-- HEADER -->
                <div class="message-top">
                    <span class="message-type"><%= m.getTypeMessage() %></span>

                    <span class="status-badge <%= "Non lu".equals(m.getStatut()) ? "badge-unread" : "badge-read" %>">
                        <%= m.getStatut() %>
                    </span>

                    <span class="message-date"><%= m.getDateMessage() %></span>
                </div>

                <!-- PROPERTY -->
                <% if (m.getPropertyTitle() != null && !m.getPropertyTitle().isEmpty()) { %>
                <div class="reservation-property">
                    <img src="<%= m.getPropertyImage() %>">
                    <div>
                        <h3><%= m.getPropertyTitle() %></h3>
                        <p><%= m.getPropertyVille() %></p>
                    </div>
                </div>
                <% } %>

                <!-- CLIENT -->
                <div class="client-info">
                    <p><b><%= m.getNom() %></b></p>
                    <p><%= m.getEmail() %></p>
                </div>

                <!-- MESSAGE -->
                <p class="message-text"><%= m.getMessage() %></p>

            </div>

            <% } %>

        </section>

    </main>
</div>

<!-- JS MENU -->
<script>
    function toggleMenu(btn) {
        const menu = btn.nextElementSibling;

        document.querySelectorAll('.menu-content').forEach(m => {
            if (m !== menu) m.style.display = 'none';
        });

        menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.card-menu')) {
            document.querySelectorAll('.menu-content').forEach(m => m.style.display = 'none');
        }
    });
</script>

</body>
</html>