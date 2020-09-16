@isTest
public class BusinessClass1Test {
    
    public static testMethod void test1(){
        BusinessClass1 bc = new BusinessClass1();
        bc.add(10, 10);
        bc.sub(10,10);
        bc.multiply(20,20);
    }
    
    public static testMethod void test2(){
        BusinessClass1 bc = new BusinessClass1();
        bc.add(110, 110);
        bc.sub(110,110);
        bc.multiply(110,110);
    }
}
