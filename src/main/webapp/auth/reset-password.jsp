<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Reset Password</title>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/css/auth.css">
</head>
<body>

<div class="auth-page">
  <div class="auth-box">
    <h1>REAL ESTATE</h1>
    <h2>Changer mot de passe</h2>

    <% String email = request.getParameter("email"); %>

    <% if(request.getParameter("error") != null) { %>
    <p class="error">Les mots de passe ne correspondent pas</p>
    <% } %>

    <form action="<%=request.getContextPath()%>/client/reset-password" method="post">
      <input type="hidden" name="email" value="<%= email %>">

      <input type="password" name="newPassword" placeholder="Nouveau mot de passe" required>
      <input type="password" name="confirmPassword" placeholder="Confirmer mot de passe" required>

      <button type="submit">Changer</button>
    </form>
  </div>
</div>

</body>
</html>