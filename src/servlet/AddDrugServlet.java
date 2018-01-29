package servlet;

import beans.Drug;
import beans.Staff;
import utils.AddDrugProcess;
import utils.AddStaffProcess;
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

@WebServlet(name = "AddDrugServlet")
public class AddDrugServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        request.setCharacterEncoding("UTF-8");
        String did = request.getParameter("drugid");
        String dname = request.getParameter("drugname");
        String dtype = request.getParameter("drugtype");
        int bprice = Integer.parseInt(request.getParameter("buyprice"));
        int sprice = Integer.parseInt(request.getParameter("saleprice"));
        String spro = request.getParameter("producerid");

        System.out.println(did);
        System.out.println(dname);
        System.out.println(dtype);
        System.out.println(bprice);
        System.out.println(sprice);
        System.out.println(spro);

        Drug drug = new Drug();
        drug.setDrugID(did);
        drug.setDrugName(dname);
        drug.setTypeID(dtype);
        drug.setBuyPrice(bprice);
        drug.setSalePrice(sprice);
        drug.setProducerID(spro);


        if (AddDrugProcess.check(drug)){
            session.removeAttribute("druglist");
            List<Drug> list = new DrugProcess().getDrugInfo();
            session.setAttribute("druglist",list);
            request.getRequestDispatcher("drugManage.jsp").forward(request,response);
        } else {
            request.getRequestDispatcher("drugManage.jsp").forward(request,response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
