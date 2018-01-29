package servlet;

import beans.BuyBillDetail;
import beans.SaleBillDetail;
import utils.OrderDetailProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DetailOrderServlet")
public class DetailOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        int bd = Integer.parseInt(request.getParameter("b"));
        int sd = Integer.parseInt(request.getParameter("s"));

        if (bd == 0 && sd != 0){
            //售货
//            System.out.println(bd);
//            System.out.println(sd);
            String str = String.format("%011d", sd);
            List<SaleBillDetail> list = OrderDetailProcess.getSaleInfo(str);
            if (list != null){
                session.setAttribute("sdelist",list);
                request.getRequestDispatcher("SaleOrderDetail.jsp").forward(request,response);
            }else {
                request.getRequestDispatcher("showSaleOrder.jsp").forward(request,response);
            }

        }
        if (sd == 0 && bd != 0){
            //进货
//            System.out.println(bd);
//            System.out.println(sd);
            String str = String.format("%011d", bd);
            List<BuyBillDetail> list = OrderDetailProcess.getBaleInfo(str);

            if (list != null){
                session.setAttribute("bdelist",list);
                request.getRequestDispatcher("BaleOrderDetail.jsp").forward(request,response);
            }else {
                request.getRequestDispatcher("showBaleOrder.jsp").forward(request,response);
            }

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
