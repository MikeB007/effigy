package com.effify.pics;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.sql.Statement;
import java.sql.ResultSet;


import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;



import java.sql.*;

public class showResult {
    static Config c;

    public static String getLocations() {
        return("Data");
    }

    public static JSONArray getTable(String table) {

   try {
        Class.forName("com.mysql.jdbc.Driver").newInstance();
    } catch (Exception ex) {
        // handle the error
    }
    Connection conn = null;
		try {
        conn =
                DriverManager.getConnection(c.getConnectionString());

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
        rs = stmt.executeQuery("select * from " + table);
        System.out.println("Finished DB call");
        // or alternatively, if you don't know ahead of time that
        // the query will be a SELECT...
        //if (stmt.execute("SELECT foo FROM bar")) {
        //	rs = stmt.getResultSet();
        //}

        ResultSetMetaData rsmd = rs.getMetaData();
        while(rs.next()) {
            int numColumns = rsmd.getColumnCount();
            JSONObject obj = new JSONObject();
           // for (int i=numColumns; i>1; i--) {
           //     String column_name = rsmd.getColumnName(i);
           //     obj.put(column_name, rs.getObject(column_name));
           // }
            for (int i=1; i<=numColumns; i++) {
                String column_name = rsmd.getColumnName(i);
                obj.put(column_name, rs.getObject(column_name));
            }

            json.add(obj);
        }

    }

		catch (SQLException ex){
        // handle any errors
        System.out.println("SQLException: " + ex.getMessage());
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("VendorError: " + ex.getErrorCode());
    }
		finally {
        // it is a good idea to release
        // resources in a finally{} block
        // in reverse-order of their creation
        // if they are no-longer needed

        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException sqlEx) { } // ignore

            rs = null;
        }

        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException sqlEx) { } // ignore

            stmt = null;
        }
    }
		System.out.println("Converted to json");
    //Connection con =
    return(json);
    }


    public static JSONArray getFolders() {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
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
            rs = stmt.executeQuery("select * from loc_folder");
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }


    public static JSONArray getMedia (int folder) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
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
            String sql = "select substring(M.media_key,10) as urlLink, M.* , MA.* from  MEDIA M LEFT JOIN ATTRIB MA ON M.MEDIA_ID = MA.MEDIA_ID WHERE  M.folder_id = " + folder;
            System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }

    public static JSONArray getYears (int year) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
        } catch (
                SQLException ex) {
            // handle any errors
            System.out.println("oops");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }

        JSONArray json = new JSONArray();
        Statement stmt = null;
        ResultSet rs = null;
        String sql;

        try {
            stmt = conn.createStatement();
            if (year == 0 ) {
                 sql = "select distinct(YEAR(dttaken))  as THIS_YEAR,COUNT(*) as TOTAL  from media M  GROUP BY YEAR(dttaken) order by THIS_YEAR DESC";
            }
            else{
                 sql = "select substring(M.media_key,10) as urlLink, M.* ,MA.* from media M, ATTRIB MA  WHERE M.MEDIA_ID = MA.MEDIA_ID AND YEAR(M.dttaken) =" + year + " ORDER BY M.DTTAKEN ASC LIMIT 30";
            }
            System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }








    public static JSONArray getSingleMedia (int id) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
        } catch (
                SQLException ex) {
            // handle any errors
            System.out.println("oops");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }

        JSONArray json = new JSONArray();
        Statement stmt = null;
        ResultSet rs = null;
        String sql;

        try {
            stmt = conn.createStatement();
                sql = "select * from media where media_id = " + id;

            System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();po
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }


    public static JSONArray getSingleMedia (String name) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
        } catch (
                SQLException ex) {
            // handle any errors
            System.out.println("oops");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }

        JSONArray json = new JSONArray();
        Statement stmt = null;
        ResultSet rs = null;
        String sql;

        try {
            stmt = conn.createStatement();
            sql = "select m.*, am.*  from media m, attrib am  where m.media_id = am.media_id and name = '"+name +"'";

            System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();po
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }


    public static JSONArray getTimeline (int year) {

        try {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
        } catch (
                SQLException ex) {
            // handle any errors
            System.out.println("oops");
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }

        JSONArray json = new JSONArray();
        Statement stmt = null;
        ResultSet rs = null;
        String sql;

        try {
            stmt = conn.createStatement();
            if (year ==0) { // get full timeline
                sql = " select year(DTTAKEN) as TAKEN, MONTH(DTTAKEN)  AS THIS_MONTH,DATE_FORMAT(DTTAKEN,'%M') AS MONTH_LONG , DATE_FORMAT(DTTAKEN,'%b') AS MONTH_SHORT, PATH, COUNT(*) as TOTAL from media M WHERE YEAR(DTTAKEN) >0 GROUP BY YEAR(M.DTTAKEN),MONTH(M.DTTAKEN)  ORDER BY M.DTTAKEN ASC";
            }
            else{
                sql = " select year(DTTAKEN) AS TAKEN,MONTH(DTTAKEN)  AS THIS_MONTH,DATE_FORMAT(DTTAKEN,'%M') AS MONTH_LONG , DATE_FORMAT(DTTAKEN,'%b') AS MONTH_SHORT, PATH, COUNT(*) as TOTAL from media M WHERE YEAR(DTTAKEN) >" + year + " GROUP BY YEAR(M.DTTAKEN),MONTH(M.DTTAKEN)  ORDER BY M.DTTAKEN ASC";
            }

            System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();po
            //}

            ResultSetMetaData rsmd = rs.getMetaData();
            while(rs.next()) {
                int numColumns = rsmd.getColumnCount();
                JSONObject obj = new JSONObject();
                // for (int i=numColumns; i>1; i--) {
                //     String column_name = rsmd.getColumnName(i);
                //     obj.put(column_name, rs.getObject(column_name));
                // }
                for (int i=1; i<=numColumns; i++) {
                    String column_name = rsmd.getColumnName(i);
                    obj.put(column_name, rs.getObject(column_name));
                }

                json.add(obj);
            }

        }

        catch (SQLException ex){
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
        finally {
            // it is a good idea to release
            // resources in a finally{} block
            // in reverse-order of their creation
            // if they are no-longer needed

            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException sqlEx) { } // ignore

                rs = null;
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) { } // ignore

                stmt = null;
            }
        }
        System.out.println("Converted to json");
        //Connection con =
        return(json);
    }






}
