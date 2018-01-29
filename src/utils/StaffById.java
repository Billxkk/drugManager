package utils;

import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import static utils.Constant.Administrator;

/*
* 根据ID获取员工信息
 */
public class StaffById {
    public static Staff getStaffById(String str) {
        Staff returnStaff = new Staff();
        Connection conn = DBconn.getConnInstance(Administrator);
          String sql = "SELECT * FROM 员工 WHERE 员工ID = ?";

        try {

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1,str);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                    returnStaff.setID(rs.getString(1));
                    returnStaff.setName(rs.getString(2));
                    returnStaff.setPsd(rs.getString(3));
                    returnStaff.setPhone(rs.getString(4));
                    returnStaff.setPosition(rs.getString(5));
                    returnStaff.setLeaderID(rs.getString(6));
                  return returnStaff;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
