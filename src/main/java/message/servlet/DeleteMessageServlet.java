package message.servlet;

import agence.model.Agence;
import message.dao.MessageDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/delete-message")
public class DeleteMessageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 🔐 check agence login
        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String back = request.getParameter("back");

            MessageDAO dao = new MessageDAO();

            // ✅ الحل: deleteMessage avec agenceId
            dao.deleteMessage(id, agence.getId());

            // 🔁 redirect حسب الصفحة
            if ("reservations".equals(back)) {
                response.sendRedirect(request.getContextPath() + "/agence/reservations.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/agence/messages.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/agence/messages.jsp");
        }
    }
}