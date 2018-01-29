package servlet;

import beans.Producer;
import utils.BuyerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AddFirmServlet")
public class AddFirmServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Producer producer=new Producer();
        producer.setProducerID(request.getParameter("ID"));
        producer.setProducerName(request.getParameter("Name"));
        producer.setProducerAddress(request.getParameter("Addr"));
        producer.setProducerPhone(request.getParameter("Phone"));
        BuyerDAO buyerDAO=new BuyerDAO();
        boolean flag=buyerDAO.addFirm(producer);
        if(flag){
            request.getRequestDispatcher("addFirmInfo.jsp").forward(request,response);
        }else {
            System.out.println("添加失败");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
