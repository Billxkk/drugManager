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

@WebServlet(name = "CheckExpireServlet")
public class CheckExpireServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            HttpSession session=request.getSession();
            if (CheckExpireProcess.check()){
                session.removeAttribute("returnlist");
                List<ReturnGoods> list = CancelProcess.getReturnInfo();
                session.setAttribute("returnlist",list);
                request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
            } else {
                request.getRequestDispatcher("showCancel2.jsp").forward(request,response);
            }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
