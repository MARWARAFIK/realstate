<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="java.net.URLEncoder" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    String location = agence.getMapLocation() != null ? agence.getMapLocation() : "";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Paramètres Agence</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <div class="page-header">
            <h1>Paramètres Agence</h1>
            <p>Modifiez les informations, l’image et la localisation de votre agence.</p>
        </div>

        <% if(request.getParameter("success") != null) { %>
        <div class="alert success">Informations enregistrées avec succès.</div>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
        <div class="alert error">Erreur lors de l'enregistrement.</div>
        <% } %>

        <section class="form-card">
            <h2>Informations agence</h2>

            <form action="<%=request.getContextPath()%>/agence/update-settings" method="post" class="property-form">

                <div class="form-group">
                    <label>Nom agence</label>
                    <input type="text" name="nom" value="<%= agence.getNom() != null ? agence.getNom() : "" %>" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= agence.getEmail() != null ? agence.getEmail() : "" %>" required>
                </div>

                <div class="form-group">
                    <label>Téléphone</label>
                    <input type="text" name="telephone" value="<%= agence.getTelephone() != null ? agence.getTelephone() : "" %>">
                </div>

                <div class="form-group">
                    <label>Ville</label>
                    <input type="text" name="ville" value="<%= agence.getVille() != null ? agence.getVille() : "" %>">
                </div>

                <div class="form-group full">
                    <label>Adresse</label>
                    <input type="text" name="adresse" value="<%= agence.getAdresse() != null ? agence.getAdresse() : "" %>">
                </div>

                <div class="form-group full">
                    <label>Localisation Google Map</label>
                    <input type="text" name="mapLocation" value="<%= location %>" placeholder="Ex: Casablanca Maarif Maroc">
                </div>

                <div class="form-group full">
                    <label>Image agence URL</label>
                    <input type="text" name="image" value="<%= agence.getImage() != null ? agence.getImage() : "" %>" placeholder="https://images.unsplash.com/...">
                </div>

                <div class="form-group full">
                    <label>Description</label>
                    <textarea name="description"><%= agence.getDescription() != null ? agence.getDescription() : "" %></textarea>
                </div>

                <button type="submit" class="btn-submit">Enregistrer</button>
            </form>
        </section>

        <section class="list-card">
            <h2>Aperçu image</h2>
            <img src="<%= agence.getImage() != null ? agence.getImage() : "" %>" style="width:100%; max-height:300px; object-fit:cover; border-radius:22px;">
        </section>

        <section class="list-card">
            <h2>Preview Map</h2>

            <iframe
                    src="https://www.google.com/maps?q=<%= URLEncoder.encode(location, "UTF-8") %>&output=embed"
                    width="100%"
                    height="350"
                    style="border:0; border-radius:22px;"
                    allowfullscreen
                    loading="lazy">
            </iframe>
        </section>

    </main>

</div>

</body>
</html>