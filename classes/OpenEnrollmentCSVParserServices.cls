/**************************************************************************

* Mod                      : 9/16/2019
  @Author               : Mehaboob
  @description        :added @TestVisible for ColumnNameWrapper(Line No. 235)
  @comment              : added @TestVisible for ColumnNameWrapper(Line No. 235) as part of PRDCRM-43038
                       
**************************************************************************/
public class OpenEnrollmentCSVParserServices
{
  public static final String CSV_FORMAT_ERROR_COLUMN_ROW_MISMATCH = 'This rows values do not match the number of header columns: ';
  public static final String API_NAME_NOT_FOUND = 'The API Name defined for this object is not found: ';
  public static final String API_NAME_BLANK = 'The API Name on the custom metadata type is blank';
  public static final String NO_MATCHING_CUSTOM_SETTING = 'This column does not have a custom metadata type setup for it';
  @TestVisible
  private static List<Open_Enrollment_CSV_Column__mdt> csvColumnNamesCMDT
  {
    get
    {
      if(csvColumnNamesCMDT == null)
      {
        csvColumnNamesCMDT = [SELECT Column_Name__c, API_Name__c 
                  FROM Open_Enrollment_CSV_Column__mdt 
                  WHERE Column_Name__c != NULL OR Column_Name__c != ''];
      }
      return csvColumnNamesCMDT;
    }
    set;
  }

  @TestVisible
  private static Map<String,String> csvColumnNames
  {
    get
    {
      if(csvColumnNames == null)
      {
        csvColumnNames = new Map<String,String>();
        for(Open_Enrollment_CSV_Column__mdt cmdtColumn : csvColumnNamesCMDT)
        {
          csvColumnNames.put(cmdtColumn.Column_Name__c.toUpperCase().trim(),cmdtColumn.API_Name__c);
        }

        if(csvColumnNames.isEmpty())
        {
          csvColumnNames = null;
        }
      }
      return csvColumnNames;
    }
    set;
  }

  @TestVisible
  private static Map<String,Schema.SObjectField> openEnrollmentFields
  {
    get
    {
      if(openEnrollmentFields == null)
      {
        openEnrollmentFields = Schema.SObjectType.SFDC_Volunteer_Event__c.fields.getMap();
      }
      return openEnrollmentFields;
    }
  }

  public static void readListOpenEnrollmentCSV(String csvString, Id parentId, UploadForOpenEnrollmentController controller)
  {
    BW_CSVParser fileReader = new BW_CSVParser(csvString);
    List<String> currentLine = fileReader.readLine();
    List<ColumnNameWrapper> columnNames = new List<ColumnNameWrapper>();
    List<OpenEnrollmentWrapper> enrollmentWrappers = new List<OpenEnrollmentWrapper>();
    Integer rowCount = 0;

    while(currentLine != null)
    {
      rowCount++;

      if(!isBlankRow(currentLine)) 
      {
        if(isHeaderRow(currentLine) && columnNames.isEmpty())
        {
          columnNames.addAll(generateColumnNames(currentLine,rowCount));
        }
        else
        {
          OpenEnrollmentWrapper enrollmentwrapper = createOpenEnrollment(currentLine,columnNames,parentId,rowCount);
          if(enrollmentwrapper.hasError)
          {
            controller.showErrorTable = true;
          }
          enrollmentWrappers.add(enrollmentwrapper);
        }
      }
      currentLine = fileReader.readLine();
    }

    controller.enrollmentWrappers = enrollmentWrappers;
    controller.columnNameWrappers = columnNames;
  }

  @TestVisible
  private static Boolean isHeaderRow(List<String> row)
  {
    for(String element : row)
    {
      if(csvColumnNames.keyset().contains(element.toUpperCase()))
      {
        return true;
      }
    }
    return false;
  }

