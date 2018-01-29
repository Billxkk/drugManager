package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;

import static utils.Constant.Administrator;
import static utils.Constant.drugManager;

public class DelDrugProcess {
    public static boolean  check(String str) {

        try {
            String sql = String.format("DELETE FROM 药品 WHERE 药品ID = '%s';", str);
            Connection conn = DBconn.getConnInstance(drugManager);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
            }
            int row = 0;
            if (pstm != null) {
                row = pstm.executeUpdate();
            }
            if (row > 0) {
                System.out.println("删除成功");
                return true;
            } else {
                System.out.println("删除失败1");
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("删除失败2");
            return false;
        }

    }
}
