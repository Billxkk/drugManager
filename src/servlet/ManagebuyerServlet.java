package servlet;

import beans.Producer;
import beans.Staff;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

//@WebServlet("/managebuyer")
public class ManagebuyerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //HttpSession session=request.getSession();
        BuyerDAO buyerDAO=new BuyerDAO();
        int id=Integer.parseInt(request.getParameter("id"));
        switch (id){
            case 0:
                request.getRequestDispatcher("buyer.jsp").forward(request,response);
                break;
            case  1:
                Staff staff=new Staff();
                staff=(Staff)request.getSession().getAttribute("staff");
                staff=buyerDAO.getStaff(staff.getID());
                request.getSession().setAttribute("staff",staff);
                request.getRequestDispatcher("managebuyer.jsp").forward(request,response);
                break;
            case  2:
                List<Producer> producers1=buyerDAO.getAllProducer();
                request.setAttribute("Producers",producers1);
                request.getRequestDispatcher("purchaseFirmShow.jsp").forward(request,response);
                break;
            case  3:
                List<Producer> producers=buyerDAO.getAllProducer();
                request.setAttribute("Producers",producers);
                request.getRequestDispatcher("showFirm2.jsp").forward(request,response);
                break;
            case  4:
                request.getRequestDispatcher("addFirmInfo.jsp").forward(request,response);
                break;
            case  5:
                List<Producer> producers2=buyerDAO.getAllProducer();
                request.setAttribute("Producers",producers2);
                request.getRequestDispatcher("updateFirmInfo.jsp").forward(request,response);
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
