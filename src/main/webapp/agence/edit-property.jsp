<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));

    PropertyDAO dao = new PropertyDAO();
    Property p = dao.getById(id);

    if (p == null || p.getAgenceId() != agence.getId()) {
        response.sendRedirect(request.getContextPath() + "/agence/properties.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier propriété</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <a class="back-admin" href="<%=request.getContextPath()%>/agence/properties.jsp">← Retour</a>

        <section class="form-card">
            <h2>Modifier la propriété</h2>

            <form action="<%=request.getContextPath()%>/agence/update-property" method="post" class="property-form">

                <input type="hidden" name="id" value="<%= p.getId() %>">

                <div class="form-group">
                    <label>Titre</label>
                    <input type="text" name="titre" value="<%= p.getTitre() %>" required>
                </div>

                <div class="form-group">
                    <label>Ville</label>
                    <input type="text" name="ville" value="<%= p.getVille() %>" required>
                </div>

                <div class="form-group full">
                    <label>Adresse</label>
                    <input type="text" name="adresse" value="<%= p.getAdresse() %>" required>
                </div>

                <div class="form-group">
                    <label>Type</label>
                    <select name="type" required>
                        <option value="Maison" <%= p.getType().equals("Maison") ? "selected" : "" %>>Maison</option>
                        <option value="Appartement" <%= p.getType().equals("Appartement") ? "selected" : "" %>>Appartement</option>
                        <option value="Villa" <%= p.getType().equals("Villa") ? "selected" : "" %>>Villa</option>
                        <option value="Riad" <%= p.getType().equals("Riad") ? "selected" : "" %>>Riad</option>
                        <option value="Studio" <%= p.getType().equals("Studio") ? "selected" : "" %>>Studio</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Opération</label>
                    <select name="operation" required>
                        <option value="À louer" <%= p.getOperation().equals("À louer") ? "selected" : "" %>>À louer</option>
                        <option value="À vendre" <%= p.getOperation().equals("À vendre") ? "selected" : "" %>>À vendre</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Prix</label>
                    <input type="number" name="prix" value="<%= p.getPrix() %>" required>
                </div>

                <div class="form-group">
                    <label>Surface m²</label>
                    <input type="number" name="surface" value="<%= p.getSurface() %>" required>
                </div>

                <div class="form-group">
                    <label>Chambres</label>
                    <input type="number" name="chambres" value="<%= p.getChambres() %>" required>
                </div>

                <div class="form-group full">
                    <label>Image URL</label>
                    <input type="text" name="image" value="<%= p.getImage() %>" required>
                </div>

                <button class="btn-submit" type="submit">Enregistrer les modifications</button>
            </form>
        </section>

    </main>

</div>

</body>
</html>