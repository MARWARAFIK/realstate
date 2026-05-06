<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="agence.model.Agence" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="message.model.Message" %>

<%
    Agence agence = (Agence) session.getAttribute("agence");

    if (agence == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));

    MessageDAO dao = new MessageDAO();
    Message m = dao.getById(id);

    if (m == null || m.getAgenceId() != agence.getId()) {
        response.sendRedirect(request.getContextPath() + "/agence/messages.jsp");
        return;
    }

    String backPage = "Reservation".equalsIgnoreCase(m.getTypeMessage())
            ? "reservation-details.jsp"
            : "messages.jsp";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Répondre</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css?v=300">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="admin-page">

    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <a class="back-admin"
           href="<%=request.getContextPath()%>/agence/<%= backPage %><%= "Reservation".equalsIgnoreCase(m.getTypeMessage()) ? "?id=" + m.getId() : "" %>">
            <i class="fa-solid fa-arrow-left"></i>
            Retour
        </a>

        <section class="form-card">

            <h2>Répondre au client</h2>

            <p class="reply-subtitle">
                Envoyez une réponse professionnelle au client.
            </p>

            <div id="ajaxReplyMessage"></div>

            <div class="reply-client-box">

                <div>
                    <span>Client</span>
                    <h3><%= m.getNom() %></h3>
                </div>

                <div>
                    <span>Email</span>
                    <p><%= m.getEmail() %></p>
                </div>

                <div>
                    <span>Téléphone</span>
                    <p><%= m.getTelephone() %></p>
                </div>

            </div>

            <form id="replyAjaxForm" class="property-form">

                <input type="hidden" name="messageId" value="<%= m.getId() %>">

                <div class="form-group full">
                    <label>Votre réponse</label>

                    <textarea
                            name="reply"
                            placeholder="Écrivez votre réponse ici..."
                            required></textarea>
                </div>

                <button class="btn-submit" type="submit" id="replyBtn">
                    <i class="fa-solid fa-paper-plane"></i>
                    Envoyer réponse
                </button>

            </form>

        </section>

    </main>

</div>

<script>
    const replyForm = document.getElementById("replyAjaxForm");

    replyForm.addEventListener("submit", function(e) {
        e.preventDefault();

        const form = this;
        const btn = document.getElementById("replyBtn");
        const box = document.getElementById("ajaxReplyMessage");

        btn.disabled = true;
        btn.innerHTML = "<i class='fa-solid fa-spinner fa-spin'></i> Envoi...";

        fetch("<%=request.getContextPath()%>/agence/send-reply", {
            method: "POST",
            body: new FormData(form)
        })
            .then(response => response.text())
            .then(data => {
                box.innerHTML = "<div class='success-message'>Réponse envoyée avec succès.</div>";

                form.querySelector("textarea[name='reply']").value = "";

                btn.disabled = false;
                btn.innerHTML = "<i class='fa-solid fa-paper-plane'></i> Envoyer réponse";
            })
            .catch(error => {
                box.innerHTML = "<div class='error-message'>Erreur serveur. Réessayez.</div>";

                btn.disabled = false;
                btn.innerHTML = "<i class='fa-solid fa-paper-plane'></i> Envoyer réponse";

                console.log(error);
            });
    });
</script>

</body>
</html>