package utils;

import beans.BuyBill;
import beans.SaleBill;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class SearchByTimeProcess {
    public static List<BuyBill> getBaleInfo(String str1, String str2){

        String sql = "SELECT * FROM view_admin_进货单 WHERE 日期 BETWEEN ? AND ?";
        List<BuyBill> balelist = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
                pstm.setDate(1, Date.valueOf(str1));
                pstm.setDate(2, Date.valueOf(str2));
            }
            ResultSet rs = null;
            if (pstm != null) {
                rs = pstm.executeQuery();
            }

            if (rs != null) {
                while (rs.next()){
                    BuyBill buyBill = new BuyBill();
                    buyBill.setBuyBillID(rs.getString(1));
                    buyBill.setDate(rs.getString(2));
                    buyBill.setTime(rs.getString(3));
                    buyBill.setProducerID(rs.getString(4));
                    buyBill.setProducerName(rs.getString(5));
                    buyBill.setBuyerID(rs.getString(6));
                    buyBill.setBuyerName(rs.getString(7));
                    balelist.add(buyBill);
                }
            }
            return balelist;
        }catch (Exception e){
            return null;
        }

    }


    public static List<SaleBill> getSaleInfo(String str1, String str2){

        String sql = "SELECT * FROM view_admin_售货单 WHERE 日期 BETWEEN ? AND ?";
        List<SaleBill> salelist = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
                pstm.setDate(1, Date.valueOf(str1));
                pstm.setDate(2, Date.valueOf(str2));
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
