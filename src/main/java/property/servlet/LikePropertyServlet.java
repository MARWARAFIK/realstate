package property.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/like-property")
public class LikePropertyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Client client = (Client) request.getSession().getAttribute("client");

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
            return;
        }

        try {
            int propertyId = Integer.parseInt(request.getParameter("id"));

            ClientDAO dao = new ClientDAO();
            dao.toggleLike(client.getId(), propertyId);

            String referer = request.getHeader("referer");

            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/client/properties.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/properties.jsp");
        }
    }
}