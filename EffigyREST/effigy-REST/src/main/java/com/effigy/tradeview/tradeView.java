package com.effigy.tradeview;

import com.effigy.pics.Config;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.sql.*;

public class tradeView {
    static Config c;
    public static String getTVHelp(int id) {
        String help;
        help = "<html> /api/tv/stats/{ticker}/{country}" + "<br>";
        help = help + "</html>";
        return (help);
    }


    public static JSONArray getLTVStats(String ticker,String country) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
            conn = DriverManager.getConnection(c.getConnectionString());

        } catch (
                SQLException ex) {
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }

        JSONArray json = new JSONArray();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT  date_format(inserted_dt, '%Y/%m/%d') as DT,recommend_all, close_ ,rec, symbol_,DESCRIPTION,EXCHANGE FROM tradeview.tradeview where ticker = '" + ticker + "' and COUNTRY_ ='" + country +"' and exchange  <> 'NEO' order by 1 desc");

            System.out.println("Finished DB call Tradeview Extract:" + ticker + "country:" + country);
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while (rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i = 1; i <= numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        } catch (SQLException ex) {
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        } finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) {
                } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) {
                } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return (json);
    }

 }
