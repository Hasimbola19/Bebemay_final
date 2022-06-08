defmodule BebemayotteWeb.Live.DetailProduitLive do
  use Phoenix.LiveView
  alias Bebemayotte.CatRequette
  alias Bebemayotte.SouscatRequette
  alias Bebemayotte.ProdRequette
  alias Bebemayotte.PanierRequette

  def mount(_params, %{"id_session" => id_session, "id_produit" => id_produit, "user" => user, "paniers" => list_panier, "quantites" => list_quantite}, socket) do
    categories = CatRequette.get_all_categorie()
    produit = ProdRequette.get_produit_by_id_produit(id_produit)
    souscategories = SouscatRequette.get_all_souscategorie()
    stock = produit.stockmax
    quantite = stock |> Decimal.to_integer() |> quantite_initial(list_panier,list_quantite, id_produit)
    categorie_prod = CatRequette.get_categorie_by_id_cat(produit.id_cat)
    souscategorie_prod = SouscatRequette.get_souscategorie_by_id_souscat(produit.id_souscat)
    produits_apparentes = ProdRequette.get_produit_apparentes(produit.id_souscat, id_produit)
    {
      :ok,
        socket |> assign(categories: categories, search: nil, id_session: id_session,
                         produit: produit, categorie_prod: categorie_prod,
                         souscategorie_prod: souscategorie_prod,souscategories: souscategories, apparentes: produits_apparentes,
                         quantite: quantite,user: user),
        layout: {BebemayotteWeb.LayoutView, "layout_live.html"}
    }
  end

  def handle_event("add_panier", params, socket) do
    id = params["id_produit"]
    # quantite = params["quantite"]
    session = socket.assigns.id_session
    panier = id |> PanierRequette.find_double_in_panier(session)
    # last_row = PanierRequette.get_panier_last_row_id()
    # id_user = session #|> String.to_integer()
    # param = %{
    #   "id_panier" => last_row,
    #   "id_produit" => id,
    #   "quantite" => 1,
    #   "id_user" => id_user
    # }
    # para = %{
    #   "id_panier" => last_row,
    #   "id_produit" => id,
    #   "quantite" => quantite,
    #   "id_user" => id_user
    # }
    if panier == nil do
      # param |> PanierRequette.insert_panier()
      message = "#{ProdRequette.get_nom_produit_by_id(id)} est parfaitement ajouté au panier."
      {:noreply, socket |> put_flash(:info, message)}
    else
      # id |> PanierRequette.get_panier_by_id_produit_id_session(session) |> PanierRequette.update_panier_query(para)
      message = "#{ProdRequette.get_nom_produit_by_id(id)} est déja dans le panier!!!"
      {:noreply, socket |> put_flash(:info, message)}
    end
  end

  def handle_event("put", _, socket) do
    {:noreply, socket |> put_flash(:info, "Put flash fonctionne tres bien")}
  end

  def render(assigns) do
    BebemayotteWeb.PageView.render("detail_produit.html", assigns)
  end

  defp quantite_initial(stockmax, list_panier, list_quantite, id_produit) do
    if list_panier == nil do
      if stockmax > 0, do: 1, else: 0
    else
      index = Enum.find_index(list_panier,fn x -> x == id_produit end)
      if index == nil do
        if stockmax > 0, do: 1, else: 0
      else
        Enum.fetch!(list_quantite, index)
      end
    end
  end

  defp minus(x) do
    if x > 1, do: x - 1, else: 1
  end

  defp maxus(x, max) do
    if x < max, do: x + 1, else: max
  end
end
