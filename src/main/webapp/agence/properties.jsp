<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>
<%@ page import="java.util.List" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    int pageNumber = 1;
    int limit = 6;

    if (request.getParameter("page") != null) {
        pageNumber = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (pageNumber - 1) * limit;

    PropertyDAO dao = new PropertyDAO();
    List<Property> properties = dao.getByAgencePaginated(agence.getId(), offset, limit);

    int totalProperties = dao.countByAgence(agence.getId());
    int totalPages = (int) Math.ceil((double) totalProperties / limit);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion propriétés</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=200">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <div class="luxury-header">
            <span>REAL ESTATE</span>
            <h1>Gestion des propriétés</h1>
            <p>Ajoutez, modifiez et gérez vos biens immobiliers.</p>
        </div>

        <% if(request.getParameter("success") != null) { %>
        <div class="success">Opération effectuée avec succès.</div>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
        <div class="error">Erreur lors de l'opération.</div>
        <% } %>

        <section class="form-card">
            <h2>Ajouter une propriété</h2>

            <form action="<%=request.getContextPath()%>/agence/add-property"
                  method="post"
                  enctype="multipart/form-data"
                  class="property-form">

                <div class="form-group">
                    <label>Titre</label>
                    <input type="text" name="titre" placeholder="Ex: Villa luxe" required>
                </div>

                <div class="form-group">
                    <label>Ville</label>
                    <input type="text" name="ville" placeholder="Casablanca" required>
                </div>

                <div class="form-group full">
                    <label>Adresse</label>
                    <input type="text" name="adresse" placeholder="Maarif, Casablanca" required>
                </div>

                <div class="form-group">
                    <label>Type</label>
                    <select name="type" required>
                        <option value="Maison">Maison</option>
                        <option value="Appartement">Appartement</option>
                        <option value="Villa">Villa</option>
                        <option value="Riad">Riad</option>
                        <option value="Studio">Studio</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Opération</label>
                    <select name="operation" required>
                        <option value="À louer">À louer</option>
                        <option value="À vendre">À vendre</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Prix</label>
                    <input type="number" name="prix" placeholder="4500" required>
                </div>

                <div class="form-group">
                    <label>Surface m²</label>
                    <input type="number" name="surface" placeholder="120" required>
                </div>

                <div class="form-group">
                    <label>Chambres</label>
                    <input type="number" name="chambres" placeholder="3" required>
                </div>

                <div class="form-group">
                    <label>Statut</label>
                    <select name="statut">
                        <option value="disponible">Disponible</option>
                        <option value="vendu">Vendu</option>
                        <option value="loue">Loué</option>
                    </select>
                </div>

                <div class="form-group full">
                    <label>Image principale URL</label>
                    <input type="text" name="image" placeholder="https://...">
                </div>

                <div class="form-group full">
                    <label>Autres images par liens</label>
                    <textarea name="imageLinks"
                              placeholder="Collez chaque lien image dans une nouvelle ligne"></textarea>
                </div>

                <div class="form-group full">
                    <label>Upload plusieurs images</label>
                    <input type="file" name="images" multiple accept="image/*">
                </div>

                <button class="btn-submit" type="submit">Ajouter la propriété</button>
            </form>
        </section>

        <section class="list-card">
            <h2>Liste des propriétés</h2>

            <div class="property-grid compact-property-grid">

                <% if(properties.isEmpty()) { %>
                <div class="empty-box">Aucune propriété trouvée.</div>
                <% } %>

                <% for(Property p : properties) {
                    String statut = p.getStatut() != null ? p.getStatut() : "disponible";
                %>

                <div class="property-card compact-card">

                    <div class="card-menu">
                        <button type="button" onclick="toggleMenu(this)">⋯</button>

                        <div class="menu-box">
                            <a href="<%=request.getContextPath()%>/agence/change-statut?id=<%=p.getId()%>&statut=disponible">
                                Marquer disponible
                            </a>

                            <a href="<%=request.getContextPath()%>/agence/change-statut?id=<%=p.getId()%>&statut=vendu">
                                Marquer vendu
                            </a>

                            <a href="<%=request.getContextPath()%>/agence/change-statut?id=<%=p.getId()%>&statut=loue">
                                Marquer loué
                            </a>

                            <a href="<%=request.getContextPath()%>/agence/edit-property.jsp?id=<%= p.getId() %>">
                                Modifier
                            </a>

                            <a class="danger"
                               href="<%=request.getContextPath()%>/agence/delete-property?id=<%= p.getId() %>"
                               onclick="return confirm('Voulez-vous vraiment supprimer cette propriété ?');">
                                Supprimer
                            </a>
                        </div>
                    </div>

                    <img src="<%= p.getImage() %>" alt="Image propriété">

                    <div class="property-info">

                        <div class="top">
                            <span class="tag"><%= p.getOperation() %></span>
                            <span class="status <%= statut %>"><%= statut %></span>
                        </div>

                        <h3><%= p.getTitre() %></h3>
                        <p><%= p.getVille() %> - <%= p.getAdresse() %></p>

                        <div class="meta">
                            <span><%= p.getType() %></span>
                            <span><%= p.getSurface() %> m²</span>
                            <span><%= p.getChambres() %> chambres</span>
                        </div>

                        <h4><%= p.getPrix() %> DH</h4>

                    </div>
                </div>

                <% } %>

            </div>

            <div class="pagination">
                <% for(int i = 1; i <= totalPages; i++) { %>
                <a class="<%= (i == pageNumber) ? "active" : "" %>"
                   href="<%=request.getContextPath()%>/agence/properties.jsp?page=<%= i %>">
                    <%= i %>
                </a>
                <% } %>
            </div>

        </section>

    </main>

</div>

<script>
    function toggleMenu(btn) {
        const menu = btn.nextElementSibling;

        document.querySelectorAll('.menu-box').forEach(m => {
            if (m !== menu) {
                m.style.display = 'none';
            }
        });

        menu.style.display = (menu.style.display === 'block') ? 'none' : 'block';
    }

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.card-menu')) {
            document.querySelectorAll('.menu-box').forEach(m => {
                m.style.display = 'none';
            });
        }
    });
</script>

</body>
</html>