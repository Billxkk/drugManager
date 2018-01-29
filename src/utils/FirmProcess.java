package utils;

import beans.Customer;
import beans.Producer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class FirmProcess {
    public List<Producer> getFirmInfo(){

        String sql = "SELECT * FROM 厂家";
        List<Producer> prolist = new ArrayList<>();
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
                    Producer producer = new Producer();
                    producer.setProducerID(rs.getString(1));
                    producer.setProducerName(rs.getString(2));
                    producer.setProducerAddress(rs.getString(3));
                    producer.setProducerPhone(rs.getString(4));

                    prolist.add(producer);
                }
            }
            return prolist;
        }catch (Exception e){
            return null;
        }

    }
}
