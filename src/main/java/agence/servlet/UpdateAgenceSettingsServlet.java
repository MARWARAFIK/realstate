package agence.servlet;

import agence.dao.AgenceDAO;
import agence.model.Agence;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/update-settings")
public class UpdateAgenceSettingsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Agence sessionAgence = (Agence) request.getSession().getAttribute("agence");

        if (sessionAgence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        Agence agence = new Agence();

        agence.setId(sessionAgence.getId());
        agence.setNom(request.getParameter("nom"));
        agence.setEmail(request.getParameter("email"));
        agence.setTelephone(request.getParameter("telephone"));
        agence.setAdresse(request.getParameter("adresse"));
        agence.setVille(request.getParameter("ville"));
        agence.setDescription(request.getParameter("description"));
        agence.setMapLocation(request.getParameter("mapLocation"));
        agence.setImage(request.getParameter("image"));

        AgenceDAO dao = new AgenceDAO();

        if (dao.updateSettings(agence)) {
            request.getSession().setAttribute("agence", dao.getById(sessionAgence.getId()));
            response.sendRedirect(request.getContextPath() + "/agence/settings.jsp?success=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/agence/settings.jsp?error=1");
        }
    }
}