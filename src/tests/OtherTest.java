package tests;

import beans.Drug;
import utils.BuyerDAO;
import utils.Constant;
import utils.createStaffId;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static utils.Constant.Administrator;
import static utils.Constant.buyer;

public class OtherTest{
    public static void main(String[] args) {
        List<Drug> drugs=new ArrayList<>();
        BuyerDAO buyerDAO=new BuyerDAO();
        drugs=buyerDAO.getMedicineByID("110");
        for (Drug drug :
                drugs) {
            System.out.println(drug.getDrugID()+"  "+drug.getDrugName());
        }
    }
}
