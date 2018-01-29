package utils;

import beans.Drug;
import beans.MedicineTable;
import beans.Producer;
import beans.Staff;

import javax.resource.spi.AdministeredObject;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuyerDAO {
    /**
     * 获取厂家信息
     * @return
     */
    public List<Producer> getAllProducer(){
        List<Producer> producers=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=utils.DBconn.getConnInstance();
            String sql="select * from 厂家";
            preparedStatement=connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                Producer producer=new Producer();
                producer.setProducerID(resultSet.getString(1));
                producer.setProducerName(resultSet.getString(2));
                producer.setProducerAddress(resultSet.getString(3));
                producer.setProducerPhone(resultSet.getString(4));
                producers.add(producer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            utils.DBclose.close(resultSet,preparedStatement);
        }
        return  producers;
    }

    /**
     * 根据名字或厂商ID查询获取
     * @param search
     * @param type
     * @return
     */
    public List<Producer> serchPder(String search,String type){
        List<Producer> producers=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=utils.DBconn.getConnInstance(Constant.buyer);
            String sql="";
            if(type.equals("option1")){
                sql="select * from 厂家 where 厂名 like '%"+search+"%'";
            }else if(type.equals("option2")){
                sql="SELECT * FROM 厂家 WHERE 厂商ID='"+search+"'";
            }else {
                System.out.println("类型不对");
            }
            preparedStatement=connection.prepareStatement(sql);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                Producer producer=new Producer();
                producer.setProducerID(resultSet.getString(1));
                producer.setProducerName(resultSet.getString(2));
                producer.setProducerAddress(resultSet.getString(3));
                producer.setProducerPhone(resultSet.getString(4));
                producers.add(producer);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            utils.DBclose.close(resultSet,preparedStatement);
        }
        return producers;
    }
    /**
     * 更新采购员信息
     * @param staff
     * @return
     */
    public synchronized boolean update(Staff staff){
        boolean flag=false;
        Connection connection=null;
        Statement statement=null;
        try{
            connection=DBconn.getConnInstance();
            statement=connection.createStatement();
            String sql="update 员工 set 姓名='"+staff.getName()+"',密码='"
                    +staff.getPsd()+"',电话='"+staff.getPhone()+"'where 员工ID='"+staff.getID()+"'";
            int row=statement.executeUpdate(sql);
            if(row>0){
                flag=true;
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(statement);
        }
        return flag;
    }

    /**
     * 根据员工ID获取员工信息
     * @param id
     * @return
     */
    public  Staff getStaff(String id){
        Staff staff=new Staff();
        staff.setID(id);
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=DBconn.getConnInstance(Constant.Administrator);
            String sql="SELECT * FROM 员工 WHERE 员工ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                staff.setName(resultSet.getString(2));
                staff.setPsd(resultSet.getString(3));
                staff.setPhone(resultSet.getString(4));
                staff.setPosition(resultSet.getString(5));
                staff.setLeaderID(resultSet.getString(6));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staff;
    }
    /**
     * 根据厂商id删除
     * @param id
     * @return
     */
    public boolean deleteProByID(String id){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        try {
            connection=DBconn.getConnInstance(Constant.buyer);
            String sql="DELETE FROM 厂家 WHERE 厂商ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * 根据厂商ID获取信息
     * @param id
     * @return
     */
    public Producer CreateProByID(String id){
        Producer producer=new Producer();
        producer.setProducerID(id);
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try {
            connection=DBconn.getConnInstance(Constant.buyer);
            String sql="SELECT * FROM 厂家 WHERE 厂商ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                producer.setProducerName(resultSet.getString(2));
                producer.setProducerAddress(resultSet.getString(3));
                producer.setProducerPhone(resultSet.getString(4));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return producer;
    }

    /**
     * 添加厂商
     * @param producer
     * @return
     */
    public  boolean addFirm(Producer producer){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        try {
            connection=DBconn.getConnInstance(Constant.buyer);
            String sql="INSERT  INTO 厂家 VALUES (?,?,?,?)";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,producer.getProducerID());
            preparedStatement.setString(2,producer.getProducerName());
            preparedStatement.setString(3,producer.getProducerAddress());
            preparedStatement.setString(4,producer.getProducerPhone());
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(preparedStatement);
        }
        return flag;
    }

    /**
     * 修改厂家信息
     * @param producer
     * @return
     */
    public boolean updateFirm(Producer producer){
        boolean flag=false;
        Connection connection=null;
        Statement statement=null;
        try{
            connection=DBconn.getConnInstance(Constant.buyer);
            statement=connection.createStatement();
            String sql="update 厂家 set 厂名='"+producer.getProducerName()+"',地址='"
                    +producer.getProducerAddress()+"',电话='"+producer.getProducerPhone()+
                    "'where 厂商ID='"+producer.getProducerID()+"'";
            int row=statement.executeUpdate(sql);
            if(row>0){
                flag=true;
            }
        }catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(statement);
        }
        return flag;
    }

    /**
     * 进货
     * @param producerID
     * @param buyerID
     * @param medicineTables
     * @return
     */
    public boolean jinhuo(String producerID, String buyerID, List<MedicineTable> medicineTables){
        boolean flag=false;
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try{
            connection=DBconn.getConnInstance(Constant.buyer);
            String ypid="";
            String sl="";
            String scrq="";
            String yxqz="";
            int bID=0;
            for (MedicineTable med :
                    medicineTables) {
                ypid+=med.getYpid()+",";
                sl+=med.getSl()+",";
                scrq+=med.getScrq()+",";
                yxqz+=med.getYxqz()+",";
            }
            ypid=ypid.substring(0,ypid.length()-1);
            sl=sl.substring(0,sl.length()-1);
            scrq=scrq.substring(0,scrq.length()-1);
            yxqz=yxqz.substring(0,yxqz.length()-1);
            String sql1="select dbo.get_BuyNO()";
            preparedStatement=connection.prepareStatement(sql1);
            resultSet=preparedStatement.executeQuery();
            if(resultSet.next()){
                bID=resultSet.getInt(1);
            }
            String buyID=String.format("%011d", bID);
            String sql2="{call dbo.insert_buy_data (?,?,?,?,?,?,?)}";
            preparedStatement=connection.prepareStatement(sql2);
            preparedStatement.setString(1,buyID);
            preparedStatement.setString(2,producerID);
            preparedStatement.setString(3,buyerID);
            preparedStatement.setString(4,ypid);
            preparedStatement.setString(5,sl);
            preparedStatement.setString(6,scrq);
            preparedStatement.setString(7,yxqz);
            int row=preparedStatement.executeUpdate();
            if(row>0){
                flag=true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            DBclose.close(resultSet,preparedStatement);
        }
        return flag;
    }

    /**
     * 根据厂商ID获取其所有药品
     * @param id
     * @return
     */
    public List<Drug> getMedicineByID(String id){
        List<Drug> drugs=new ArrayList<>();
        Connection connection=null;
        PreparedStatement preparedStatement=null;
        ResultSet resultSet=null;
        try{
            connection=DBconn.getConnInstance(Constant.Administrator);
            String sql="select 药品ID,药名 FROM 药品 where 生产商ID=?";
            preparedStatement=connection.prepareStatement(sql);
            preparedStatement.setString(1,id);
            resultSet=preparedStatement.executeQuery();
            while (resultSet.next()){
                Drug drug=new Drug();
                drug.setDrugID(resultSet.getString(1));
                drug.setDrugName(resultSet.getString(2));
                drugs.add(drug);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drugs;
    }
}
