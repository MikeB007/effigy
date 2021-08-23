package com.effigy.news;

import com.effigy.pics.Config;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.sql.*;

public class searchNews {
    static Config c;

    public static String getNewsHelp(int id) {
        String help;
        help = "<html> /news/search/{value}" + "<br>";
        help = help + "/news/search/{value}/details" + "<br>";

        help = help + "/news" + "<br>";
        help = help + "/news/headlines" + "<br>";

        help = help + "/news/latest" + "<br>";
        help = help + "/news/latest/search/{value}" + "<br>";

        help = help + "/news/latest/{period}" + "<br>";
        help = help + "/news/latest/source/{src}" + "<br>";
        help = help + "/news/stats" + "<br>";
        help = help + "</html>";
        return (help);
    }

    public static JSONArray getLNewsLabels(String keyword,int range) {
        int j =0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
            System.out.println("Driver not found");
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
           // conn = DriverManager.getConnection(c.getConnectionString());

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
//            rs = stmt.executeQuery("select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM, ARTICLE_URL from tradeview.news where as_of >= curdate() - " + range + " and label like '%" + keyword + "%' ORDER BY as_of DESC, article_dt desc, extracted_dt desc  limit 200");
//            rs = stmt.executeQuery("select  n.ID, n.label,n.src, date_format(n.as_of, '%a %b %D') as ARTICLE_DT , date_format(n.as_of,'%r') as ARTICLE_TM, n.ARTICLE_URL,NF.fav_ID as fav_ID from tradeview.news N left outer join tradeview.news_favourites NF on N.ID=NF.fav_id where n.as_of >= curdate() - " + range + " and n.label like '%" + keyword + "%' ORDER BY n.as_of DESC, n.article_dt desc, n.extracted_dt desc  limit 200");
            rs = stmt.executeQuery("select  n.ID, n.label,n.src, date_format(n.as_of, '%a %b %D') as ARTICLE_DT , date_format(n.as_of,'%r') as ARTICLE_TM, n.ARTICLE_URL,NFT1.fav_ID as fav_ID, DATEDIFF(CURDATE() , N.AS_OF) AS DAYS_OLD   from tradeview.news N left outer join ( select NFT.FAV_ID, max(NFT.added_dt), count(NFT.FAV_ID) as total  from TRADEVIEW.news_favourites NFT GROUP BY NFT.FAV_ID) NFT1 ON N.ID =NFT1.FAV_ID where N.as_of >= curdate() - " + range + " and N.label like '%" + keyword + "%' ORDER BY N.as_of DESC, N.article_dt desc, N.extracted_dt desc  limit 200");



            System.out.println("Finished DB call");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}
            ResultSetMetaData rsmd = rs.getMetaData();
            while (rs.next()) {
                j++;
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
        if (j>0)
        {
            saveKeyword (keyword, j);
        }
        return (json);
    }

