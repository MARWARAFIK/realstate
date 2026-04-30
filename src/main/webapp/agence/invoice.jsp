<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="contract.dao.ContractDAO" %>
<%@ page import="contract.model.Contract" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    String idParam = request.getParameter("contractId");

    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp?error=missingContract");
        return;
    }

    int contractId = Integer.parseInt(idParam);

    ContractDAO dao = new ContractDAO();
    Contract c = dao.getById(contractId);

    if (c == null || c.getAgenceId() != agence.getId()) {
        response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp?error=notfound");
        return;
    }

    String numero = dao.getInvoiceNumeroByContract(contractId);
    if (numero == null || numero.trim().isEmpty()) {
        numero = "FAC-" + c.getId();
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Facture <%= numero %></title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=9000">
</head>
<body>

<div class="invoice-page">

    <div class="invoice-card" id="invoice">

        <div class="invoice-head">
            <div>
                <h1>REAL ESTATE</h1>
                <p>Agence immobilière</p>
            </div>

            <div class="invoice-number">
                <h2>FACTURE</h2>
                <p>N° <%= numero %></p>
                <p>Date: <%= c.getDateCreation() %></p>
            </div>
        </div>

        <div class="invoice-info">
            <div>
                <h3>Agence</h3>
                <p><b><%= agence.getNom() %></b></p>
                <p><%= agence.getEmail() != null ? agence.getEmail() : "" %></p>
                <p><%= agence.getTelephone() != null ? agence.getTelephone() : "" %></p>
                <p><%= agence.getAdresse() != null ? agence.getAdresse() : "" %></p>
            </div>

            <div>
                <h3>Client</h3>
                <p><b><%= c.getClientNom() %></b></p>
                <p><%= c.getClientEmail() %></p>
            </div>
        </div>

        <table class="invoice-table">
            <thead>
            <tr>
                <th>Description</th>
                <th>Type contrat</th>
                <th>Date début</th>
                <th>Date fin</th>
                <th>Montant</th>
            </tr>
            </thead>

            <tbody>
            <tr>
                <td><%= c.getPropertyTitle() %> - <%= c.getPropertyVille() %></td>
                <td><%= c.getTypeContrat() %></td>
                <td><%= c.getDateDebut() %></td>
                <td><%= c.getDateFin() != null ? c.getDateFin() : "-" %></td>
                <td><%= c.getMontant() %> DH</td>
            </tr>
            </tbody>
        </table>

        <div class="invoice-total">
            Total à payer: <%= c.getMontant() %> DH
        </div>

        <div class="invoice-conditions">
            <h3>Conditions du contrat</h3>
            <pre><%= c.getConditions() != null ? c.getConditions() : "" %></pre>
        </div>

        <div class="invoice-signatures">
            <div>
                <p>Signature agence</p>
                <div class="sign-line"></div>
            </div>

            <div>
                <p>Signature client</p>
                <div class="sign-line"></div>
            </div>
        </div>

    </div>

    <div class="invoice-actions">
        <button onclick="window.print()">Télécharger / Imprimer PDF</button>
        <a href="<%=request.getContextPath()%>/agence/client-contracts.jsp">Retour</a>
    </div>

</div>

</body>
</html>