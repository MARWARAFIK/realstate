<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<footer class="main-footer">

    <div class="footer-container">

        <!-- LOGO -->
        <div class="footer-col">
            <h2>REAL ESTATE</h2>
            <p>
                Votre partenaire de confiance pour trouver les meilleures propriétés au Maroc.
            </p>
        </div>

        <!-- NAVIGATION -->
        <div class="footer-col">
            <h3>Navigation</h3>
            <a href="<%=request.getContextPath()%>/client/home.jsp">Home</a>
            <a href="<%=request.getContextPath()%>/client/properties.jsp">Properties</a>
            <a href="<%=request.getContextPath()%>/client/profile.jsp">Profile</a>
            <a href="<%=request.getContextPath()%>/client/contact.jsp">Contact</a>
        </div>

        <!-- CONTACT -->
        <div class="footer-col">
            <h3>Contact</h3>
            <p>Email: contact@realestate.com</p>
            <p>Téléphone: +212 600000000</p>
            <p>Casablanca, Maroc</p>

            <!-- SOCIAL -->
            <div class="socials">
                <a href="#">🌐</a>
                <a href="#">📘</a>
                <a href="#">📸</a>
                <a href="#">💬</a>
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        © 2026 REAL ESTATE — Tous droits réservés
    </div>

</footer>