package servlet;

import beans.Customer;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DeleteByCusIdServlet")
public class DeleteByCusIdServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SaleDAO saleDAO =new SaleDAO();
        String pid=request.getParameter("pid");
        boolean flag=saleDAO.deleteCusByID(pid);
        List<Customer> customers=saleDAO.getAllCustomer();
        request.setAttribute("Customers",customers);
        request.getRequestDispatcher("updateCustomInfo.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
