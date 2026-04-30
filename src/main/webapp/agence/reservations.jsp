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
    List<Message> reservations = dao.getByAgenceTypeAndStatus(agence.getId(), "Reservation", status);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Réservations</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <div class="page-header luxury-header">
            <div>
                <span>RESERVATIONS</span>
                <h1>Gestion des réservations</h1>
                <p>Consultez, répondez, marquez comme lu ou supprimez les réservations.</p>
            </div>
        </div>

        <div class="filter-box">
            <a class="<%= "all".equals(status) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/agence/reservations.jsp?status=all">Tous</a>

            <a class="<%= "Non lu".equals(status) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/agence/reservations.jsp?status=Non%20lu">Non lu</a>

            <a class="<%= "Lu".equals(status) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/agence/reservations.jsp?status=Lu">Lu</a>
        </div>

        <section class="messages-list luxury-list">

            <% if (reservations.isEmpty()) { %>
            <div class="empty-box">Aucune réservation pour le moment.</div>
            <% } %>

            <% for (Message r : reservations) { %>

            <div class="message-card luxury-message-card <%= "Non lu".equals(r.getStatut()) ? "unread" : "read" %>">

                <div class="card-menu">
                    <button class="menu-dots" type="button" onclick="toggleMenu(this)">⋯</button>

                    <div class="menu-content">
                        <a href="<%=request.getContextPath()%>/agence/reservation-details.jsp?id=<%= r.getId() %>">
                            Voir détails
                        </a>

                        <a href="<%=request.getContextPath()%>/agence/reply.jsp?id=<%= r.getId() %>" class="reply-email">
                            Répondre
                        </a>


                        <a href="tel:<%= r.getTelephone() %>">
                            Appeler
                        </a>

                        <% if ("Non lu".equals(r.getStatut())) { %>
                        <a href="<%=request.getContextPath()%>/agence/message-status?id=<%= r.getId() %>&statut=Lu&back=reservations">
                            Marquer lu
                        </a>
                        <% } else { %>
                        <a href="<%=request.getContextPath()%>/agence/message-status?id=<%= r.getId() %>&statut=Non%20lu&back=reservations">
                            Marquer non lu
                        </a>
                        <% } %>

                        <a class="danger"
                           onclick="return confirm('Supprimer cette réservation ?')"
                           href="<%=request.getContextPath()%>/agence/delete-message?id=<%= r.getId() %>&back=reservations">
                            Supprimer
                        </a>
                    </div>
                </div>

                <div class="message-top">
                    <span class="message-type">Réservation</span>

                    <span class="status-badge <%= "Non lu".equals(r.getStatut()) ? "badge-unread" : "badge-read" %>">
                        <%= r.getStatut() %>
                    </span>

                    <span class="message-date"><%= r.getDateMessage() %></span>
                </div>

                <div class="reservation-property">
                    <img src="<%= r.getPropertyImage() %>" alt="Image propriété">

                    <div>
                        <h3><%= r.getPropertyTitle() %></h3>
                        <p><%= r.getPropertyVille() %> - <%= r.getPropertyAdresse() %></p>
                        <p><%= r.getPropertyType() %> | <%= r.getPropertyPrix() %> DH</p>
                    </div>
                </div>

                <div class="client-info">
                    <p><b>Client:</b> <%= r.getNom() %></p>
                    <p><b>Email:</b> <%= r.getEmail() %></p>
                    <p><b>Téléphone:</b> <%= r.getTelephone() %></p>
                </div>

                <p class="message-text"><%= r.getMessage() %></p>

            </div>

            <% } %>

        </section>

    </main>

</div>

<script>
    function toggleMenu(btn) {
        const menu = btn.nextElementSibling;

        document.querySelectorAll('.menu-content').forEach(m => {
            if (m !== menu) {
                m.style.display = 'none';
            }
        });

        menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.card-menu')) {
            document.querySelectorAll('.menu-content').forEach(m => {
                m.style.display = 'none';
            });
        }
    });
</script>

</body>
</html>