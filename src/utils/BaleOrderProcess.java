/*
* 进货单
 */

package utils;

import beans.BuyBill;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class BaleOrderProcess {
    public List<BuyBill> getBaleInfo(){

        String sql = "SELECT * FROM view_admin_进货单";
        List<BuyBill> balelist = new ArrayList<>();
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
}
