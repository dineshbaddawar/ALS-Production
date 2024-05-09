@isTest
public class NumberToTextTest {

    @isTest
    static void testConvert_Zero() {
        String result = NumberToText.convert(0);
       
    }

    @isTest
    static void testConvert_SingleDigit() {
        String result = NumberToText.convert(1);

        result = NumberToText.convert(9);
        
    }

    @isTest
    static void testConvert_TwoDigit() {
        String result = NumberToText.convert(19);
       
        result = NumberToText.convert(20);
      
    }

    @isTest
    static void testConvert_ThreeDigit() {
        String result = NumberToText.convert(100);
        
        result = NumberToText.convert(234);
     
    }

    @isTest
    static void testConvert_GreaterThanThreeDigit() {
        String result = NumberToText.convert(1000);
     
        result = NumberToText.convert(1123);
  
    }



    @isTest
    static void testConvert_LargeNumber() {
        // Test a large number
        String result = NumberToText.convert(999999999);
        
    }

    @isTest
    static void testConvert_SmallNumber() {
        // Test a small number
        String result = NumberToText.convert(0);
 
    }

    @isTest
    static void testConvert_Boundary() {
        // Add test cases for boundary scenarios
    }
}