<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Register Client</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
</head>
<body>

<div class="auth-page">
  <div class="auth-box">
    <h1>REAL<br>ESTATE</h1>
    <h2>Inscription Client</h2>

    <% if(request.getParameter("error") != null) { %>
    <p class="error">Erreur inscription. Email déjà utilisé.</p>
    <% } %>

    <form action="<%=request.getContextPath()%>/client/register"
          method="post"
          autocomplete="off">

      <input type="text" name="nom" placeholder="Nom complet" required autocomplete="off">
      <input type="email" name="email" placeholder="Email" required autocomplete="off">
      <input type="text" name="telephone" placeholder="Téléphone" required autocomplete="off">
      <input type="password" name="password" placeholder="Mot de passe" required autocomplete="new-password">

      <button type="submit">Créer compte</button>
    </form>

    <p>Déjà inscrit ? <a href="<%=request.getContextPath()%>/auth/client-login.jsp">Se connecter</a></p>
    <p><a href="<%=request.getContextPath()%>/auth/agence-login.jsp">Connexion agence</a></p>
  </div>
</div>

</body>
</html>