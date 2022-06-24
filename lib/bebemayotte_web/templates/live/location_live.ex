defmodule BebemayotteWeb.Live.LocationLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette

  def mount(_params, %{"id_session" => session, "user" => user, "search" => search, "list_panier" => list_panier}, socket) do
    categories = CatRequette.get_all_categorie()
    souscategories = SouscatRequette.get_all_souscategorie
    {:ok,
      socket
        |>  assign(session: session, user: user, categories: categories, souscategories: souscategories, search: search, list_panier: list_panier),
        layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("location.html", assigns)
  end
end
