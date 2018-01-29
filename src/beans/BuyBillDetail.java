package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 进货单详细信息实体类
 */
public class BuyBillDetail {
    /**
     * 进货单ID
     */
    private String BuyBillID;


    /**
     * 药品ID
     */
    private String BuyBillName;
    /*
    * 对，不要怀疑，这是药品名称
     */
    private String drugID;
    /**
     * 进货数量
     */
    private int number;
    /**
     * 进价
     */

    private double buyPrice;

    /*
     * 日期
     */
    private String date;

    public String getBuyBillID() {
        return BuyBillID;
    }

    public void setBuyBillID(String buyBillID) {
        BuyBillID = buyBillID;
    }

    public String getDrugID() {
        return drugID;
    }

    public void setDrugID(String drugID) {
        this.drugID = drugID;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public double getBuyPrice() {
        return buyPrice;
    }

    public void setBuyPrice(double buyPrice) {
        this.buyPrice = buyPrice;
    }

    public String getBuyBillName() {
        return BuyBillName;
    }

    public void setBuyBillName(String buyBillName) {
        BuyBillName = buyBillName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

}
