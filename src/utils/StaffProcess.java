package utils;

import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class StaffProcess {
    public List<Staff> getStaffInfo(){

        String sql = "SELECT * FROM 员工";
        List<Staff> list = new ArrayList<Staff>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()){
                Staff staff = new Staff();
                staff.setID(rs.getString(1));
                staff.setName(rs.getString(2));
                staff.setPsd(rs.getString(3));
                staff.setPhone(rs.getString(4));
                staff.setPosition(rs.getString(5));
                staff.setLeaderID(rs.getString(6));
                list.add(staff);
            }
            return list;
        }catch (Exception e){
            return null;
        }

    }
}
