package client.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/client/logout")
public class ClientLogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
    }
}