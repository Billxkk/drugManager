package servlet;

import beans.Producer;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "UpdateFirmInfoServlet")
public class UpdateFirmInfoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Producer producer=new Producer();
        BuyerDAO buyerDAO=new BuyerDAO();
        producer.setProducerID(request.getSession().getAttribute("ID").toString());
        producer.setProducerName(request.getParameter("Name"));
        producer.setProducerAddress(request.getParameter("Addr"));
        producer.setProducerPhone(request.getParameter("Phone"));
        boolean flag=buyerDAO.updateFirm(producer);
        request.getRequestDispatcher("/updateFirmJump").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
