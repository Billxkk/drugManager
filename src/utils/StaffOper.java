package utils;

import beans.Staff;
import utils.DBconn;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import static utils.Constant.*;

/*
* 用于对员工进行登录检查
 */
public class StaffOper {
    public static Staff check(Staff staff){
        Staff returnStaff = new Staff();
        String sql = "SELECT * FROM 员工 WHERE 员工ID = ? AND 密码 = ? AND 职位 = ?";
        String sid = staff.getID();
        String pass = staff.getPsd();
        String pos = staff.getPosition();
        Connection conn = DBconn.getConnInstance();
        switch (pos) {
            case "管理员":
                conn = DBconn.getConnInstance(Administrator);
                break;
            case "药品整理员":
                conn = DBconn.getConnInstance(drugManager);
                break;
            case "售货员":
                conn = DBconn.getConnInstance(saler);
                break;
            case "进货员":
                conn = DBconn.getConnInstance(buyer);
                break;
            case "退货员":
                conn = DBconn.getConnInstance(returnGooder);
                break;
        }

        try{
            assert conn != null;
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1,sid);
            pstmt.setString(2,pass);
            pstmt.setString(3,pos);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()){

                returnStaff.setID(sid);
                returnStaff.setPsd(pass);
                String name = rs.getString("姓名");
                returnStaff.setName(name);
                String position = rs.getString("职位");
                returnStaff.setPosition(position);

                returnStaff.setPhone(rs.getString(4));
                returnStaff.setLeaderID(rs.getString(6));

                return returnStaff;
            }else {
                return null;
            }
        }catch (Exception e){
            return null;
        }

    }
}
