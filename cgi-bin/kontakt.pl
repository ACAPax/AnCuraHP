#!/usr/bin/perl -w
use strict;
use CGI;
use Email::Valid;

my $query = new CGI;

# Die hier definierte E-Mail-Adresse MUSS bei goneo als E-Mail-Konto oder Alias existieren!
my $sendmail = "/usr/sbin/sendmail -t -i -finfo\@ancura.eu";

# Dies ist die Absender-E-Mail-Adresse, welche in der Mail auftaucht.
my $web_absender = $query->param('email_address');
#my $absender = "From: $web_absender\n";
my $absender = "From: info\@ancura.eu\n";

# Hierbei handelt es sich um die Empfänger-E-Mail-Adresse.
my $empfaenger = "To: web\@ancura.eu\n";

# Der Betreff
my $web_subject = $query->param('email_title');
my $subject = "Subject: $web_subject\n";

my $web_lastname = $query->param('lastname');

if ($web_lastname eq "") {
# Der Inhalt
#my $cgi = CGI->new();
  my $web_forename = $query->param('email_forename');
  my $web_surname = $query->param('email_surname');
  my $web_content = $query->param('email_text');
  my $web_privacy = $query->param('email_privacy');
  if ($web_privacy eq "on" ) { $web_privacy = "ja"; } else { $web_privacy = "nein"; }
  my $content ="Vorname: $web_forename\nNachname: $web_surname\nEmail: $web_absender\nDatenschutzbestimmung in Version 09.01.2020 akzeptiert: $web_privacy\n\n$web_content\n";

# E-Mail zum versenden vorbereiten und versenden
  open(SENDMAIL, "|$sendmail") or die "Fehler: $sendmail: $!";
  print SENDMAIL $absender;
  print SENDMAIL $empfaenger;
  print SENDMAIL $subject;
  print SENDMAIL "Content-type: text/plain\n\n";
  print SENDMAIL $content;
  close(SENDMAIL);
  print $query->header;

# Textausgabe im Browser
  print "Die E-Mail wurde versendet. Vielen Dank fuer Ihre Nachricht.";
}

else {
  print $query->header;
  print "Vielen Dank fuer den Spam!";
}

