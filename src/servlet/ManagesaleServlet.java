package servlet;

import beans.Customer;
import beans.Producer;
import beans.Staff;
import utils.BuyerDAO;
import utils.SaleDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManagesaleServlet")
public class ManagesaleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SaleDAO saleDAO=new SaleDAO();
        int id=Integer.parseInt(request.getParameter("id"));
        switch (id){
            case 0:
                request.getRequestDispatcher("salesman.jsp").forward(request,response);
                break;
            case 1:
                Staff staff=new Staff();
                staff=(Staff)request.getSession().getAttribute("staff");
                staff=new BuyerDAO().getStaff(staff.getID());
                request.getSession().setAttribute("staff",staff);
                request.getRequestDispatcher("manageSalesman.jsp").forward(request,response);
                break;
            case 2:
                List<Customer> customers1=saleDAO.getAllCustomer();
                request.setAttribute("Customers",customers1);
                request.getRequestDispatcher("saleCustomShow.jsp").forward(request,response);
                break;
            case 3:
                List<Customer> customers=saleDAO.getAllCustomer();
                request.setAttribute("Customers",customers);
                request.getRequestDispatcher("showCustom2.jsp").forward(request,response);
                break;
            case 4:
                request.getRequestDispatcher("addCustomInfo.jsp").forward(request,response);
                break;
            case 5:
                List<Customer> customers2=saleDAO.getAllCustomer();
                request.setAttribute("Customers",customers2);
                request.getRequestDispatcher("updateCustomInfo.jsp").forward(request,response);
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
