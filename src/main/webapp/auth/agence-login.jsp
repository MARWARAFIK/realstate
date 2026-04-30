<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login Agence</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="auth-page">
  <div class="auth-box">
    <h1>REAL ESTATE</h1>
    <h2>Connexion Agence</h2>

    <% if(request.getParameter("error") != null) { %>
    <p style="color:white; background:#c0392b; padding:10px; border-radius:12px; text-align:center;">
      Email ou mot de passe incorrect
    </p>
    <% } %>

    <form action="${pageContext.request.contextPath}/AgenceLogin" method="post">
      <input type="email" name="email" placeholder="Email agence" required>
      <input type="password" name="password" placeholder="Mot de passe agence" required>
      <button type="submit">Se connecter</button>
    </form>

    <p><a href="${pageContext.request.contextPath}/auth/client-login.jsp">Connexion client</a></p>
  </div>
</div>
</body>
</html>