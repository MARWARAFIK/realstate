<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="client.dao.ClientDAO" %>
<%@ page import="client.model.Client" %>
<%@ page import="property.dao.PropertyDAO" %>
<%@ page import="property.model.Property" %>
<%@ page import="contract.dao.ContractDAO" %>
<%@ page import="contract.model.Contract" %>
<%@ page import="java.util.List" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");
    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    ClientDAO clientDAO = new ClientDAO();
    PropertyDAO propertyDAO = new PropertyDAO();
    ContractDAO contractDAO = new ContractDAO();

    List<Client> clients = clientDAO.getAll();
    List<Property> properties = propertyDAO.getAll();
    List<Contract> contracts = contractDAO.getByAgence(agence.getId());
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Contrats clients</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=7000">
</head>
<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <section class="glass-card big-form">
            <h1>Nouveau contrat</h1>
            <p>Associez un client à un bien loué ou acheté et générez une facture.</p>

            <% if(request.getParameter("success") != null) { %>
            <div class="success">Contrat créé avec succès. Facture générée.</div>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
            <div class="error">Erreur lors de la création du contrat.</div>
            <% } %>

            <form action="<%=request.getContextPath()%>/agence/create-contract" method="post">

                <div class="form-grid">

                    <div>
                        <label>Client</label>
                        <select name="clientId" required>
                            <% for(Client c : clients){ %>
                            <option value="<%=c.getId()%>">
                                <%= c.getNom() %> - <%= c.getEmail() %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label>Bien immobilier</label>
                        <select name="propertyId" id="propertySelect" required>
                            <% for(Property p : properties){ %>
                            <option value="<%=p.getId()%>" data-prix="<%=p.getPrix()%>">
                                <%= p.getTitre() %> - <%= p.getVille() %> - <%= p.getStatut() %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label>Type contrat</label>
                        <select name="typeContrat" id="typeContrat" required onchange="changeContractType()">
                            <option value="ACHAT">Achat</option>
                            <option value="LOCATION">Location</option>
                        </select>
                    </div>

                    <div>
                        <label>Montant facture (DH)</label>
                        <input type="number" step="0.01" name="montant" id="prixInput" required>
                    </div>

                    <div>
                        <label>Date début / signature</label>
                        <input type="date" name="dateDebut" required>
                    </div>

                    <div id="dateFinBox">
                        <label>Date fin location</label>
                        <input type="date" name="dateFin">
                    </div>
                </div>

                <div class="full contract-box" id="achatBox">
                    <h3>Formule Achat</h3>

                    <div class="form-grid">
                        <div>
                            <label>Prix total</label>
                            <input type="number" step="0.01" name="prixTotal" placeholder="Ex: 550000">
                        </div>

                        <div>
                            <label>Avance</label>
                            <input type="number" step="0.01" name="avance" placeholder="Ex: 50000">
                        </div>

                        <div>
                            <label>Frais notaire</label>
                            <input type="number" step="0.01" name="fraisNotaire" placeholder="Ex: 12000">
                        </div>

                        <div>
                            <label>Mode paiement</label>
                            <select name="modePaiement">
                                <option value="Cash">Cash</option>
                                <option value="Crédit bancaire">Crédit bancaire</option>
                                <option value="Chèque">Chèque</option>
                                <option value="Virement bancaire">Virement bancaire</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="full contract-box" id="locationBox" style="display:none;">
                    <h3>Formule Location</h3>

                    <div class="form-grid">
                        <div>
                            <label>Loyer mensuel</label>
                            <input type="number" step="0.01" name="loyer" placeholder="Ex: 4500">
                        </div>

                        <div>
                            <label>Caution</label>
                            <input type="number" step="0.01" name="caution" placeholder="Ex: 9000">
                        </div>

                        <div>
                            <label>Charges</label>
                            <input type="number" step="0.01" name="charges" placeholder="Ex: 300">
                        </div>

                        <div>
                            <label>Durée location (mois)</label>
                            <input type="number" name="duree" placeholder="Ex: 12">
                        </div>
                    </div>
                </div>

                <div class="full">
                    <label>Conditions générales</label>
                    <textarea name="conditions" placeholder="Paiement, obligations, résiliation, frais..."></textarea>
                </div>

                <button class="btn-main" type="submit">Créer contrat + facture</button>
            </form>
        </section>

        <section class="list-card">
            <h2>Contrats existants</h2>

            <div class="contracts-grid">
                <% if(contracts.isEmpty()) { %>
                <div class="empty-box">Aucun contrat pour le moment.</div>
                <% } %>

                <% for(Contract c : contracts) { %>
                <div class="contract-card">
                    <div class="contract-top">
                        <span><%= c.getTypeContrat() %></span>
                        <b><%= c.getStatut() %></b>
                    </div>

                    <h3><%= c.getPropertyTitle() %></h3>
                    <p><%= c.getPropertyVille() %></p>

                    <div class="contract-info">
                        <p><b>Client:</b> <%= c.getClientNom() %></p>
                        <p><b>Email:</b> <%= c.getClientEmail() %></p>
                        <p><b>Début:</b> <%= c.getDateDebut() %></p>
                        <p><b>Fin:</b> <%= c.getDateFin() != null ? c.getDateFin() : "-" %></p>
                        <p><b>Montant:</b> <%= c.getMontant() %> DH</p>
                    </div>

                    <div class="contract-actions">
                        <a class="invoice-btn"
                           href="<%=request.getContextPath()%>/agence/invoice.jsp?contractId=<%= c.getId() %>">
                            Voir / Télécharger facture
                        </a>
                        <a class="delete-btn"
                           onclick="return confirm('Supprimer ce contrat ?')"
                           href="<%=request.getContextPath()%>/agence/delete-contract?id=<%= c.getId() %>">
                            Supprimer
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
        </section>

    </main>
</div>

<script>
    function setAutoPrice() {
        const select = document.getElementById("propertySelect");
        const prix = select.options[select.selectedIndex].dataset.prix;
        document.getElementById("prixInput").value = prix || "";

        const prixTotalInput = document.querySelector("input[name='prixTotal']");
        const loyerInput = document.querySelector("input[name='loyer']");

        if (prixTotalInput) prixTotalInput.value = prix || "";
        if (loyerInput) loyerInput.value = prix || "";
    }

    function changeContractType() {
        const type = document.getElementById("typeContrat").value;
        const dateFinBox = document.getElementById("dateFinBox");
        const dateFinInput = document.querySelector("input[name='dateFin']");
        const achatBox = document.getElementById("achatBox");
        const locationBox = document.getElementById("locationBox");

        if (type === "ACHAT") {
            dateFinBox.style.display = "none";
            dateFinInput.value = "";
            achatBox.style.display = "block";
            locationBox.style.display = "none";
        } else {
            dateFinBox.style.display = "block";
            achatBox.style.display = "none";
            locationBox.style.display = "block";
        }
    }

    document.getElementById("propertySelect").addEventListener("change", setAutoPrice);

    setAutoPrice();
    changeContractType();
</script>

</body>
</html>