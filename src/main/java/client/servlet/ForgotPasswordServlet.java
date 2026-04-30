package client.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");

        ClientDAO dao = new ClientDAO();
        Client client = dao.getByEmail(email);

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/auth/forgot-password.jsp?error=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/reset-password.jsp?email=" + email);
        }
    }
}