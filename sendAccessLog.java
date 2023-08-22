import com.jcraft.jsch.*;
  
public class sendAccessLog {
    public static void main(String[] args) {
        String bServerHost = "[ip address]";
        String bServerUsername = "root";
        String bServerPassword = "[password]";
        int bServerPort = 22;

        String localFilePath = "/var/log/apache2/other_vhosts_access.log";
        String remoteFilePath = "/opt/other_vhosts_access.log"; // B 서버에 저장될 경로 및 파일명

        try {
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

            System.out.println("파일 전송 및 저장 완료");
        } catch (JSchException e) {
            e.printStackTrace();
            System.out.println("JSch 오류 발생: " + e.getMessage());
        } catch (SftpException e) {
            e.printStackTrace();
            System.out.println("SFTP 오류 발생: " + e.getMessage());
        }
    }
}
