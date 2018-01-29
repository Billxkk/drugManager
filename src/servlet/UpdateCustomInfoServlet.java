package servlet;

import beans.Customer;
import beans.Producer;
import utils.BuyerDAO;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UpdateCustomInfoServlet")
public class UpdateCustomInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Customer customer=new Customer();
        SaleDAO saleDAO=new SaleDAO();
        customer.setCustomerID(request.getSession().getAttribute("ID").toString());
        customer.setCustomerName(request.getParameter("Name"));
        customer.setCustomerPhone(request.getParameter("Phone"));
        boolean flag=saleDAO.updateCustom(customer);
        List<Customer> customers=saleDAO.getAllCustomer();
        request.setAttribute("Customers",customers);
        request.getRequestDispatcher("updateCustomInfo.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
