package utils;

import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static utils.Constant.Administrator;

public class UpdateStaffProcess {
    public static boolean  check(Staff staff){
        try{

            String str =
                    String.format("UPDATE 员工 SET 姓名 = '%s',密码 = '%s',电话 = '%s',职位 = '%s',领导ID = '%s' WHERE 员工ID = '%s';", staff.getName(), staff.getPsd(), staff.getPhone(), staff.getPosition(), staff.getLeaderID(), staff.getID());
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(str);
            }
            int row = pstm.executeUpdate();
            if (row > 0) {
                System.out.println("修改成功");
                return true;
            } else {
                System.out.println("修改失败1");
                return false;
            }
        }catch (Exception e){
            System.out.println("修改失败2");
            return false;
        }
    }
}
