package servlet;

import beans.Drug;
import beans.MedicineTable;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "FirmMedicineSelectServlet")
public class FirmMedicineSelectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BuyerDAO buyerDAO=new BuyerDAO();
        List<Drug> drugs=new ArrayList<>();
        drugs=buyerDAO.getMedicineByID(request.getParameter("uid"));
        request.setAttribute("drugs",drugs);
        request.getRequestDispatcher("purchase.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
