package property.servlet;

import agence.model.Agence;
import property.dao.PropertyDAO;
import property.model.Property;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/update-property")
public class UpdatePropertyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        Property p = new Property();

        p.setId(Integer.parseInt(request.getParameter("id")));
        p.setTitre(request.getParameter("titre"));
        p.setVille(request.getParameter("ville"));
        p.setAdresse(request.getParameter("adresse"));
        p.setType(request.getParameter("type"));
        p.setOperation(request.getParameter("operation"));
        p.setPrix(Double.parseDouble(request.getParameter("prix")));
        p.setSurface(Double.parseDouble(request.getParameter("surface")));
        p.setChambres(Integer.parseInt(request.getParameter("chambres")));
        p.setImage(request.getParameter("image"));
        p.setStatut(request.getParameter("statut"));
        p.setVirtualTourUrl(request.getParameter("virtualTourUrl"));
        p.setAgenceId(agence.getId());

        PropertyDAO dao = new PropertyDAO();

        if (dao.update(p)) {
            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?success=update");
        } else {
            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?error=update");
        }
    }
}