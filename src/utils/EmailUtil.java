package utils;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    // ⚠️ Remplace avec ton email Gmail
    private static final String SENDER_EMAIL = "rakotomihaminasandafitia@gmail.com";

    // ⚠️ Utilise un mot de passe d'application Gmail (PAS ton vrai mot de passe)
    private static final String SENDER_PASSWORD = "rhgiqmfiibpxmekf";

    public static void sendEmail(String recipient, String subject, String body) {

        // Configuration SMTP Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Authentification
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        try {
            // Création du message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(recipient)
            );
            message.setSubject(subject);
            message.setText(body);

            // Envoi
            Transport.send(message);

            System.out.println("Email envoyé avec succès à : " + recipient);

        } catch (MessagingException e) {
            System.out.println("Erreur lors de l'envoi de l'email");
            e.printStackTrace();
        }
    }
}