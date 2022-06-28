defmodule Bebemayotte.Reglement do
  def exec(id, date, montant, num_doc) do
    {:ok, chemin} = File.cwd
    {:ok, file} = File.open("#{chemin}/importReglements.csv", [:append])
    reglements = %{
      "Code (tiers)" => id,
      "Date" => date,
      "Code moyen de paiment" => "CB",
      "Montant" => montant,
      "Numéro de document" => num_doc
    }

    date = if reglements["Date"] != "" do
      # "\"" <> commande["Document - Date"] <> "\""
      ~s("#{reglements["Date"]}")
    else
      reglements["Date"]
    end

    reglements_list = [
      reglements["Code (tiers)"],
      date,
      reglements["Code moyen de paiment"],
      reglements["Montant"],
      reglements["Numéro de document"]
    ]

    reglement_file = Enum.join(reglements_list, ";")
    IO.binwrite(file, "#{reglement_file}\n")
    File.close(file)
  end
end
