<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mot de passe oublié</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
</head>
<body>

<div class="auth-page">
    <div class="auth-box">
        <h1>REAL ESTATE</h1>
        <h2>Mot de passe oublié</h2>

        <% if(request.getParameter("error") != null) { %>
        <p class="error">Email introuvable</p>
        <% } %>

        <form action="<%=request.getContextPath()%>/client/forgot-password" method="post">
            <input type="email" name="email" placeholder="Votre email" required>
            <button type="submit">Vérifier</button>
        </form>

        <p><a href="client-login.jsp">Retour login</a></p>
    </div>
</div>

</body>
</html>