package servlet;

import beans.Drug;
import beans.Staff;
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

@WebServlet(name = "ManageTrimServlet")
public class ManageTrimServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession();
        int id=Integer.parseInt(request.getParameter("id"));
        switch (id){
            case 1:{

                request.getRequestDispatcher("trim.jsp").forward(request,response);
                break;
            }
            case 2:{
                List<Drug> list = new DrugProcess().getDrugInfo();
                session.setAttribute("druglist",list);
                request.getRequestDispatcher("drugManage.jsp").forward(request,response);
                break;
            }
            case 3:{
                request.getRequestDispatcher("addDrug.jsp").forward(request,response);
                break;
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
