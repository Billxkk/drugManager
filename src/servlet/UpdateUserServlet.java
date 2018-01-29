/*
* 修改前获取原来的值
 */

package servlet;

import beans.Staff;
import utils.StaffById;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateUserServlet")
public class UpdateUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        String str = request.getParameter("staffID");
        Staff staff = StaffById.getStaffById(str);

        if (staff != null){
            session.setAttribute("updatestaff",staff);
            request.getRequestDispatcher("updateUser.jsp").forward(request,response);
        }else {
            request.getRequestDispatcher("manageUser.jsp").forward(request,response);
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
