package servlet;

import beans.Producer;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchFirmJumpServlet")
public class SearchFirmJumpServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BuyerDAO buyerDAO=new BuyerDAO();
        String input=request.getParameter("search");
        String type=request.getParameter("inlineRadioOptions");
        List<Producer> producers=buyerDAO.serchPder(input,type);
        request.setAttribute("Producers",producers);
        request.getRequestDispatcher("updateFirmInfo.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
