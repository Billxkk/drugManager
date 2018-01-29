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

@WebServlet(name = "SearchCustomerJumpServlet")
public class SearchCustomerJumpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SaleDAO saleDAO=new SaleDAO();
        String input=request.getParameter("search");
        String type=request.getParameter("inlineRadioOptions");
        List<Customer> customers=saleDAO.serchCutr(input,type);
        request.setAttribute("Customers",customers);
        request.getRequestDispatcher("updateCustomInfo.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
