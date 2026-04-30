package client.servlet;

import client.dao.ClientDAO;
import client.model.Client;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/change-password")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Client client = (Client) request.getSession().getAttribute("client");

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/client/profile.jsp?passError=confirm");
            return;
        }

        ClientDAO dao = new ClientDAO();

        if (!dao.checkPassword(client.getId(), oldPassword)) {
            response.sendRedirect(request.getContextPath() + "/client/profile.jsp?passError=old");
            return;
        }

        boolean ok = dao.updatePassword(client.getId(), newPassword);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/client/profile.jsp?passSuccess=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/client/profile.jsp?passError=1");
        }
    }
}