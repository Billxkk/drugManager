package utils;

import beans.Drug;

import java.sql.Connection;
import java.sql.PreparedStatement;

import static utils.Constant.drugManager;

public class AddDrugProcess {
    public static boolean  check(Drug drug){
        try{

            String str =
                    String.format("INSERT  INTO 药品 VALUES ('%s','%s','%s','%s','%s','%s');",
                            drug.getDrugID(),drug.getDrugName(), drug.getTypeID(), drug.getBuyPrice(), drug.getSalePrice(), drug.getProducerID());
            Connection conn = DBconn.getConnInstance(drugManager);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(str);
            }
            int row = 0;
            if (pstm != null) {
                row = pstm.executeUpdate();
            }
            if (row > 0) {
                System.out.println("添加成功");
                return true;
            } else {
                System.out.println("添加失败1");
                return false;
            }
        }catch (Exception e){
            e.printStackTrace();
            System.out.println("添加失败2");
            return false;
        }
    }
}
