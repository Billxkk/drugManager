package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 药品信息实体类
 */
public class Drug {
    /**
     * 药品ID
     */
    private String drugID;
    /**
     * 药名
     */
    private String drugName;

    /**
     * 种类ID
     */
    private String typeName;
    /*
    * 种类名
     */
    private String typeID;
    /**
     * 进价
     */
    private double buyPrice;
    /**
     * 售价
     */
    private double salePrice;
    /**
     * 生产商ID
     */

    private String producerID;


    /*
    * 生产商名称
     */
    private String produceName;


    public String getDrugID() {
        return drugID;
    }

    public void setDrugID(String drugID) {
        this.drugID = drugID;
    }

    public String getDrugName() {
        return drugName;
    }

    public void setDrugName(String drugName) {
        this.drugName = drugName;
    }

    public String getTypeID() {
        return typeID;
    }

    public void setTypeID(String typeID) {
        this.typeID = typeID;
    }

    public double getBuyPrice() {
        return buyPrice;
    }

    public void setBuyPrice(double buyPrice) {
        this.buyPrice = buyPrice;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public String getProducerID() {
        return producerID;
    }

    public void setProducerID(String producerID) {
        this.producerID = producerID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getProduceName() {
        return produceName;
    }

    public void setProduceName(String produceName) {
        this.produceName = produceName;
    }

}
