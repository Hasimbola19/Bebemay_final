defmodule Bebemayotte.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :id_item, :string
      add :Caption, :string
      add :FamilyId, :string
      add :SubFamilyId, :string
      add :CostPrice,:decimal, precision: 15, scale: 6, null: false

      timestamps()
    end

  end
end
