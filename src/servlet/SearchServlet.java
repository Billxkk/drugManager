/*
* 按时间进行搜索
 */
package servlet;

import beans.BuyBill;
import beans.SaleBill;
import utils.BaleOrderProcess;
import utils.SearchByTimeProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.crypto.Data;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();

        int id = Integer.parseInt(request.getParameter("id"));
        //1.进货
        //2.售货

        String start = request.getParameter("startdate");
//        System.out.println(Date.valueOf(start));
        String stop = request.getParameter("stopdate");
 //       System.out.println(Date.valueOf(stop));

        if (id == 1){
            List<BuyBill> list = SearchByTimeProcess.getBaleInfo(start,stop);

            if (list != null){
                session.removeAttribute("balelist");
                session.setAttribute("balelist",list);
                request.getRequestDispatcher("showBaleOrder.jsp").forward(request,response);
            } else {
                request.getRequestDispatcher("showBaleOrder.jsp").forward(request,response);
            }

        }
        else if (id == 2){
            List<SaleBill> list = SearchByTimeProcess.getSaleInfo(start,stop);

            if (list != null){
                session.removeAttribute("salelist");
                session.setAttribute("salelist",list);
                request.getRequestDispatcher("showSaleOrder.jsp").forward(request,response);
            } else {
                request.getRequestDispatcher("showSaleOrder.jsp").forward(request,response);
            }
        }





    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
