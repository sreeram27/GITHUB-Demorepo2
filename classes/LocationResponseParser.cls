// SPRINT 192.4 - XMen - Shifted from COM1
public class LocationResponseParser {
  public LocationResponseParser(){}
  public class Address {
    public String addressLine {get;set;} 
    public String adminDistrict {get;set;} 
    public String adminDistrict2 {get;set;} 
    public String countryRegion {get;set;} 
    public String formattedAddress {get;set;} 
    public String locality {get;set;} 
    public String postalCode {get;set;}
    public Address(){}
    public Address(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'addressLine') {
              addressLine = parser.getText();
            } else if (text == 'adminDistrict') {
              adminDistrict = parser.getText();
            } else if (text == 'adminDistrict2') {
              adminDistrict2 = parser.getText();
            } else if (text == 'countryRegion') {
              countryRegion = parser.getText();
            } else if (text == 'formattedAddress') {
              formattedAddress = parser.getText();
            } else if (text == 'locality') {
              locality = parser.getText();
            } else if (text == 'postalCode') {
              postalCode = parser.getText();
            } else {
              System.debug(LoggingLevel.WARN, 'Address consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }
  
  public class GeocodePoint {
    public String type_Z {get;set;} // in json: type
    public List<Double> coordinates {get;set;} 
    public String calculationMethod {get;set;} 
    public List<String> usageTypes {get;set;}
    public GeocodePoint(){}

    public GeocodePoint(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'type') {
              type_Z = parser.getText();
            } else if (text == 'coordinates') {
              coordinates = arrayOfDouble(parser);
            } else if (text == 'calculationMethod') {
              calculationMethod = parser.getText();
            } else if (text == 'usageTypes') {
              usageTypes = arrayOfString(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'GeocodePoints consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }
  
  public String authenticationResultCode {get;set;} 
  public String brandLogoUri {get;set;} 
  public String copyright {get;set;} 
  public List<ResourceSet> resourceSets {get;set;}
  public Integer statusCode {get;set;} 
  public String statusDescription {get;set;} 
  public String traceId {get;set;} 

  public LocationResponseParser(JSONParser parser) {
    while (parser.nextToken() != System.JSONToken.END_OBJECT) {
      if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
        String text = parser.getText();
        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
          if (text == 'authenticationResultCode') {
            authenticationResultCode = parser.getText();
          } else if (text == 'brandLogoUri') {
            brandLogoUri = parser.getText();
          } else if (text == 'copyright') {
            copyright = parser.getText();
          } else if (text == 'resourceSets') {
            resourceSets = arrayOfResourceSets(parser);
          } else if (text == 'statusCode') {
            statusCode = parser.getIntegerValue();
          } else if (text == 'statusDescription') {
            statusDescription = parser.getText();
          } else if (text == 'traceId') {
            traceId = parser.getText();
          } else {
            System.debug(LoggingLevel.WARN, 'LocationResponseParser consuming unrecognized property: '+text);
            consumeObject(parser);
          }
        }
      }
    }
  }
  
  public class Point {

    public String type_Z {get;set;} // in json: type
    public List<Double> coordinates {get;set;}

    public Point(){}
    public Point(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'type') {
              type_Z = parser.getText();
            } else if (text == 'coordinates') {
              coordinates = arrayOfDouble(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'Point consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }
  
  public class Resource {
    public String type_x {get;set;} // in json: __type
    public List<Double> bbox {get;set;} 
    public String name {get;set;} 
    public Point point {get;set;} 
    public Address address {get;set;} 
    public String confidence {get;set;} 
    public String entityType {get;set;} 
    public List<GeocodePoint> geocodePoints {get;set;}
    public List<String> matchCodes {get;set;} 

    public Resource(){}
    public Resource(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == '__type') {
              type_x = parser.getText();
            } else if (text == 'bbox') {
              bbox = arrayOfDouble(parser);
            } else if (text == 'name') {
              name = parser.getText();
            } else if (text == 'point') {
              point = new Point(parser);
            } else if (text == 'address') {
              address = new Address(parser);
            } else if (text == 'confidence') {
              confidence = parser.getText();
            } else if (text == 'entityType') {
              entityType = parser.getText();
            } else if (text == 'geocodePoints') {
              geocodePoints = arrayOfGeocodePoints(parser);
            } else if (text == 'matchCodes') {
              matchCodes = arrayOfString(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'Resource consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }
  
  public class ResourceSet {
    public Integer estimatedTotal {get;set;} 
    public List<Resource> resources {get;set;}
    public ResourceSet(){}

    public ResourceSet(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'estimatedTotal') {
              estimatedTotal = parser.getIntegerValue();
            } else if (text == 'resources') {
              resources = arrayOfResources(parser);
            } else {
              System.debug(LoggingLevel.WARN, 'ResourceSets consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }
  
  public static LocationResponseParser parse(String json) {
    System.JSONParser parser = System.JSON.createParser(json);
    return new LocationResponseParser(parser);
  }
  
  public static void consumeObject(System.JSONParser parser) {
    Integer depth = 0;
    do {
      System.JSONToken curr = parser.getCurrentToken();
      if (curr == System.JSONToken.START_OBJECT || 
        curr == System.JSONToken.START_ARRAY) {
        depth++;
      } else if (curr == System.JSONToken.END_OBJECT ||
        curr == System.JSONToken.END_ARRAY) {
        depth--;
      }
    } while (depth > 0 && parser.nextToken() != null);
  }
  
    private static List<Resource> arrayOfResources(System.JSONParser p) {
        List<Resource> res = new List<Resource>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Resource(p));
        }
        return res;
    }

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<GeocodePoint> arrayOfGeocodePoints(System.JSONParser p) {
        List<GeocodePoint> res = new List<GeocodePoint>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new GeocodePoint(p));
        }
        return res;
    }

    private static List<ResourceSet> arrayOfResourceSets(System.JSONParser p) {
        List<ResourceSet> res = new List<ResourceSet>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ResourceSet(p));
        }
        return res;
    }

    private static List<Double> arrayOfDouble(System.JSONParser p) {
        List<Double> res = new List<Double>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getDoubleValue());
        }
        return res;
    }
}