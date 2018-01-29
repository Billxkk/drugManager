package servlet;

import beans.Producer;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "UpdateFirmServlet")
public class UpdateFirmServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BuyerDAO buyerDAO = new BuyerDAO();
        String id=request.getParameter("uid");
        Producer producer=buyerDAO.CreateProByID(id);
        request.setAttribute("producer",producer);
        request.getRequestDispatcher("updateFirmInput.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
