package utils;

import beans.Drug;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SearchDrugProcess {
    public List<Drug> searchDrug(String search, String type){
        List<Drug> drugs = new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet rs=null;
        try {
            connection=utils.DBconn.getConnInstance(Constant.drugManager);
            String sql="";
            switch (type) {
                case "option1":
                    sql = "select * from view_admin_药品信息 where 药名 like '%" + search + "%'";
                    break;
                case "option2":
                    sql = "SELECT * FROM view_admin_药品信息 WHERE 药品ID = '" + search + "'";
                    break;
                default:
                    System.out.println("类型不对");
                    break;
            }
            if (connection != null) {
                preparedStatement=connection.prepareStatement(sql);
            }
            if (preparedStatement != null) {
                rs =preparedStatement.executeQuery();
            }
            while (rs.next()){
                Drug drug = new Drug();
                drug.setDrugID(rs.getString(1));
                drug.setDrugName(rs.getString(2));
                drug.setTypeID(rs.getString(3));
                drug.setTypeName(rs.getString(4));
                drug.setBuyPrice(rs.getInt(5));
                drug.setSalePrice(rs.getInt(6));
                drug.setProducerID(rs.getString(7));
                drug.setProduceName(rs.getString(8));
                drugs.add(drug);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            utils.DBclose.close(rs,preparedStatement);
        }
        return drugs;
    }
}
