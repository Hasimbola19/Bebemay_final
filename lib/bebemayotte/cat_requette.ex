defmodule Bebemayotte.CatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Categorie
  alias Bebemayotte.Repo

  # GET CATEGORIE
  def get_all_categorie() do
    query = (from c in Categorie,
      order_by: [asc: c.nom_cat],
      select: c)
    Repo.all(query)
  end

  # GET ID CATEGORIE BY NOM CAT
  def get_id_cat_by_nom_cat(nom_cat) do
    query =
      from c in Categorie,
        where: c.nom_cat == ^nom_cat,
        select: c.id_cat
    Repo.all(query)
  end

  # GET CATEGORIE BY ID CAT
  def get_categorie_by_id_cat(id_cat) do
    query =
      from c in Categorie,
        where: c.id_cat == ^id_cat,
        select: c.nom_cat
    Repo.one(query)
  end
end
