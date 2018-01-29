/*
* 管理退厂
 */
package servlet;

import beans.ReturnGoods;
import utils.CancelProcess;
import utils.CheckExpireProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageRefundServlet")
public class ManageRefundServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        int id=Integer.parseInt(request.getParameter("id"));
        switch (id){
            case 1:{
                request.getRequestDispatcher("refund.jsp").forward(request,response);
                break;
            }
            case 2:{
                    if(session.getAttribute("returnlist") != null){
                        request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
                    } else {
                        List<ReturnGoods> list = CancelProcess.getReturnInfo();
                        session.setAttribute("returnlist",list);
                        request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
                    }
                break;
            }
            case 3:{
                if (CheckExpireProcess.check()){
                    session.removeAttribute("returnlist");
                    List<ReturnGoods> list = CancelProcess.getReturnInfo();
                    session.setAttribute("returnlist",list);
                    request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
                } else {
                    List<ReturnGoods> list = CancelProcess.getReturnInfo();
                    session.setAttribute("returnlist",list);
                    request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
                }
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
