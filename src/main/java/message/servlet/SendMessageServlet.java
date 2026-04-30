package message.servlet;

import client.model.Client;
import utils.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;

@WebServlet("/client/send-message")
public class SendMessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Client client = (Client) request.getSession().getAttribute("client");

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
            return;
        }

        try {
            int agenceId = Integer.parseInt(request.getParameter("agenceId"));

            String propertyParam = request.getParameter("propertyId");
            int propertyId = 0;

            if (propertyParam != null && !propertyParam.trim().isEmpty()) {
                propertyId = Integer.parseInt(propertyParam);
            }

            String nom = request.getParameter("nom");
            String email = request.getParameter("email");
            String telephone = request.getParameter("telephone");
            String typeMessage = request.getParameter("typeMessage");
            String message = request.getParameter("message");

            String sql =
                    "INSERT INTO messages " +
                            "(client_id, property_id, agence_id, nom, email, telephone, type_message, message, statut) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, client.getId());

                if (propertyId > 0) {
                    ps.setInt(2, propertyId);
                } else {
                    ps.setNull(2, Types.INTEGER);
                }

                ps.setInt(3, agenceId);
                ps.setString(4, nom);
                ps.setString(5, email);
                ps.setString(6, telephone);
                ps.setString(7, typeMessage);
                ps.setString(8, message);
                ps.setString(9, "Non lu");

                ps.executeUpdate();
            }

            String back = request.getParameter("back");

            if ("contact".equals(back)) {
                response.sendRedirect(request.getContextPath() + "/client/contact.jsp?success=1");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/client/property-details.jsp?id=" + propertyId + "&success=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/client/contact.jsp?error=1");
        }
    }
}