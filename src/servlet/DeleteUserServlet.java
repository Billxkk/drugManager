package servlet;

import beans.Staff;
import utils.DeleteStaffProcess;
import utils.StaffProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        String str = request.getParameter("staffID");
        if(DeleteStaffProcess.check(str)){
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
