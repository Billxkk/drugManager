package tests;

import utils.DBconn;

import java.sql.*;

import static utils.Constant.Administrator;

public class ConnTest {
    public static void main(String[] args) {
        Connection conn;
        ResultSet resultSet=null;
        String sql = "select dbo.get_BuyNO();";
        conn = DBconn.getConnInstance(Administrator);

        double d = 334.4353453456578;
        System.out.println(String.format("%.2f", d));


        try {
            if (conn != null) {
                conn.setAutoCommit(false);
            }
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
                ResultSet rs = pstm.executeQuery();
                if (rs.next()){
                    System.out.println(rs.getInt(1));
                    conn.commit();
                }
            }
            if (conn != null) {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException e1) {
                    e1.printStackTrace();
                }
            }
            e.printStackTrace();
        }
    }
}
