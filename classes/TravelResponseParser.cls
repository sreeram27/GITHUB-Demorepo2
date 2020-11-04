/* SPRINT 192.4 - XMen - Shifted from COM1
*  Lifte and shifted from COM1 - XMen
* Test coverage through TravelResponseServiceTest
*/

/**************************************************************************

* Mod                      : 9/16/2019
  @Author               : Mehaboob
  @description        : added @TestVisible for getError,arrayOfDestinations as part of PRDCRM-43038
**************************************************************************/

public with sharing class TravelResponseParser extends TravelResponseService.TravelResponse {

  public String authenticationResultCode {get;set;} 
  public String brandLogoUri {get;set;} 
  public String copyright {get;set;} 
  public List<ResourceSet> resourceSets {get;set;} 
  public Integer statusCode {get;set;} 
  public String statusDescription {get;set;} 
  public String traceId {get;set;} 
  public TravelResponseParser(){}
  public TravelResponseParser(JSONParser parser) {
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
            System.debug(LoggingLevel.WARN, 'TravelResponseParser consuming unrecognized property: '+text);
            consumeObject(parser);
          }
        }
      }
    }
  }
    @TestVisible    
  public override String getError(Integer originIndex, Integer destinationIndex) {
            if(statusCode == 200){
               return '';
            }else{
                return statusDescription;
            }
        }

  public override DistanceMatrix getDistanceMatrix(Integer originIndex, Integer destinationIndex) {
    System.debug(resourceSets);
    Double travelDistanceDouble = resourceSets[0].resources[0].results[destinationIndex].travelDistance;
    Double travelDurationDouble = resourceSets[0].resources[0].results[destinationIndex].travelDuration;
    Double travelWalkDurationDouble = resourceSets[0].resources[0].results[destinationIndex].totalWalkDuration;
    String distance = ' ';
    String duration = ' ';

    if(travelDistanceDouble != null){
      System.debug(travelDistanceDouble);
          distance = Decimal.valueOf(travelDistanceDouble).setscale(2) + ' Miles';

      }
    else if(travelWalkDurationDouble != null){
      distance = Decimal.valueOf(travelWalkDurationDouble).setscale(2) + ' Miles';
    }

      if(travelDurationDouble != null){
          Integer totalSeconds = Integer.valueOf(travelDurationDouble);
          Integer hours = (Integer)Math.floor(totalSeconds/(60*60));
          Integer minutes = (Integer)Math.ceil((totalSeconds - (hours * 60 * 60) )/ 60 );
          String timeString = '';

          timeString+=hours>0 ? hours + ' hour'+ (hours>1 ? 's' : '') : '';
          timeString+=hours>0 && minutes>0 ? ', ' : '';
          timeString+=minutes>0 ? minutes + ' minute'+ (minutes>1 ? 's': ''): '';

          duration = timeString;
  System.debug('......DISTANCE = ' + distance + ' DURATION = ' + duration);

      }

      return new DistanceMatrix(distance, duration);
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

  public class Resource {
    public String aType {get;set;} // in json: __type
    public List<Destination> destinations {get;set;} 
    public List<Destination> origins {get;set;} 
    public List<Result> results {get;set;} 
    public String errorMessage {get; set;}
    public Resource(){}

    public Resource(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'aType') {
              aType = parser.getText();
            } else if (text == 'destinations') {
              destinations = arrayOfDestinations(parser);
            } else if (text == 'origins') {
              origins = arrayOfDestinations(parser);
            } else if (text == 'results') {
              results = arrayOfResults(parser);
            }  else if (text == 'errorMessage') {
                errorMessage = parser.getText();
              }
            else {
              System.debug(LoggingLevel.WARN, 'Resources consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Destination {
    public Double latitude {get;set;} 
    public Double longitude {get;set;}
    public Destination(){}

    public Destination(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'latitude') {
              latitude = parser.getDoubleValue();
            } else if (text == 'longitude') {
              longitude = parser.getDoubleValue();
            } else {
              System.debug(LoggingLevel.WARN, 'Destinations consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public class Result {
    public Integer destinationIndex {get;set;} 
    public Integer originIndex {get;set;} 
    public Double travelDistance {get;set;} 
    public Double travelDuration {get;set;} 
    public Double totalWalkDuration {get;set;}

    public Result(){}

    public Result(JSONParser parser) {
      while (parser.nextToken() != System.JSONToken.END_OBJECT) {
        if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
          String text = parser.getText();
          if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
            if (text == 'destinationIndex') {
              destinationIndex = parser.getIntegerValue();
            } else if (text == 'originIndex') {
              originIndex = parser.getIntegerValue();
            } else if (text == 'travelDistance') {
              travelDistance = parser.getDoubleValue();
            } else if (text == 'travelDuration') {
              travelDuration = parser.getDoubleValue();
            }
            else if (text == 'totalWalkDuration') {
              totalWalkDuration = parser.getDoubleValue();
            }else {
              System.debug(LoggingLevel.WARN, 'Results consuming unrecognized property: '+text);
              consumeObject(parser);
            }
          }
        }
      }
    }
  }

  public static TravelResponseParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new TravelResponseParser(parser);
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
    
    private static List<ResourceSet> arrayOfResourceSets(System.JSONParser p) {
        List<ResourceSet> res = new List<ResourceSet>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ResourceSet(p));
        }
        return res;
    }

 @TestVisible
    private static List<Destination> arrayOfDestinations(System.JSONParser p) {
        List<Destination> res = new List<Destination>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Destination(p));
        }
        return res;
    }

    private static List<Result> arrayOfResults(System.JSONParser p) {
        List<Result> res = new List<Result>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Result(p));
        }
        return res;
    }
    
    private static List<Resource> arrayOfResources(System.JSONParser p) {
        List<Resource> res = new List<Resource>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Resource(p));
        }
        return res;
    }
}