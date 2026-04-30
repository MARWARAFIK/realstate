package client.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/login")
public class ClientLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        ClientDAO dao = new ClientDAO();
        Client client = dao.login(email, password);

        if (client != null) {
            HttpSession session = request.getSession();
            session.setAttribute("client", client);
            response.sendRedirect(request.getContextPath() + "/client/home.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp?error=1");
        }
    }
}