<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.Socket"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Path"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jcraft.jsch.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WordPress 사용자 로그 </title>
</head>

<h2>Hadoop에 Log 전송하기</h2>
	
        <button onclick="sendActivityLog()" style="background-color:skyblue; padding: 20px 50px 20px 50px;" >사용자 Activity Log 전송</button>

	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        <button onclick="sendAccessLog()" style="background-color:yellow; padding: 20px 50px 20px 50px;" >Access Log 전송</button>

<%
// 원본 파일의 경로를 지정합니다.
String source = "/var/log/apache2/other_vhosts_access.log";

// NCP Hadoop의 IP 주소와 포트 번호를 지정합니다.
String ipAddress = "[ip address]";
int portNumber = 22;

// 사용자 이름과 비밀번호를 지정합니다.
String userName = "root";
String password = "[password]";
%>



<body>
<h2>Activity Log Viewer 테이블 내용</h2>
<table width="100%" border="1">
	<thead>
		<tr>
			<td width=50><p align=center>uactid</p></td>
			<td width=50><p align=center>post_id</p></td>
			<td width=50><p align=center>post_title</p></td>
			<td width=50><p align=center>user_id</p></td>
                  <td width=50><p align=center>user_name</p></td>
			<td width=50><p align=center>user_role</p></td>
                  <td width=50><p align=center>user_email</p></td>
                  <td width=50><p align=center>ip_address</p></td>
                  <td width=50><p align=center>modified_date</p></td>
                  <td width=50><p align=center>object_type</p></td>
                  <td width=50><p align=center>action</p></td>
		</tr>
	</thead>
	<tbody>
	<%
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try{
			String jdbcDriver = "jdbc:mysql://[ip address]/wordpress";
			String dbUser = "wordpress";
			String dbPwd = "wordpress";
			
			conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPwd);
			
			pstmt = conn.prepareStatement("select * from wp_ualp_user_activity");
			
			rs = pstmt.executeQuery();

			while(rs.next()){
	%>
		<tr>
			<td><%=rs.getInt("uactid")%></td>
			<td><%=rs.getInt("post_id")%></td>
			<td><%=rs.getString("post_title")%></td>
			<td><%=rs.getInt("user_id")%></td>
			<td><%=rs.getString("user_name")%></td>
			<td><%=rs.getString("user_role")%></td>
			<td><%=rs.getString("user_email")%></td>
			<td><%=rs.getString("ip_address")%></td>
                  <td><%= rs.getTimestamp("modified_date") %></td>
			<td><%=rs.getString("object_type")%></td>
			<td><%=rs.getString("action")%></td>

		</tr>


	<%
			}

		}catch(SQLException se){
			se.printStackTrace();
		}finally{
			// if(pstmt != null) pstmt.close();
                	// if(conn != null) conn.close();
		}
	%>
	</tbody>
</table> 


        <script>
           function sendActivityLog() {

	 <%
   	Connection conn2=null;
	PreparedStatement pstmt2=null;
//	ResultSet rs2=null;
	ResultSet rs2 = pstmt.executeQuery();

   String str2="";
	  try {
     String jdbcUrl2="jdbc:mysql://[ip address]/wordpress";
     String dbId2="wordpress";
     String dbPass2="wordpress";

         Class.forName("com.mysql.jdbc.Driver");
         conn2=DriverManager.getConnection(jdbcUrl2, dbId2, dbPass2);
	 while(rs2.next()){

         String sql2= "insert into wp_ualp_user_activity values (?,?,?,?,?,?,?,?,?,?,?)";
         pstmt2=conn2.prepareStatement(sql2);
         pstmt2.setInt(1,rs2.getInt("uactid"));
         pstmt2.setInt(2,rs2.getInt("post_id"));
         pstmt2.setString(3,rs2.getString("post_title"));
         pstmt2.setInt(4,rs2.getInt("user_id"));
         pstmt2.setString(5,rs2.getString("user_name"));
         pstmt2.setString(6,rs2.getString("user_role"));
         pstmt2.setString(7,rs2.getString("user_email"));
	 pstmt2.setString(8,rs2.getString("ip_address"));
	 pstmt2.setTimestamp(9,rs2.getTimestamp("modified_date"));
	 pstmt2.setString(10,rs2.getString("object_type"));
	 pstmt2.setString(11,rs2.getString("action"));
         pstmt2.executeUpdate();
	    } 
 %>
         alert("wp_ualp_user_activity 테이블에 새로운 레코드를 추가했습니다.");
 <%
        }catch(Exception e){
                e.printStackTrace();
 %>
 	alert("wp_ualp_user_activity 테이블에 새로운 레코드를 추가에 실패했습니다. ");
 <%
        }finally{
                if(pstmt2 != null)
                        try{pstmt2.close();}catch(SQLException sqle){}
                if(conn2 != null)
                        try{conn2.close();}catch(SQLException sqle){}
 		if(rs2 != null)
                        try{rs2.close();}catch(SQLException sqle){}
                if(pstmt != null)
                        try{pstmt2.close();}catch(SQLException sqle){}
                if(conn != null)
                        try{conn2.close();}catch(SQLException sqle){}
                if(rs != null)
                        try{rs2.close();}catch(SQLException sqle){}
	    
	    }
 %>
	 }  
       </script>
</body>

<body>
       <script>
           function sendAccessLog() {

<%
try {
    String bServerHost = "[ip address]";
    String bServerUsername = "root";
    String bServerPassword = "[password]";
    int bServerPort = 22;

    String localFilePath = "/var/log/apache2/other_vhosts_access.log";
    String remoteFilePath = "/opt/other_vhosts_access.log"; // B 서버에 저장될 경로 및 파일명

    JSch jsch = new JSch();
    Session jschsession = jsch.getSession(bServerUsername, bServerHost, bServerPort);
    jschsession.setPassword(bServerPassword);
    jschsession.setConfig("StrictHostKeyChecking", "no"); // 호스트 키 체크 비활성화
    jschsession.connect();

    ChannelSftp channelSftp = (ChannelSftp) jschsession.openChannel("sftp");
    channelSftp.connect();

    channelSftp.put(localFilePath, remoteFilePath);

    channelSftp.disconnect();
    jschsession.disconnect();

%>
         alert("Access Log 파일 전송에 성공했습니다.");
<%
        }catch(Exception e){
                e.printStackTrace();
 %>
        alert("Access Log 파일 전송에 실패했습니다. ");
<%
}
%>

	    }
       </script>
</body>
</html>
