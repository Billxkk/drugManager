package utils;

import beans.ReturnGoods;
import beans.SaleBill;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;
import static utils.Constant.returnGooder;

public class CancelProcess {
    public static List<ReturnGoods> getReturnInfo(){

        String sql = "SELECT * FROM view_admin_退厂";
        List<ReturnGoods> returnlist = new ArrayList<>();
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
                    ReturnGoods returnGoods = new ReturnGoods();
                    returnGoods.setDrugID(rs.getString(1));
                    returnGoods.setDrugName(rs.getString(2));
                    returnGoods.setProduceDate(rs.getString(3));
                    returnGoods.setVaildDate(rs.getString(4));
                    returnGoods.setQuantity(rs.getInt(5));
                    returnlist.add(returnGoods);
                }
                return returnlist;
            }
            return null;
        }catch (Exception e){
            return null;
        }

    }
}
