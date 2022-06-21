defmodule BebemayotteWeb.Live.LocationLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette

  def mount(_params, %{"id_session" => session, "user" => user, "search" => search, "paniers" => paniers}, socket) do
    categories = CatRequette.get_all_categorie()
    {:ok,
      socket
        |>  assign(session: session, user: user, categories: categories, search: search, paniers: paniers),
        layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("location.html", assigns)
  end
end
