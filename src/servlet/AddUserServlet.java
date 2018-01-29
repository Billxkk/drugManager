package servlet;

import beans.Staff;
import utils.AddStaffProcess;
import utils.StaffProcess;
import utils.UpdateStaffProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AddUserServlet")
public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        String sid = request.getParameter("userid");
        String sname = request.getParameter("username");
        String spwd = request.getParameter("userpwd");
        String sphone = request.getParameter("userphone");
        String spos = request.getParameter("myformcontrol");
        String sleader = request.getParameter("userLeaderId");

        System.out.println(sid);
        System.out.println(sname);
        System.out.println(spwd);
        System.out.println(sphone);
        System.out.println(spos);
        System.out.println(sleader);

        Staff staff = new Staff();
        staff.setID(sid);
        staff.setName(sname);
        staff.setPsd(spwd);
        staff.setPhone(sphone);
        staff.setPosition(spos);
        staff.setLeaderID(sleader);

        if (AddStaffProcess.check(staff)){
            session.removeAttribute("stafflist");
            List<Staff> list = new StaffProcess().getStaffInfo();
            session.setAttribute("stafflist",list);
            request.getRequestDispatcher("manageUser.jsp").forward(request,response);
        } else {
            request.getRequestDispatcher("manageUser.jsp").forward(request,response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
