package beans;

/**
 * Created by bill xu on 2018/1/5.
 * 药品种类信息实体类
 */
public class DrugType {
    /**
     * 种类ID
     */
    private String ID;
    /**
     * 种类名称
     */
    private String typeName;
    /**
     * 父类ID
     */
    private String parentID;

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getParentID() {
        return parentID;
    }

    public void setParentID(String parentID) {
        this.parentID = parentID;
    }
}
