package utils;

import beans.BuyBill;
import beans.SaleBill;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class SaleOrderProcess {
    public List<SaleBill> getSaleInfo(){

        String sql = "SELECT * FROM view_admin_售货单";
        List<SaleBill> salelist = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
            }
            ResultSet rs = null;
            if (pstm != null) {
                rs = pstm.executeQuery();
            }

            if (rs != null) {
                while (rs.next()){
                    SaleBill saleBill = new SaleBill();
                    saleBill.setSaleBillID(rs.getString(1));
                    saleBill.setDate(rs.getString(2));
                    saleBill.setTime(rs.getString(3));
                    saleBill.setCustomerID(rs.getString(4));
                    saleBill.setCustomerName(rs.getString(5));
                    saleBill.setSalerID(rs.getString(6));
                    saleBill.setSalerName(rs.getString(7));
                    salelist.add(saleBill);
                }
            }
            return salelist;
        }catch (Exception e){
            return null;
        }

    }
}
