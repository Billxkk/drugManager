package utils;

import beans.Customer;
import beans.Stock;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;

public class StockProcess {
    public List<Stock> getStockInfo(){

        String sql = "SELECT * FROM view_admin_库存";
        List<Stock> stocklist = new ArrayList<>();
        try{
            Connection conn = DBconn.getConnInstance(Administrator);
            assert conn != null;
            PreparedStatement pstm = conn.prepareStatement(sql);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()){
                Stock stock = new Stock();
                stock.setDrugID(rs.getString(1));
                stock.setDrugName(rs.getString(2));
                stock.setProduceDate(rs.getString(3));
                stock.setVaildDate(rs.getString(4));
                stock.setQuantity(rs.getInt(5));
                stocklist.add(stock);
            }
            return stocklist;
        }catch (Exception e){
            return null;
        }

    }
}
