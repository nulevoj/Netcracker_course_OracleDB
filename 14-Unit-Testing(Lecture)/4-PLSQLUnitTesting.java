import java.sql.*;  
import oracle.jdbc.driver.*;

class PLSQLUnitTesting {
    public static void main(final String[] args) {
		// Test Cases Array with element = {Input-value,Expected-result}
		String [][] TCArray = {	
		                {"user1","1"}, 
						{"1user1","-1"}, 
						{"user1234567891011","-1"}
					};
		int testCaseResult = 0; // 0 = Passed -1 = Failed
        try {
            // load Oracle JDBC-drive
            DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
            // open Oracle server connection
            Connection con=DriverManager.getConnection(  
                                  "jdbc:oracle:thin:@91.219.60.189:1521/XEPDB1",
			args[0], // get login as 1th command line parameter
			args[1]); // get password as 2nd command line parameter 
            // create template string with PL/SQL-function "user_name_is_correct"
			CallableStatement cstmt1 = con.prepareCall("{? = call user_name_is_correct(?)}");
			// Register type of expected result for PL/SQL-function
			cstmt1.registerOutParameter(1,Types.NUMERIC);
			for (int i = 0; i < TCArray.length; i++) {
				String TCinputValue = TCArray[i][0];
				String TCExpectedResult = TCArray[i][1];
			    // Test-case N1(TC1)
			    System.out.print(
				    "TC" 
					+ (i+1) 
					+ "( user_name_is_correct('" 
					+ TCinputValue
					+ "') = " 
					+ TCExpectedResult
					+ ") := "
			    );
                // set template variable with input value of PL/SQL-function
			    cstmt1.setString(2, TCinputValue);
			    // execute query with PL/SQL-function
			    cstmt1.executeUpdate();
			    // analize TC-result
                if (cstmt1.getInt(1) == Integer.parseInt(TCExpectedResult)) 
			        System.out.println("Passed");
	            else { 
	                System.out.println("Failed");
			        testCaseResult = -1;
	            }
		    }	
			// close server connection 
            con.close();  
        }
	    catch(Exception e) { 
		    System.out.println(e); 
		}  
	    System.exit(testCaseResult);
    }    
}  
