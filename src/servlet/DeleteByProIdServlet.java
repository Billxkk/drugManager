package servlet;

import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DeleteByProIdServlet")
public class DeleteByProIdServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BuyerDAO buyerDAO =new BuyerDAO();
        String pid=request.getParameter("pid");
        boolean flag=buyerDAO.deleteProByID(pid);
        request.getRequestDispatcher("/delJump").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
