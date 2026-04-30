package property.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/like-property-ajax")
public class LikePropertyAjaxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/plain;charset=UTF-8");

        // check session
        Client client = (Client) request.getSession().getAttribute("client");

        if (client == null) {
            response.getWriter().write("login");
            return;
        }

        try {
            int propertyId = Integer.parseInt(request.getParameter("id"));

            ClientDAO dao = new ClientDAO();

            // check before toggle
            boolean alreadyLiked = dao.isLiked(client.getId(), propertyId);

            // toggle like
            dao.toggleLike(client.getId(), propertyId);

            // return result
            if (alreadyLiked) {
                response.getWriter().write("unliked");
            } else {
                response.getWriter().write("liked");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}