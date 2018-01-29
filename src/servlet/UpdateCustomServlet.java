package servlet;

import beans.Customer;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UpdateCustomServlet")
public class UpdateCustomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SaleDAO saleDAO = new SaleDAO();
        String id=request.getParameter("uid");
        Customer customer=saleDAO.createCusByID(id);
        request.setAttribute("Customer",customer);
        request.getRequestDispatcher("updateCustomInput.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
