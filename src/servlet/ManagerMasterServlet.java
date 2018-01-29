package servlet;

import beans.*;
import utils.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManagerMasterServlet")
public class ManagerMasterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        int id=Integer.parseInt(request.getParameter("id"));
        switch (id){
            case 1:{
                request.getRequestDispatcher("master.jsp").forward(request,response);
                break;
            }
            case 2:{
                List<Staff> list = new StaffProcess().getStaffInfo();
                session.setAttribute("stafflist",list);
                request.getRequestDispatcher("manageUser.jsp").forward(request,response);
                break;
            }
            case 3:{
                List<Stock> list = new StockProcess().getStockInfo();
                session.setAttribute("stocklist",list);
                request.getRequestDispatcher("showStock.jsp").forward(request,response);
                break;
            }
            case 4:{
                List<BuyBill> list = new BaleOrderProcess().getBaleInfo();
                session.setAttribute("balelist",list);
                request.getRequestDispatcher("showBaleOrder.jsp").forward(request,response);
                break;
            }
            case 5:{
                List<SaleBill> list = new SaleOrderProcess().getSaleInfo();
                session.setAttribute("salelist",list);
                request.getRequestDispatcher("showSaleOrder.jsp").forward(request,response);
                break;
            }
            case 6:{
                session.removeAttribute("returnlist");
                List<ReturnGoods> list = CancelProcess.getReturnInfo();
                session.setAttribute("returnlist",list);
                request.getRequestDispatcher("showCancel.jsp").forward(request,response);
                break;
            }
            case 7:{
                List<Customer> list = new CustomProcess().getCustomInfo();
                session.setAttribute("customlist",list);
                request.getRequestDispatcher("showCustom.jsp").forward(request,response);
                break;
            }
            case 8:{
                List<Producer> list = new FirmProcess().getFirmInfo();
                session.setAttribute("firmlist",list);
                request.getRequestDispatcher("showFirm.jsp").forward(request,response);
                break;
            }
            case 9:{
            //    request.getRequestDispatcher("checkExpire.jsp").forward(request,response);
                request.getRequestDispatcher("index.jsp").forward(request,response);
                break;
            }
            case 10:{
                request.getRequestDispatcher("addUser.jsp").forward(request,response);
                break;
            }
            case 11:{
                request.getSession().invalidate();
                response.sendRedirect("index.jsp");
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
