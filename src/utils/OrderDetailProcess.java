/*
* 进货单和售货单详情页面
 */

package utils;

import beans.BuyBillDetail;
import beans.SaleBill;
import beans.SaleBillDetail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class OrderDetailProcess {
    //进货单函数
    public static List<BuyBillDetail> getBaleInfo(String str){

        String sql = String.format("SELECT * FROM view_admin_进货单详细 WHERE 进货单ID = '%s'", str);
        List<BuyBillDetail> balelist = new ArrayList<>();
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
                    BuyBillDetail detail = new BuyBillDetail();
                    detail.setBuyBillID(rs.getString(1));
                    detail.setDrugID(rs.getString(2));
                    detail.setBuyBillName(rs.getString(3));
                    detail.setNumber(rs.getInt(4));
                    detail.setBuyPrice(rs.getInt(5));
                    detail.setDate(rs.getString(6));
                    balelist.add(detail);
                }
                return balelist;
            }
            return null;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }

    }


    //售货单函数
    public static List<SaleBillDetail> getSaleInfo(String str){

        String sql = String.format("SELECT * FROM view_admin_售货单详细 WHERE 售货单ID = '%s'", str);
        List<SaleBillDetail> salelist = new ArrayList<>();
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
                    SaleBillDetail detail = new SaleBillDetail();
                    detail.setSaleBillID(rs.getString(1));
                    detail.setDrugID(rs.getString(2));
                    detail.setSaleBillName(rs.getString(3));
                    detail.setNumber(rs.getInt(4));
                    detail.setSalePrice(rs.getInt(5));
                    detail.setDate(rs.getString(6));
                    salelist.add(detail);



                }
                return salelist;
            }
            return null;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }

    }
}
