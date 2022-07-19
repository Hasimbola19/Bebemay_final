defmodule Bebemayotte.SouscategorieRequette do
  import Ecto.Query, warn: false
  alias Bebemayotte.Repo
  alias Bebemayotte.Souscategories

  def get_all_souscategories() do
    query = from sc in Souscategories,
      order_by: [asc: sc.nom_souscat],
      select: sc
    Repo.all(query)
  end
end
