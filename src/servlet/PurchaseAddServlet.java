package servlet;

import beans.MedicineTable;
import beans.Producer;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "PurchaseAddServlet")
public class PurchaseAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<MedicineTable> medicineTables=new ArrayList<>();
        int lenth=Integer.parseInt(request.getParameter("i"));
        for(int i=1;i<=lenth;i++){
            MedicineTable medicineTable=new MedicineTable();
            medicineTable.setYpid((String)request.getParameter("drugID"+i));
            medicineTable.setSl((String)request.getParameter("num"+i));
            medicineTable.setScrq((String)request.getParameter("produceDate"+i).trim());
            medicineTable.setYxqz((String)request.getParameter("vaildDate"+i).trim());
            if(medicineTable.getSl().equals("")){
                continue;
            }
            medicineTables.add(medicineTable);
        }
        String produceID=request.getParameter("produceID");
        String buyerID=request.getParameter("buyerID");
        BuyerDAO buyerDAO=new BuyerDAO();
        boolean flag=buyerDAO.jinhuo(produceID,buyerID,medicineTables);
        List<Producer> producers1=buyerDAO.getAllProducer();
        request.setAttribute("Producers",producers1);
        request.getRequestDispatcher("purchaseFirmShow.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
