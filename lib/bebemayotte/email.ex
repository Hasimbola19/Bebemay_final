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

  def send do
    new_mail_message("rakotosonhasina00@gmail.com", "Nasolo a, tonga ve le mail") |> Mailer.deliver_now()
  end

end
