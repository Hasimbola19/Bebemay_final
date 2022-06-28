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

  def confirmation_mail(email, num_commande, prix, date, str_list_commandes) do
    new_email()
      |>from("bbmaymayotte@outlook.fr")
      |>to(email)
      |>subject("Objet: INFO DE VOTRE COMMANDE-BBMAY")
      |>html_body("<h1><b>Commandes</b></h1>
      <br/><b>Vous avez bien effectué la commande suivante:</b><br/>
      <p>Référence de la commande : <b>#{num_commande}</b></p><br/>
      <table>
      <th><td>Article</td><td>Prix unitaire</td><td>Quantité</td><td>Sous-total</td></th>
      #{str_list_commandes}
      </table>
      <br/>
      <b>Montant total: #{prix}</b><br/>
      <p>Effectué le #{date}</p>")
      |> Mailer.deliver_now()
  end

  def confirmation_mail_bbmay(num_commande, prix, date, str_list_commandes, nom) do
    new_email()
      |>from("bbmaymayotte@outlook.fr")
      |>to("bbmaymayotte@gmail.com")
      |>subject("Objet: COMMANDE PASSÉE PAR UN CLIENT-BBMAY")
      |>html_body("<h1><b>Commandes</b></h1>
      <p>Référence de la commande : <b>#{num_commande}</b></p><br/>
      <table>
      <th><td>Article</td><td>Prix unitaire</td><td>Quantité</td><td>Sous-total</td></th>
      #{str_list_commandes}
      </table>
      <br/>
      <b>Montant total: #{prix}</b><br/>
      <p>Effectué le #{date} par #{nom}</p>")
      |> Mailer.deliver_now()
  end

  # def send(email, ref, prix, date) do
  #   confirmation_mail(email,ref, prix, date) |> Mailer.deliver_now()
  #   confirmation_mail_bbmay(ref, prix, date) |> Mailer.deliver_now()
  # end

end
