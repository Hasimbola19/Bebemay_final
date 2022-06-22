defmodule  BebemayotteWeb.Live.ContactLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette

  def mount(_params, %{"user" => id, "list_panier" => list_panier}, socket) do
    categories = CatRequette.get_all_categorie()

    {:ok, socket |> assign(categories: categories, search: nil, user: id, list_panier: list_panier), layout: {BebemayotteWeb.LayoutView, "layout_live.html"}}
  end

  def handle_event("add", _params, socket) do
    panier_actuel = socket.assigns.panier
    panier_ajoute = panier_actuel + 1
    {:noreply, socket |> assign(panier: panier_ajoute)}
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("contact.html", assigns)
  end
end
