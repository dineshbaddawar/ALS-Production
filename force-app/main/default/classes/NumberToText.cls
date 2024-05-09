public class NumberToText {
    
    public static String string1;
    public static List<String> st1 = new String[]{ ' ', 'One', 'Two', 'Three', 'Four', 'Five', 'Six','Seven', 'Eight', 'Nine' };
        public static List<String> st2 = new String[]{ 'Hundred', 'Thousand', 'Lakh', 'Crore' };
            public static List<String> st3 = new String[]{ 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen','Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Ninteen' };
                public static List<String> st4 = new String[]{ 'Twenty', 'Thirty', 'Fourty', 'Fifty', 'Sixty', 'Seventy','Eighty', 'Ninty' };
                    
                    
                    public static String convert(Integer number1) {
                        Integer n = 1;
                        Integer word;
                        string1 = '';
                        
                        while (number1 != 0)
                        {
                            
                            if(n==1)
                            {
                                word = Math.mod(number1, 100);
                                pass(word);
                                
                                if (number1 > 100 && Math.mod(number1, 100) != 0) {
                                    show('and ');
                                }
                                number1 /= 100;
                            }
                            
                            else if (n==2)
                            {
                                word = Math.mod(number1,10);
                                if (word != 0) {
                                    show(' ');
                                    show(st2[0]);
                                    show(' ');
                                    pass(word);
                                }
                                number1 /= 10;
                            }
                            
                            else if (n==3)
                            {            word = Math.mod(number1, 100);
                             if (word != 0) {
                                 show(' ');
                                 show(st2[1]);
                                 show(' ');
                                 pass(word);
                             }
                             number1 /= 100;
                            }
                            
                            else if (n==4)
                            {            word = Math.mod(number1, 100);
                             if (word != 0) {
                                 show(' ');
                                 show(st2[2]);
                                 show(' ');
                                 pass(word);
                             }
                             number1 /= 100;
                            }
                            else if(n==5)
                            {            word = Math.mod(number1, 100);
                             if (word != 0) {
                                 show(' ');
                                 show(st2[3]);
                                 show(' ');
                                 pass(word);
                             }
                             number1 /= 100;
                            }
                            
                            n++;
                        }
                        return string1;
                    }
    
    
    public static void pass(integer number1) {
        integer word, q;
        if (number1 < 10) {
            show(st1[number1]);
        }
        if (number1 > 9 && number1 < 20) {
            show(st3[number1 - 10]);
        }
        if (number1 > 19) {
            word = Math.mod(number1, 10);
            if (word == 0) {
                q = number1 / 10;
                show(st4[q - 2]);
            } else {
                q = number1 / 10;
                show(st1[word]);
                show(' ');
                show(st4[q - 2]);
            }
        }
    }
    
    
    public static void show(String s) {
        String st;
        st = string1;
        string1 = s;
        string1 += st;
    }
}