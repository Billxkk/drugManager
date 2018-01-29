/*
* 自动生成员工ID
 */
package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static utils.Constant.Administrator;

public class createStaffId {
    public static String getStaffId() {

        Connection conn;
        ResultSet resultSet = null;
        String sql = "select dbo.get_员工NO();";

        try {
            conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
                ResultSet rs = pstm.executeQuery();
                if (rs.next()) {
                    int iid = rs.getInt(1);
                    String str = String.format("%06d", iid);
                    System.out.println(str);
                    return str;
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
