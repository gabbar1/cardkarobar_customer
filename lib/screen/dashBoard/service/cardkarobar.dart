import 'package:mailer/smtp_server.dart';


SmtpServer cardkarobarMail(String username, String password) =>
    SmtpServer('smtp.hostinger.com',
        port: 465, username: username, password: password);
