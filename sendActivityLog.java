import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class sendActivityLog {
    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String jdbcDriver = "jdbc:mysql://[ip address]/wordpress";
            String dbUser = "wordpress";
            String dbPwd = "wordpress";

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPwd);

            pstmt = conn.prepareStatement("select * from wp_ualp_user_activity");

            rs = pstmt.executeQuery();

            Connection conn2 = null;
            PreparedStatement pstmt2 = null;
            ResultSet rs2 = pstmt.executeQuery();

            String str2 = "";

            try {
                String jdbcUrl2 = "jdbc:mysql://[ip address]/wordpress";
                String dbId2 = "wordpress";
                String dbPass2 = "wordpress";

                Class.forName("com.mysql.cj.jdbc.Driver");
                conn2 = DriverManager.getConnection(jdbcUrl2, dbId2, dbPass2);


                while (rs2.next()) {
                    String sql2 = "insert into wp_ualp_user_activity values (?,?,?,?,?,?,?,?,?,?,?)";
                    pstmt2 = conn2.prepareStatement(sql2);
                    pstmt2.setInt(1, rs2.getInt("uactid"));
                    pstmt2.setInt(2, rs2.getInt("post_id"));
                    pstmt2.setString(3, rs2.getString("post_title"));
                    pstmt2.setInt(4, rs2.getInt("user_id"));
                    pstmt2.setString(5, rs2.getString("user_name"));
                    pstmt2.setString(6, rs2.getString("user_role"));
                    pstmt2.setString(7, rs2.getString("user_email"));
                    pstmt2.setString(8, rs2.getString("ip_address"));
                    pstmt2.setTimestamp(9, rs2.getTimestamp("modified_date"));
                    pstmt2.setString(10, rs2.getString("object_type"));
                    pstmt2.setString(11, rs2.getString("action"));
                    pstmt2.executeUpdate();
                }

                System.out.println("wp_ualp_user_activity 테이블에 새로운 레코드를 추가했습니다.");
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("wp_ualp_user_activity 테이블에 새로운 레코드를 추가에 실패했습니다.");
            } finally {
                if (rs2 != null) {
                    try {
                        rs2.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (pstmt2 != null) {
                    try {
                        pstmt2.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (conn2 != null) {
                    try {
                        conn2.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
