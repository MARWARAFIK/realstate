<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login Client</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
</head>
<body>

<div class="auth-page">
  <div class="auth-box">
    <h1>REAL<br>ESTATE</h1>
    <h2>Connexion Client</h2>

    <% if(request.getParameter("error") != null) { %>
    <p class="error">Email ou mot de passe incorrect</p>
    <% } %>

    <% if(request.getParameter("success") != null) { %>
    <p class="success">Inscription réussie. Connectez-vous.</p>
    <% } %>

    <form action="<%=request.getContextPath()%>/client/login"
          method="post"
          autocomplete="off">

      <input type="email" name="email" placeholder="Email client" required autocomplete="off">
      <input type="password" name="password" placeholder="Mot de passe" required autocomplete="new-password">

      <button type="submit">Se connecter</button>
      <p>
        <a href="<%=request.getContextPath()%>/auth/forgot-password.jsp">
          Mot de passe oublié ?
        </a>
      </p>

    </form>


    <p>Pas encore de compte ? <a href="<%=request.getContextPath()%>/auth/client-register.jsp">Créer un compte</a></p>
    <p><a href="<%=request.getContextPath()%>/auth/agence-login.jsp">Connexion agence</a></p>
  </div>
</div>

</body>
</html>