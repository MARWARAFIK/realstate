<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="client.dao.ClientDAO" %>

<%
  Agence agence = (Agence) session.getAttribute("agence");

  if (agence == null) {
    response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
    return;
  }

  PropertyDAO propertyDao = new PropertyDAO();
  MessageDAO messageDao = new MessageDAO();
  ClientDAO clientDao = new ClientDAO();

  int totalProperties = propertyDao.countByAgence(agence.getId());

  int totalReservations = messageDao.getByAgenceAndType(agence.getId(), "Reservation").size();
  int totalMessages = messageDao.getByAgenceAndType(agence.getId(), "Contact").size();

  int totalClients = clientDao.getAllWithStats().size();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Dashboard Agence</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=500">
</head>
<body>

<div class="admin-page">

  <%@ include file="layout.jsp" %>

  <main class="admin-content">

    <div class="luxury-header">
      <span>REAL ESTATE</span>
      <h1>Dashboard</h1>
      <p>Bienvenue, <%= agence.getNom() %>. Voici un aperçu de votre agence.</p>
    </div>

    <section class="dashboard-grid">

      <div class="dash-card">
        <span>Propriétés</span>
        <h2><%= totalProperties %></h2>
        <p>Biens publiés par votre agence</p>
        <a href="<%=request.getContextPath()%>/agence/properties.jsp">Voir propriétés</a>
      </div>

      <div class="dash-card">
        <span>Réservations</span>
        <h2><%= totalReservations %></h2>
        <p>Demandes de réservation reçues</p>
        <a href="<%=request.getContextPath()%>/agence/reservations.jsp">Voir réservations</a>
      </div>

      <div class="dash-card">
        <span>Messages</span>
        <h2><%= totalMessages %></h2>
        <p>Messages envoyés par les clients</p>
        <a href="<%=request.getContextPath()%>/agence/messages.jsp">Voir messages</a>
      </div>

      <div class="dash-card">
        <span>Clients</span>
        <h2><%= totalClients %></h2>
        <p>Clients inscrits sur la plateforme</p>
        <a href="<%=request.getContextPath()%>/agence/clients.jsp">Voir clients</a>
      </div>

    </section>

    <section class="dashboard-panel">
      <h2>Actions rapides</h2>

      <div class="quick-actions">
        <a href="<%=request.getContextPath()%>/agence/properties.jsp">Ajouter une propriété</a>
        <a href="<%=request.getContextPath()%>/agence/messages.jsp">Consulter messages</a>
        <a href="<%=request.getContextPath()%>/agence/reservations.jsp">Gérer réservations</a>
        <a href="<%=request.getContextPath()%>/agence/settings.jsp">Paramètres agence</a>
      </div>
    </section>

  </main>

</div>

</body>
</html>