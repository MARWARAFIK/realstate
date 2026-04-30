package client.servlet;

import client.dao.ClientDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/auth/reset-password.jsp?email=" + email + "&error=1");
            return;
        }

        ClientDAO dao = new ClientDAO();
        boolean ok = dao.updatePasswordByEmail(email, newPassword);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp?reset=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/auth/reset-password.jsp?email=" + email + "&error=1");
        }
    }
}