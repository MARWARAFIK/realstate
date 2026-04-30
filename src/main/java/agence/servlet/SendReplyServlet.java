package agence.servlet;

import message.dao.MessageDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/send-reply")
public class SendReplyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int messageId = Integer.parseInt(request.getParameter("messageId"));
        String reply = request.getParameter("reply");

        MessageDAO dao = new MessageDAO();
        dao.saveReply(messageId, reply);

        response.sendRedirect(request.getContextPath() + "/agence/messages.jsp?replied=1");
    }
}