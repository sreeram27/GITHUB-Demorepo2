// SPRINT 192.4 - XMen - Shifted from COM1
public class TravelResponse {
  
    public List<String> destination_addresses;
  public List<String> origin_addresses;
  public List<RowObject> rows {get; set;}
  public String status; // added for storing response status
  
  

  public class ElementObject {
    public ResultObject distance {get; set;}
    public ResultObject duration {get; set;}
    public String status;
  }

  public class ResultObject {
    public String text {get; set;}
    public Integer value {get; set;}
        
        public ResultObject(String text, Integer value) {
            this.text = text;
            this.value = value;
        }
  }

  public class RowObject {
    public List<ElementObject> elements {get; set;}
  }    
}