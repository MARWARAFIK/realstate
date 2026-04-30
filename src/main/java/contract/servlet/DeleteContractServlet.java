package contract.servlet;

import agence.model.Agence;
import contract.dao.ContractDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/delete-contract")
public class DeleteContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            ContractDAO dao = new ContractDAO();
            dao.deleteContract(id, agence.getId());

            response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp?error=1");
        }
    }
}