package utils;

import beans.Customer;
import beans.Staff;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class CustomProcess {
    public List<Customer> getCustomInfo(){

        String sql = "SELECT * FROM 客户";
        List<Customer> custlist = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            PreparedStatement pstm = null;
            if (conn != null) {
                pstm = conn.prepareStatement(sql);
            }
            ResultSet rs = null;
            if (pstm != null) {
                rs = pstm.executeQuery();
            }

            if (rs != null) {
                while (rs.next()){
                    Customer customer = new Customer();
                    customer.setCustomerID(rs.getString(1));
                    customer.setCustomerName(rs.getString(2));
                    customer.setCustomerPhone(rs.getString(3));

                    custlist.add(customer);
                }
            }
            return custlist;
        }catch (Exception e){
            return null;
        }

    }
}