  @TestVisible
  private static OpenEnrollmentWrapper createOpenEnrollment(List<String>row, List<ColumnNameWrapper> columnNames, Id parentId, Integer rowNumber)
  {
    OpenEnrollmentWrapper enrollmentWrapper;
    if(row.size() != columnNames.size())
    {
      Integer difference = row.size() - columnNames.size();
      String differenceAmount = difference > 0? 'Too many values ':'Too few values ';
      differenceAmount+= '('+difference+')';

      enrollmentWrapper = new OpenEnrollmentWrapper(null,rowNumber);
      enrollmentWrapper.errorMessage = CSV_FORMAT_ERROR_COLUMN_ROW_MISMATCH + differenceAmount; 
      return enrollmentWrapper;
    }
    
    SFDC_Volunteer_Event__c openEnrollment = new SFDC_Volunteer_Event__c(OE_Grouping__c=parentId);
    for(ColumnNameWrapper columnName : columnNames)
    {
      String fieldValue = row[columnName.index];
      if(columnName.isValid && String.isNotBlank(fieldValue))
      {
        Schema.DescribeFieldResult fieldDescribe = openEnrollmentFields.get(columnName.apiName).getDescribe();

        if(fieldDescribe.getType() == Schema.DisplayType.DOUBLE)
        {
          openEnrollment.put(columnName.apiName,Double.valueOf(fieldValue));
        }
        else if(fieldDescribe.getType() == Schema.DisplayType.INTEGER)
        {
          openEnrollment.put(columnName.apiName,Integer.valueOf(fieldValue));
        }
        else if(fieldDescribe.getType() == Schema.DisplayType.CURRENCY)
        {
          openEnrollment.put(columnName.apiName,Decimal.valueOf(fieldValue));
        }
        else if(fieldDescribe.getType() == Schema.DisplayType.BOOLEAN)
        {
          openEnrollment.put(columnName.apiName,Boolean.valueOf(fieldValue));
        }
        else if(fieldDescribe.getType() == Schema.DisplayType.DATE)
        {
          openEnrollment.put(columnName.apiName,Date.parse(fieldValue));
        }
        else
        {
          openEnrollment.put(columnName.apiName,fieldValue);
        }
      }
    }

    enrollmentWrapper = new OpenEnrollmentWrapper(openEnrollment,rowNumber);

    return enrollmentWrapper;
  }

  @TestVisible
  private static List<ColumnNameWrapper> generateColumnNames(List<String> row, Integer csvRow)
  {
    List<ColumnNameWrapper> columns = new List<ColumnNameWrapper>();
    
    for(Integer index = 0; index < row.size(); index++)
    {
      String element = row[index];
      columns.add(new ColumnNameWrapper(element,
                        csvColumnNames.get(element.toUpperCase().trim()),
                        index,
                        csvRow)
      );
    }
    return columns;
  }

  @TestVisible
  private static Boolean isBlankRow(List<String> row)
  {
    Set<String> uniqueValues = new Set<String>(row);
    uniqueValues.remove('');
    uniqueValues.remove(' ');
    uniqueValues.remove('\n');
    uniqueValues.remove('\r');
    return uniqueValues.isEmpty();
  }

 
  public class ColumnNameWrapper
  {
    public String errorMessage
    {  
      get 
      {
        if(errorMessage == null)
        {
          if(!csvColumnNames.keyset().contains(columnName.toUpperCase()))
          {
            errorMessage = NO_MATCHING_CUSTOM_SETTING;
          }
          else if(String.isBlank(apiName))
          {
            errorMessage = API_NAME_BLANK;
          }
          else if(openEnrollmentFields.keySet().contains(apiName.toLowerCase()))
          {
            errorMessage = API_NAME_NOT_FOUND + apiName;
          }
        }
        return errorMessage;
      }
      set;
    }
    public String columnName{get;set;}
    public String apiName{get;set;}
    public Integer index{get;set;}
    public Integer csvRow{get;set;}
    public Boolean isValid 
    {
      get 
      {
        return String.isNotBlank(apiName) && openEnrollmentFields.keySet().contains(apiName.toLowerCase());
      }
    }

    @TestVisible
    ColumnNameWrapper(String columnName, String apiName, Integer index, Integer csvRow)
    {
      this.columnName = columnName;
      this.apiName = apiName;
      this.index = index;
      this.csvRow = csvRow;
    }
  }

  public class OpenEnrollmentWrapper
  {
    public SFDC_Volunteer_Event__c openEnrollment{get;set;}
    public String errorMessage{get;set;}
    public Boolean hasError{get{return String.isNotBlank(errorMessage);}}
    public Integer csvRow{get;set;}

    OpenEnrollmentWrapper(SFDC_Volunteer_Event__c openEnrollment, Integer csvRow)
    {
      this.openEnrollment = openEnrollment;
      this.csvRow = csvRow;
    }
  }



}