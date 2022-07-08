defmodule  BebemayotteWeb.Live.ContactLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.Mailer
  alias Bebemayotte.Email
  alias Bebemayotte.UserRequette

  def mount(_params, %{"user" => id, "list_panier" => list_panier}, socket) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie()
    {:ok, socket
      |> assign(categories: categories,
      souscategories: souscategories,
      search: nil, user: id, list_panier: list_panier),
    layout: {BebemayotteWeb.LayoutView, "layout_live.html"}}
  end

  def handle_event("add", _params, socket) do
    panier_actuel = socket.assigns.panier
    panier_ajoute = panier_actuel + 1
    {:noreply, socket |> assign(panier: panier_ajoute)}
  end

  def handle_event("send", params, socket) do
    message = params["textarea"]
    id = socket.assigns.user
    if is_nil(id) do
      email = params["email"]
      if String.contains?(message, "http") do
        {:noreply,
        socket
          |> put_flash(:error, "Le mail n'a pas été envoyé")
        }
      else
        Email.mail_contact_message(email, message) |> Mailer.deliver_now()
        {:noreply, socket
          |> put_flash(:info, "Le mail a été envoyé")
        }
      end
    else
      email = UserRequette.get_user_email_by_id(id)
      if String.contains?(message, "http") do
        {:noreply,
        socket
          |> put_flash(:error, "Le mail n'a pas été envoyé")
        }
      else
        Email.mail_contact_message(email, message) |> Mailer.deliver_now()
        {:noreply, socket
          |> put_flash(:info, "Le mail a été envoyé")
        }
      end
    end
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("contact.html", assigns)
  end
end
