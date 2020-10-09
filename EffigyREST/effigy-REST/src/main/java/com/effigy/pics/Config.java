package com.effigy.pics;

public class Config {
    static String USER = "mediaUser";
    static String PWD = "password";
    static String DATABASE ="effigy3";
    static String SERVER="192.168.0.111";
    //static String SERVER="192.168.0.109";

    public static String getConnectionString (){
        return  "jdbc:mysql://"+ SERVER+"/"+ DATABASE + "?" + "user=" + USER + "&" + "password="+ PWD;
    }
}
