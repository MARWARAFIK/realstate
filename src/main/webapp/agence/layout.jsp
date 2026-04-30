<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="agence.model.Agence" %>

<%
    Agence agenceSession = (Agence) session.getAttribute("agence");

    if (agenceSession == null) {
        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
        return;
    }
%>

<header class="glass-header">

    <nav class="glass-navbar">

        <!-- LOGO -->
        <a class="glass-logo" href="<%=request.getContextPath()%>/agence/dashboard.jsp">
            REAL <br><span>ESTATE</span>
        </a>

        <!-- MENU -->
        <div class="glass-menu">
            <a href="<%=request.getContextPath()%>/agence/dashboard.jsp">Dashboard</a>
            <a href="<%=request.getContextPath()%>/agence/properties.jsp">Propriétés</a>
            <a href="<%=request.getContextPath()%>/agence/clients.jsp">Clients</a>
            <a href="<%=request.getContextPath()%>/agence/client-contracts.jsp">Contrats</a>
            <a href="<%=request.getContextPath()%>/agence/messages.jsp">Messages</a>
            <a href="<%=request.getContextPath()%>/agence/reservations.jsp">Réservations</a>
            <a href="<%=request.getContextPath()%>/agence/settings.jsp">Paramètres</a>

            <!-- LOGOUT -->
            <a class="logout-btn"
               href="<%=request.getContextPath()%>/agence/logout">
                Logout
            </a>
        </div>

    </nav>

</header>