class SQLiteHelper{

  static final String createTableStatement = "CREATE TABLE";
  static final String textFieldIndicator = "TEXT";
  static final String integerFieldIndicator = "INTEGER";
  static final String dateTimeFieldIndicator = "DATETIME";
  static final String primaryKeyIndicator = "PRIMARY KEY";
  static final String foreignKeyIndicator = "FOREIGN KEY";


  /// primary column
  static String primaryColumn(String columnName){
    return columnName + " " + textFieldIndicator + " " + primaryKeyIndicator;
  }

  /// Normal column
  static String column(String columnName){
    return columnName + " " + textFieldIndicator;
  }

  /// Create table
  static String createTable(String tableName){
    return createTableStatement + " " + tableName + "(";
  }

  /// Foreign column
  static String foreignColumn(String columnName){
    return columnName + " " + textFieldIndicator + " " + foreignKeyIndicator;
  }

  /// Insert statement
  static String insertStatement(String tableName){
    return "INSERT INTO " + tableName + " (";
  }

  /// column append
  static String insertColumnAppend(List<String> columnName){
    String appendedColumn;
    columnName.forEach((column){
      appendedColumn == null?appendedColumn = column:appendedColumn = appendedColumn + "," + column;
    });
    return appendedColumn;
  }
}