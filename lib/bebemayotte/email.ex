defmodule Bebemayotte.Email do
  use Bamboo.Phoenix, view: BebemayotteView
  alias Bebemayotte.Mailer
  # CREATE NEW MAIL MESSAGE
  def new_mail_message(email, message) do
    new_email()
    |>from("bbmaymayotte@outlook.fr")
    |>to(email)
    |>subject("Objet: VERIFICATION POUR MOT DE PASSE OUBLIÉ")
    |>html_body("<h1><b>BBMAY</b></h1><br/><p>Veuillez suivre le lien ci-dessous pour modifier votre mot de passe:</p><br/> #{message}")
  end

  def confirmation_mail(email, num_commande, prix, date, str_list_commandes, nom, user_map) do
    new_email()
      |>from("bbmaymayotte@outlook.fr")
      |>to(email)
      |>cc(["mihaja@phidia.onmicrosoft.com", "focicom@gmail.com", "pp@phidia.onmicrosoft.com", "matthieu@phidia.onmicrosoft.com"])
      |>subject("[BBMAY.FR] Confirmation de commande")
      |>html_body(
        "<div style=\"padding-left: 50px;padding-right: 50px;\">
        <center>
            <img src=\"https://bbmay.fr/images/bbmayimg/BANNER2-b290bce81897c2b4ed3ef3315ed3145b.jpg?vsn=d\">
            <p style=\"font-weight: bolder;font-family: Arial, Helvetica, sans-serif;\">Bbmay.Fr</p>
            <h1 style=\"font-family: Arial, Helvetica, sans-serif;font-weight: normal;\">NOUVELLE COMMANDE</h1>
        </center>
        <center>
            <p>Vous avez recu une commande de #{user_map['nom']} #{user_map['prenom']}, La commande est la suivante</p>
            <p>Commande ##{num_commande} (#{date})</p>
        <table style=\"border: 1px solid grey;border-collapse: collapse;\">
            <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;width: 200px;\">Produit</th>
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;\">Quantite</th>
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;\">Prix</th>
            </tr style=\"border: 1px solid grey;border-collapse: collapse;\">
            #{str_list_commandes}
            <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Sous-total</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">€#{prix}</td>
    </tr style=\"border: 1px solid grey;border-collapse: collapse;\">
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Expedition</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">Récuperer en boutique (0€ de frais). Vous allez être contacté par l'équipe Web pour organiser l'enlèvement de votre commande</td>
    </tr>
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Moyen de paiment</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">E-transaction payment</td>
    </tr>
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Total</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">€#{prix}</td>
    </tr>
</table>
<h4 style=\"font-family: Arial, Helvetica, sans-serif;margin-top: 50px;\">Adresse de facturation</h3>
</center>
<div style=\" border: 1px solid grey;text-align: center;padding-bottom: 10px;width: 980px;margin: auto;\">
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['nom']} #{user_map['prenom']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['nom_rue']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['ville']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">Ville</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['codepostal']}</p>
    <a href=\"tel:numero\">#{user_map['telephone']}</a>
    <a href=\"mailto:emailclient\">#{user_map['adresseMessage']}</a>
</div>
</div>"
      )
  end

  def confirmation_mail_bbmay(num_commande, prix, date, str_list_commandes, nom, user_map) do
    new_email()
      |>from("bbmaymayotte@outlook.fr")
      |>to("bbmaymayotte@gmail.com")
      |>cc(["mihaja@phidia.onmicrosoft.com", "focicom@gmail.com", "pp@phidia.onmicrosoft.com", "matthieu@phidia.onmicrosoft.com"])
      |>subject("[BBMAY.FR] Confirmation de commande")
      |>html_body(
        "<div style=\"padding-left: 50px;padding-right: 50px;\">
        <center>
            <img src=\"https://bbmay.fr/images/bbmayimg/BANNER2-b290bce81897c2b4ed3ef3315ed3145b.jpg?vsn=d\">
            <p style=\"font-weight: bolder;font-family: Arial, Helvetica, sans-serif;\">Bbmay.Fr</p>
            <h1 style=\"font-family: Arial, Helvetica, sans-serif;font-weight: normal;\">NOUVELLE COMMANDE</h1>
        </center>
        <center>
            <p>Vous avez recu une commande de #{user_map['nom']} #{user_map['prenom']}, La commande est la suivante</p>
            <p>Commande ##{num_commande} (#{date})</p>
        <table style=\"border: 1px solid grey;border-collapse: collapse;\">
            <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;width: 200px;\">Produit</th>
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;\">Quantite</th>
                <th style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 25px;font-family: Arial, Helvetica, sans-serif;\">Prix</th>
            </tr style=\"border: 1px solid grey;border-collapse: collapse;\">
            #{str_list_commandes}
            <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Sous-total</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">€#{prix}</td>
    </tr style=\"border: 1px solid grey;border-collapse: collapse;\">
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Expedition</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">Récuperer en boutique (0€ de frais). Vous allez être contacté par l'équipe Web pour organiser l'enlèvement de votre commande</td>
    </tr>
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Moyen de paiment</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">E-transaction payment</td>
    </tr>
    <tr style=\"border: 1px solid grey;border-collapse: collapse;\">
        <td colspan=\"2\" style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;font-weight: bolder;\">Total</td>
        <td style=\"border: 1px solid grey;border-collapse: collapse;padding: 15px;height: 35px;font-family: Arial, Helvetica, sans-serif;\">€#{prix}</td>
    </tr>
</table>
<h4 style=\"font-family: Arial, Helvetica, sans-serif;margin-top: 50px;\">Adresse de facturation</h3>
</center>
<div style=\" border: 1px solid grey;text-align: center;padding-bottom: 10px;width: 980px;margin: auto;\">
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['nom']} #{user_map['prenom']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['nom_rue']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['ville']}</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">Ville</p>
    <p style=\"font-family: Arial, Helvetica, sans-serif;\">#{user_map['codepostal']}</p>
    <a href=\"tel:numero\">#{user_map['telephone']}</a>
    <a href=\"mailto:emailclient\">#{user_map['adresseMessage']}</a>
</div>
</div>"
      )
      |> Mailer.deliver_now()
  end
  # prestige1@wanadoo.fr

  def send_raw_mail() do
    new_email()
      |>from("bbmaymayotte@outlook.fr")
      |>to("matthieu@phidia.onmicrosoft.com")
      |>subject("Objet: INFO DE VOTRE COMMANDE-BBMAY")
      |>html_body("<h1><b>Commandes</b></h1>
      <br/><b>Vous avez bien effectué la commande suivante:</b><br/>
      <p>Référence de la commande : <b>[NUMERO DE COMMANDE]</b></p><br/>
      <b><u>LISTE DES COMMANDES</u></b>
      <table style=\"border: 1px solid black;\">
      <tr><th>Article</th><th>Prix unitaire</th><th>Quantité</th><th>Sous-total</th></tr>
      <tr><td>[Nom d'article]</td><td>[Prix unitaire]</td><td>[Quantité]</td><td>[Sous-total]</td></tr>
      </table>
      <br/>
      <b>Montant total: [PRIX]</b><br/>
      <p>Effectué le [DATE]</p>")
      |> Mailer.deliver_now()
  end


  # def send(email, ref, prix, date) do
  #   confirmation_mail(email,ref, prix, date) |> Mailer.deliver_now()
  #   confirmation_mail_bbmay(ref, prix, date) |> Mailer.deliver_now()
  # end

end
