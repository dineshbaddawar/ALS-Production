@isTest
public class AmountInNumberToWordsTest {
    
    @isTest
    static void convertTest() {
        AmountInNumberToWords.convert(23.44);
        AmountInNumberToWords.convert(223.442);
        AmountInNumberToWords.convert(2232.4432);
        AmountInNumberToWords.convert(22352.4432);
        AmountInNumberToWords.convert(223332.4432);
    }
}