package utils;

import beans.Drug;
import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;
import static utils.Constant.drugManager;

public class DrugProcess {
    public List<Drug> getDrugInfo(){

        String sql = "SELECT * FROM view_admin_药品信息";
        List<Drug> list = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(drugManager);
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
                    Drug drug = new Drug();
                    drug.setDrugID(rs.getString(1));
                    drug.setDrugName(rs.getString(2));
                    drug.setTypeID(rs.getString(3));
                    drug.setTypeName(rs.getString(4));
                    drug.setBuyPrice(rs.getDouble(5));
                    drug.setSalePrice(rs.getDouble(6));
                    drug.setProducerID(rs.getString(7));
                    drug.setProduceName(rs.getString(8));
                    list.add(drug);
                }
            }
            return list;
        }catch (Exception e){
            return null;
        }

    }
}