    public static JSONArray getKeywords() {
        int j =0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
            System.out.println("Driver not found");
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
            // conn = DriverManager.getConnection(c.getConnectionString());

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
            rs = stmt.executeQuery("select K.keyword,count(*) as Total ,max(k.search_dt) as max_dt from tradeview.news_keywords K  group by K.keyword order by count(*) desc  limit 40");

            System.out.println("Finished DB call, get Keywords");
            // or alternatively, if you don't know ahead of time that
            // the query will be a SELECT...
            //if (stmt.execute("SELECT foo FROM bar")) {
            //	rs = stmt.getResultSet();
            //}
            ResultSetMetaData rsmd = rs.getMetaData();
            while (rs.next()) {
                j++;
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



    private static void saveKeyword(String keyword,int count) {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
            System.out.println("Driver not found");
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
            // conn = DriverManager.getConnection(c.getConnectionString());

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
            stmt.executeUpdate("insert into tradeview.news_keywords (keyword,search_dt,favourite,results)  values ('" + keyword + "',now(),1," + count + ")");
            System.out.println("Finished DB call");

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


            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) {
                } // ignore

                stmt = null;
            }
        }
        System.out.println("saved keyword:"+ keyword);
        //Connection con =
        return ;
    }

    private static boolean foundFavourite(int fID) throws SQLException {
        int j =0;
        int count = 0 ;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
            System.out.println("Driver not found");
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
            // conn = DriverManager.getConnection(c.getConnectionString());

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
            rs = stmt.executeQuery("select F.ID  from tradeview.news_favourites F where F.FAV_ID = " + fID + " ");

            System.out.println("Finished  FIND FAVOURITES");
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
                    rs.next();
                    if (rs.isFirst()) {
                        count = 1; //rs.getInt("rowcount");
                        System.out.println("Favourites matched: " + count + " row(s).");
                        }
                    } catch (SQLException throwables) {
                    throwables.printStackTrace();
                }
                rs.close();
                rs = null;
            }
            else{
                System.out.println("Match not found:" + fID );
            }

            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) {
                } // ignore

                stmt = null;
            }
        }
        return (count>0 ?true:false);
    }


    public static int saveFavourite(int id)  {
        //exit  not required to be saved
        try {
            if (foundFavourite(id)) return 0;
        } catch (SQLException throwables) {
            return 0;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            // handle the error
            System.out.println("Driver not found");
        }
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(c.getConnectionString());
            // conn = DriverManager.getConnection(c.getConnectionString());

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
            stmt.executeUpdate("insert into tradeview.news_favourites (fav_id,added_dt)  values (" + id + ",now())");
            System.out.println("Finished Insert Fav Call");

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


            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException sqlEx) {
                } // ignore

                stmt = null;
            }
        }
        System.out.println("saved favourite:"+ id);
        //Connection con =
        return 0;
    }


    public static JSONArray getLNewsDetails(String keyword,int range) {

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
            rs = stmt.executeQuery("select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM, ARTICLE_URL from tradeview.news where as_of >= curdate() - " + range + " and label like '%" + keyword + "%' ORDER BY as_of DESC, article_dt desc, extracted_dt desc  limit 200");
            System.out.println("Finished DB call");
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

    public static JSONArray getLatestNews(int period) {

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
            rs = stmt.executeQuery("select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM,ARTICLE_URL from tradeview.news  where as_of in (select max(as_of) from tradeview.news) order by  extracted_dt desc,article_dt desc limit 200");

            System.out.println("Finished DB call");
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


    public static JSONArray getLatestNewsHeadlines(int period) {

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
            rs = stmt.executeQuery("select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM, ARTICLE_URL from tradeview.news  where as_of in (select max(as_of) from tradeview.news) order by article_dt desc, extracted_dt desc  limit 200");

            System.out.println("Finished DB call");
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

    public static JSONArray getLatestNewsStats(int period) {

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
            rs = stmt.executeQuery("select  as_of, SRC, COUNT(*)  as Total from tradeview.news  where as_of in (select max(as_of) from tradeview.news) GROUP BY as_of,src  order by 3 desc  limit 200");
            System.out.println("Finished DB call");
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

    public static JSONArray getLatestNewsBySource(String src) {
        String sql;
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
            sql = "select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM, ARTICLE_URL from tradeview.news  where src= '" + src + "' and as_of in (select max(as_of) from tradeview.news) order by article_dt desc, extracted_dt desc  limit 200";
            //System.out.println(sql);
            rs = stmt.executeQuery(sql);
            System.out.println("Finished DB call");
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


    public static JSONArray getLatestNewsByKeyword(String  keyword) {
        String sql;
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
            sql = "select  ID, label,src, date_format(as_of, '%a %b %D') as ARTICLE_DT , date_format(as_of,'%r') as ARTICLE_TM, ARTICLE_URL from tradeview.news  where label like '%"  + keyword + "%'  and as_of in (select max(as_of) from tradeview.news) order by article_dt desc, extracted_dt desc  limit 200";
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
}
