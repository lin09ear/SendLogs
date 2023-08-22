<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jcraft.jsch.*" %>

<%
try {
    String bServerHost = "[ip address]";
    String bServerUsername = "root";
    String bServerPassword = "[password]";
    int bServerPort = 22;

    String localFilePath = "/var/log/apache2/other_vhosts_access.log";
    String remoteFilePath = "/logs/other_vhosts_access.log"; // B 서버에 저장될 경로 및 파일명

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

    out.println("파일 전송 및 저장 완료");
} catch (Exception e) {
    e.printStackTrace();
    out.println("파일 전송 중 오류 발생: " + e.getMessage());
}
%>
