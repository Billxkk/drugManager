package utils;

import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static utils.Constant.Administrator;

public class AddStaffProcess {
    public static boolean  check(Staff staff){
        try{

            String str =
                    String.format("INSERT  INTO 员工 VALUES ('%s','%s','%s','%s','%s','%s');",
                            staff.getID(),staff.getName(), staff.getPsd(), staff.getPhone(), staff.getPosition(), staff.getLeaderID());
            Connection conn = DBconn.getConnInstance(Administrator);
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
            System.out.println("添加失败2");
            return false;
        }
    }
}
