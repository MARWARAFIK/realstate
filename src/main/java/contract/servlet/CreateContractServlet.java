package contract.servlet;

import agence.model.Agence;
import contract.dao.ContractDAO;
import contract.model.Contract;
import property.dao.PropertyDAO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/agence/create-contract")
public class CreateContractServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        try {
            int clientId = Integer.parseInt(request.getParameter("clientId"));
            int propertyId = Integer.parseInt(request.getParameter("propertyId"));

            String typeContrat = request.getParameter("typeContrat");
            String dateDebut = request.getParameter("dateDebut");
            String dateFin = request.getParameter("dateFin");
            double montant = Double.parseDouble(request.getParameter("montant"));

            String conditions = request.getParameter("conditions");
            if (conditions == null) conditions = "";

            String finalConditions;

            if ("ACHAT".equals(typeContrat)) {
                String prixTotal = request.getParameter("prixTotal");
                String avance = request.getParameter("avance");
                String fraisNotaire = request.getParameter("fraisNotaire");
                String modePaiement = request.getParameter("modePaiement");

                if (prixTotal == null || prixTotal.trim().isEmpty()) prixTotal = "0";
                if (avance == null || avance.trim().isEmpty()) avance = "0";
                if (fraisNotaire == null || fraisNotaire.trim().isEmpty()) fraisNotaire = "0";
                if (modePaiement == null) modePaiement = "-";

                finalConditions =
                        "FORMULE ACHAT\n" +
                                "-------------------------\n" +
                                "Prix total: " + prixTotal + " DH\n" +
                                "Avance: " + avance + " DH\n" +
                                "Reste à payer: " + (Double.parseDouble(prixTotal) - Double.parseDouble(avance)) + " DH\n" +
                                "Frais notaire: " + fraisNotaire + " DH\n" +
                                "Mode paiement: " + modePaiement + "\n" +
                                "Date signature: " + dateDebut + "\n\n" +
                                "CONDITIONS GÉNÉRALES\n" +
                                "-------------------------\n" +
                                conditions;

                dateFin = null;

            } else {
                String loyer = request.getParameter("loyer");
                String caution = request.getParameter("caution");
                String charges = request.getParameter("charges");
                String duree = request.getParameter("duree");

                if (loyer == null || loyer.trim().isEmpty()) loyer = "0";
                if (caution == null || caution.trim().isEmpty()) caution = "0";
                if (charges == null || charges.trim().isEmpty()) charges = "0";
                if (duree == null || duree.trim().isEmpty()) duree = "0";

                finalConditions =
                        "FORMULE LOCATION\n" +
                                "-------------------------\n" +
                                "Loyer mensuel: " + loyer + " DH\n" +
                                "Caution: " + caution + " DH\n" +
                                "Charges: " + charges + " DH\n" +
                                "Durée: " + duree + " mois\n" +
                                "Date début: " + dateDebut + "\n" +
                                "Date fin: " + (dateFin != null && !dateFin.trim().isEmpty() ? dateFin : "-") + "\n\n" +
                                "CONDITIONS GÉNÉRALES\n" +
                                "-------------------------\n" +
                                conditions;
            }

            Contract contract = new Contract();
            contract.setAgenceId(agence.getId());
            contract.setClientId(clientId);
            contract.setPropertyId(propertyId);
            contract.setTypeContrat(typeContrat);
            contract.setDateDebut(dateDebut);
            contract.setDateFin(dateFin);
            contract.setMontant(montant);
            contract.setConditions(finalConditions);

            ContractDAO contractDAO = new ContractDAO();
            int contratId = contractDAO.createContract(contract);

            if (contratId <= 0) {
                response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp?error=1");
                return;
            }

            contractDAO.createInvoice(contratId, agence.getId(), clientId, montant);

            PropertyDAO propertyDAO = new PropertyDAO();

            if ("ACHAT".equals(typeContrat)) {
                propertyDAO.updateStatut(propertyId, "vendu", agence.getId());
            } else {
                propertyDAO.updateStatut(propertyId, "loue", agence.getId());
            }

            response.sendRedirect(request.getContextPath()
                    + "/agence/invoice.jsp?contractId=" + contratId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/agence/client-contracts.jsp?error=1");
        }
    }
}