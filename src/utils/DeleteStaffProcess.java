package utils;

import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;

import static utils.Constant.Administrator;

public class DeleteStaffProcess {
    public static boolean  check(String str) {

        try {

            String sql = String.format("DELETE FROM 员工 WHERE 员工ID = '%s';", str);
            Connection conn = DBconn.getConnInstance(Administrator);
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
