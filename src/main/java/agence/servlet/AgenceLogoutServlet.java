package agence.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/logout")
public class AgenceLogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.getSession().invalidate();

        response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
    }
}