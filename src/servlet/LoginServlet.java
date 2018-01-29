package servlet;

import beans.Staff;
import utils.StaffOper;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created by bill xu on 2018/1/5.
 *
 */
@WebServlet(name = "LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String sid = request.getParameter("userid");
        String spwd = request.getParameter("userpwd");
        String pos = request.getParameter("userpos");
//        System.out.println(pos);
        Staff staff = new Staff();
        staff.setID(sid);
        staff.setPsd(spwd);
        staff.setPosition(pos);
        HttpSession session = request.getSession();
        Staff staffPos = StaffOper.check(staff);  //根据返回值进行跳转

        if (staffPos != null){
            session.setAttribute("sid",sid);
            session.setAttribute("staff",staffPos);
            String position = staffPos.getPosition();
            switch (position) {
                case "管理员":{
                    RequestDispatcher rd = request.getRequestDispatcher("master.jsp");  //转到管理页面
                    rd.forward(request,response);   //转发请求
                    break;
                }
                case "药品整理员": {
                    RequestDispatcher rd = request.getRequestDispatcher("trim.jsp");  //转到整理员页面
                    rd.forward(request,response);   //转发请求
                    break;
                }
                case "售货员":{
                    RequestDispatcher rd = request.getRequestDispatcher("salesman.jsp");  //转到售货员页面
                    rd.forward(request,response);   //转发请求
                    break;
                }
                case "进货员":{
                    RequestDispatcher rd = request.getRequestDispatcher("buyer.jsp");  //转到进货员页面
                    rd.forward(request,response);   //转发请求
                    break;
                }
                case "退货员":{
                    RequestDispatcher rd = request.getRequestDispatcher("refund.jsp");  //转到退厂员页面
                    rd.forward(request,response);   //转发请求
                    break;
                }
                default:{
            //        response.sendRedirect("index.jsp");
                    session.setAttribute("lose",sid);
                    RequestDispatcher rd = request.getRequestDispatcher("index.jsp");  //转到退厂员页面
                    rd.forward(request,response);
                    break;
                }
            }


        } else {
        //    response.sendRedirect("index.jsp");
            session.setAttribute("lose",sid);
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");  //转到退厂员页面
            rd.forward(request,response);
        }

    }


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

}
