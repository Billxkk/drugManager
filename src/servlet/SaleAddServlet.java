package servlet;

import beans.Customer;
import beans.MedicineTable;
import utils.BuyerDAO;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SaleAddServlet")
public class SaleAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MedicineTable> medicineTables=new ArrayList<>();
        int lenth=Integer.parseInt(request.getParameter("i"));
        for(int i=1;i<=lenth;i++){
            MedicineTable medicineTable=new MedicineTable();
            medicineTable.setYpid((String)request.getParameter("drugID"+i));
            medicineTable.setSl((String)request.getParameter("num"+i));
            if(medicineTable.getSl().equals("")){
                continue;
            }
            medicineTables.add(medicineTable);
        }
        String customID=request.getParameter("customID");
        String salerID=request.getParameter("salerID");
        SaleDAO saleDAO=new SaleDAO();
        boolean flag=saleDAO.shouhuo(customID,salerID,medicineTables);
        List<Customer> customers=saleDAO.getAllCustomer();
        request.setAttribute("Customers",customers);
        request.getRequestDispatcher("saleCustomShow.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
