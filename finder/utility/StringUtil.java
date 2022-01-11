package utility;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtil {

    public static String removeThis(String alloyName){
        return alloyName.startsWith("this/") ? alloyName.substring(5) : alloyName;
    }

    public static String removeDollar(String name){
        return name.replaceAll("\\$", "");
    }

    public static String trimTypeStr(String type){
       return type.startsWith("{") ?
         removeThis( type.substring(1, type.length() - 1) ) :
               removeThis(type);
    }

    public static int countFile(String path){
        BufferedReader reader = null;
        int lines = 0;
        try {
            reader = new BufferedReader(new FileReader(path));
            String str = reader.readLine();
            while (str != null ) {
                if(!(str.trim().equals("") || str.trim().equals("\n") || str.trim().startsWith("//") || str.trim().startsWith("--"))) {
                    lines++;
                }
                str = reader.readLine();
            }
            reader.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lines;
    }

    public static String findSigName(String val){
        return val.split("\\$")[0];
    }

    public static Set<String> findAtoms(String str){
        Set<String> involvedAtoms = new HashSet<>();
        String ptn = "[a-zA-Z]*\\$[0-9]+";
        Pattern pattern = Pattern.compile(ptn);
        Matcher matcher = pattern.matcher(str);
        while(matcher.find())
            involvedAtoms.add(matcher.group());
        return involvedAtoms;
    }

    public static boolean isInteger(String str) {
        if (str == null) {
            return false;
        }
        int length = str.length();
        if (length == 0) {
            return false;
        }
        int i = 0;
        if (str.charAt(0) == '-') {
            if (length == 1) {
                return false;
            }
            i = 1;
        }
        for (; i < length; i++) {
            char c = str.charAt(i);
            if (c < '0' || c > '9') {
                return false;
            }
        }
        return true;
    }
}
