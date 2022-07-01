defmodule Bebemayotte.SouscatRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategorie
  alias Bebemayotte.Categorie
  alias Bebemayotte.CatRequette

  # GET SOUSCATEGORIE
  def get_all_souscategorie() do
    query = from sc in Souscategorie,
      order_by: [asc: sc.nom_souscat],
      select: sc
    Repo.all(query)
  end

  # GET SOUSCATEGORIE BY NOM SOUSCAT
  def get_id_souscat_by_nom_souscat(nom_souscat, nom_cat) do
    # quer =
    # id = Repo.one(quer)
    query =
      from s in Souscategorie,
        where: s.nom_souscat == ^nom_souscat and s.id_cat == ^(Repo.one(
          from c in Categorie,
          where: c.nom_cat == ^nom_cat,
          select: c.id_cat
        )),
        select: s.id_souscat
    Repo.one(query)
  end

  # GET SOUSCATEGORIE BY ID CAT
  def get_souscategorie_by_id_souscat(id_souscat) do
    case id_souscat do
      nil -> "indéfini"
      id_souscat ->
        query =
          from sc in Souscategorie,
            where: sc.id_souscat == ^id_souscat,
            select: sc.nom_souscat
        Repo.one(query)
    end
  end

  def get_count_scat_by_id_cat(nom_cat) do
    quer = CatRequette.get_id_cat_by_nom_cat(nom_cat)
    query =
      from sc in Souscategorie,
      where: sc.id_cat == ^quer,
      select: count(sc.id_souscat)
    Repo.one(query)
  end
end
