defmodule Bebemayotte.Repo.Migrations.RmChampPhotoUrl do
  use Ecto.Migration

  def change do
    alter table(:produits) do
      remove :photo_url, :string
    end
  end
end
