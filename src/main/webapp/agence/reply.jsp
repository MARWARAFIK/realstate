<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="message.dao.MessageDAO" %>
<%@ page import="message.model.Message" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    MessageDAO dao = new MessageDAO();
    Message m = dao.getById(id);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Répondre</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/agence.css">
</head>
<body>

<div class="admin-page">
    <%@ include file="layout.jsp" %>

    <main class="admin-content">

        <div class="glass-card">

            <h1>Répondre au client</h1>

            <p><b>Client:</b> <%= m.getNom() %></p>
            <p><b>Email:</b> <%= m.getEmail() %></p>

            <form action="<%=request.getContextPath()%>/agence/send-reply" method="post">

                <input type="hidden" name="messageId" value="<%= m.getId() %>">

                <textarea name="reply" placeholder="Votre réponse..." required></textarea>

                <button class="btn-main">Envoyer réponse</button>

            </form>

        </div>

    </main>
</div>

</body>
</html>