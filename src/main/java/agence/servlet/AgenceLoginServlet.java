package agence.servlet;

import agence.dao.AgenceDAO;
import agence.model.Agence;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AgenceLogin")
public class AgenceLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Servlet recoit: " + email); // Debug console

        AgenceDAO dao = new AgenceDAO();
        Agence agence = dao.login(email, password);

        if (agence != null) {
            HttpSession session = request.getSession();
            session.setAttribute("agence", agence);
            response.sendRedirect(request.getContextPath() + "/agence/dashboard.jsp");
        } else {
            // Echec -> Retour login
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp?error=1");
        }
    }
}