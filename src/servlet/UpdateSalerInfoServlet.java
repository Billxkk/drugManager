package servlet;

import beans.Staff;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateSalerInfoServlet")
public class UpdateSalerInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BuyerDAO buyerDAO=new BuyerDAO();
        request.setCharacterEncoding("UTF-8");
        HttpSession session=request.getSession();
        Staff buyer=(Staff) session.getAttribute("staff");
        buyer.setName(request.getParameter("Name"));
        buyer.setPsd(request.getParameter("Psd"));
        buyer.setPhone(request.getParameter("Phone"));
        boolean flag=buyerDAO.update(buyer);
        if(flag){
            request.getRequestDispatcher("manageSalesman.jsp").forward(request,response);
        }else{
            request.getRequestDispatcher("index.jsp").forward(request,response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
