defmodule Bebemayotte.PanierRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Panier
  alias Bebemayotte.Repo

  # INSERT IN TABLE PANIER
  def insert_panier(params) do
    %Panier{}
      |>Panier.changeset(params)
      |>Repo.insert()
  end

  # GET PANIER
  def get_all_panier() do
    case is_nil(Repo.all(Panier)) do
      true -> nil
      false -> Repo.all(panier)
    end
  end

  # GET ID PRODUIT IN PANIER
  def get_id_produit_in_panier() do
    query =
      from pa in Panier,
        select: pa.id_produit
    Repo.all(query)
  end
end
