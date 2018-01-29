package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

import static utils.Constant.Administrator;
import static utils.Constant.drugManager;

public class CheckExpireProcess {
    public static boolean check(){

            String str = "exec dbo.check_invaildDrug;";
            Connection conn = DBconn.getConnInstance(Administrator);
            Statement stm = null;
        try{
            if (conn != null) {
                conn.setAutoCommit(false);
            }
            if (conn != null) {
                stm = conn.createStatement();
            }
            if (stm != null) {
                stm.execute(str);
            }

            if (conn != null) {
                conn.commit();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
            }
            System.out.println("事务执行成功");
            return true;

        }catch (Exception e){
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
            e.printStackTrace();
            System.out.println("事务执行失败,执行回滚");
            return false;
        }
    }
}
