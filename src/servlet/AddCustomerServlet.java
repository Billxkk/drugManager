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

@WebServlet(name = "AddCustomerServlet")
public class AddCustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Customer customer=new Customer();
        customer.setCustomerID(request.getParameter("ID"));
        customer.setCustomerName(request.getParameter("Name"));
        customer.setCustomerPhone(request.getParameter("Phone"));
        SaleDAO saleDAO=new SaleDAO();
        boolean flag=saleDAO.addCustomer(customer);
        if(flag){
            request.getRequestDispatcher("addCustomInfo.jsp").forward(request,response);
        }else {
            System.out.println("添加失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
