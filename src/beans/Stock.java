package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 库存信息实体类
 */
public class Stock {
    /**
     * 药品ID
     */
    private String drugID;

    private String drugName;
    /**
     * 生产日期
     */
    private String produceDate;
    /**
     * 有效期至
     */
    private String vaildDate;
    /**
     * 库存数量
     */
    private int quantity;

    public String getDrugID() {
        return drugID;
    }

    public void setDrugID(String drugID) {
        this.drugID = drugID;
    }

    public String getProduceDate() {
        return produceDate;
    }

    public void setProduceDate(String produceDate) {
        this.produceDate = produceDate;
    }

    public String getVaildDate() {
        return vaildDate;
    }

    public void setVaildDate(String vaildDate) {
        this.vaildDate = vaildDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }


    public String getDrugName() {
        return drugName;
    }

    public void setDrugName(String drugName) {
        this.drugName = drugName;
    }
}
