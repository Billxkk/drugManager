package servlet;

import beans.Drug;
import beans.Staff;
import utils.DelDrugProcess;
import utils.DeleteStaffProcess;
import utils.DrugProcess;
import utils.StaffProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DelDrugServlet")
public class DelDrugServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        String str = request.getParameter("drugID");
        if(DelDrugProcess.check(str)){
            session.removeAttribute("druglist");
            List<Drug> list = new DrugProcess().getDrugInfo();
            session.setAttribute("druglist",list);
            request.getRequestDispatcher("drugManage.jsp").forward(request,response);
        } else {
            request.getRequestDispatcher("drugManage.jsp").forward(request,response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
