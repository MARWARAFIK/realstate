package property.servlet;

import client.model.Client;
import utils.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/client/reserve")
public class ReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Client client = (Client) request.getSession().getAttribute("client");

        if (client == null) {
            response.sendRedirect(request.getContextPath() + "/auth/client-login.jsp");
            return;
        }

        int propertyId = Integer.parseInt(request.getParameter("propertyId"));
        String message = request.getParameter("message");

        String sql = "INSERT INTO reservations(client_id, property_id, message, statut) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, client.getId());
            ps.setInt(2, propertyId);
            ps.setString(3, message);
            ps.setString(4, "En attente");

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath()
                    + "/client/property-details.jsp?id=" + propertyId + "&success=1");

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(request.getContextPath()
                    + "/client/property-details.jsp?id=" + propertyId + "&error=1");
        }
    }
}