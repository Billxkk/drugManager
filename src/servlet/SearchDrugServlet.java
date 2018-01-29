package servlet;

import beans.BuyBill;
import beans.Drug;
import utils.DrugProcess;
import utils.SearchByTimeProcess;
import utils.SearchDrugProcess;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchDrugServlet")
public class SearchDrugServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String input=request.getParameter("search");
        String type=request.getParameter("inlineRadioOptions");
        List<Drug> list = new SearchDrugProcess().searchDrug(input,type);
        session.removeAttribute("druglist");
        session.setAttribute("druglist",list);
        request.getRequestDispatcher("drugManage.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
