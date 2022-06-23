defmodule Bebemayotte.Email do
  use Bamboo.Phoenix, view: BebemayotteView
  alias Bebemayotte.Mailer
  # CREATE NEW MAIL MESSAGE
  def new_mail_message(email, message) do
    new_email()
    |>from("bbmayotte@outlook.fr")
    |>to(email)
    |>subject("Objet: VERIFICATION MAIL")
    |>text_body(message)
  end

  @spec send :: Bamboo.Email.t()
  def send do
    new_mail_message("bbmayotte@outlook.fr", "Nasolo a, tonga ve le mail") |> Mailer.deliver_now()
  end

end
