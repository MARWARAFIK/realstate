package client.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/register")
public class ClientRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String nom = request.getParameter("nom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String password = request.getParameter("password");

        ClientDAO dao = new ClientDAO();

        if (dao.emailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/auth/client-register.jsp?error=exists");
            return;
        }

        Client client = new Client();
        client.setNom(nom);
        client.setEmail(email);
        client.setTelephone(telephone);
        client.setPassword(password);

        boolean ok = dao.register(client);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp?registered=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/client-register.jsp?error=1");
        }
    }
}