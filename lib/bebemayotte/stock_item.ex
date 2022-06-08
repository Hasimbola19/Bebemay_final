defmodule Bebemayotte.StockItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stockitem" do
    field :item_id, :string
    field :real_stock, :decimal

    timestamps()
  end

  @doc false
  def changeset(stockitem, attrs) do
    stockitem
    |> cast(attrs, [:real_stock, :item_id])
    |> validate_required([:real_stock, :item_id])
  end
end
