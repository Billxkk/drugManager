package servlet;

import beans.MedicineTable;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomSelectServlet")
public class CustomSelectServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id=request.getParameter("uid");
        SaleDAO saleDAO=new SaleDAO();
        List<MedicineTable>medicineTables=new ArrayList<>();
        medicineTables=saleDAO.getAllMedicine();
        request.setAttribute("Cid",id);
        request.setAttribute("AllMedicine",medicineTables);
        request.getRequestDispatcher("sale.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
