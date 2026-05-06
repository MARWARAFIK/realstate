package property.servlet;

import agence.model.Agence;
import property.dao.PropertyDAO;
import property.model.Property;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/agence/add-property")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddPropertyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Agence agence = (Agence) request.getSession().getAttribute("agence");

        if (agence == null) {
            response.sendRedirect(request.getContextPath() + "/auth/agence-login.jsp");
            return;
        }

        try {
            Property p = new Property();

            p.setTitre(request.getParameter("titre"));
            p.setVille(request.getParameter("ville"));
            p.setAdresse(request.getParameter("adresse"));
            p.setType(request.getParameter("type"));
            p.setOperation(request.getParameter("operation"));
            p.setPrix(Double.parseDouble(request.getParameter("prix")));
            p.setSurface(Double.parseDouble(request.getParameter("surface")));
            p.setChambres(Integer.parseInt(request.getParameter("chambres")));
            p.setStatut(request.getParameter("statut"));
            p.setVirtualTourUrl(request.getParameter("virtualTourUrl"));
            p.setAgenceId(agence.getId());

            String mainImage = request.getParameter("image");
            if (mainImage == null || mainImage.trim().isEmpty()) {
                mainImage = "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1200&q=80";
            }

            p.setImage(mainImage);

            PropertyDAO dao = new PropertyDAO();
            int propertyId = dao.addAndReturnId(p);

            if (propertyId <= 0) {
                response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?error=1");
                return;
            }

            dao.addPropertyImage(propertyId, mainImage);

            String imageLinks = request.getParameter("imageLinks");

            if (imageLinks != null && !imageLinks.trim().isEmpty()) {
                String[] links = imageLinks.split("\\r?\\n");

                for (String link : links) {
                    if (link != null && !link.trim().isEmpty()) {
                        dao.addPropertyImage(propertyId, link.trim());
                    }
                }
            }

            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }

            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
                    String filePath = uploadPath + File.separator + fileName;

                    part.write(filePath);

                    String imageUrl = request.getContextPath() + "/uploads/" + fileName;
                    dao.addPropertyImage(propertyId, imageUrl);
                }
            }

            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/agence/properties.jsp?error=1");
        }
    }
}