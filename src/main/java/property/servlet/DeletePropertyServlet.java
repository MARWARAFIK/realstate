package property.servlet;

import agence.model.Agence;
import property.dao.PropertyDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/delete-property")
public class DeletePropertyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        PropertyDAO dao = new PropertyDAO();

        if (dao.delete(id, agence.getId())) {
            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?success=delete");
        } else {
            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?error=delete");
        }
    }
}