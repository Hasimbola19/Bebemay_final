 defmodule Bebemayotte.Client do
  alias Bebemayotte.UserRequette

  def exec(id, nom, nom_rue, codepostal, ville, prenom, telephone, adresseMessage) do
    {:ok, chemin} = File.cwd
    {:ok, file} = File.open("#{chemin}/current-clientv2.csv", [:append])
      client = %{
        "Code (tiers)" => id,
        "Nom" => nom,
        "Adresse 1 (facturation)" => nom_rue,
        "Adresse 2 (facturation)" => "",
        "Code postal (facturation)" => codepostal,
        "Ville (facturation)" => ville,
        "Code Pays (facturation)" => "YT",
        "Nom (contact) (facturation)" => nom,
        "Prénom (facturation)" => prenom,
        "Téléphone portable (facturation)" => telephone,
        "E-mail (facturation)" => adresseMessage,
        "Adresse 1 (livraison)" => nom_rue,
        "Adresse 2 (livraison)" => "",
        "Code postal (livraison)" => codepostal,
        "Ville (livraison)" => ville,
        "Code Pays (livraison)" => "YT",
        "Nom (contact) (livraison)" => nom,
        "Prénom (livraison)" => prenom,
        "Téléphone portable (livraison)" => telephone,
        "E-mail (livraison)" => adresseMessage,
        "IdWeb" => id
      }

      adresse_1_facturation = if client["Adresse 1 (facturation)"] != "" do
        "\"" <> client["Adresse 1 (facturation)"] <> "\""
      else
        client["Adresse 1 (facturation)"]
      end

      adresse_2_facturation = if client["Adresse 2 (facturation)"] != "" do
      "\"" <> client["Adresse 2 (facturation)"] <> "\""
      else
        client["Adresse 2 (facturation)"]
      end

      client_list = [
        client["Code (tiers)"],
        client["Nom"],
        adresse_1_facturation,
        adresse_2_facturation,
        client["Code postal (facturation)"],
        client["Ville (facturation)"],
        client["Code Pays (facturation)"],
        client["Nom (contact) (facturation)"],
        client["Prénom (facturation)"],
        client["Téléphone portable (facturation)"],
        client["E-mail (facturation)"],
        client["Adresse 1 (livraison)"],
        client["Adresse 2 (livraison)"],
        client["Code postal (livraison)"],
        client["Ville (livraison)"],
        client["Code Pays (livraison)"],
        client["Nom (contact) (livraison)"],
        client["Prénom (livraison)"],
        client["Téléphone portable (livraison)"],
        client["E-mail (livraison)"],
        client["IdWeb"]
      ]

      client_joined = Enum.join(client_list, ";")
      IO.binwrite(file, "#{client_joined}\n")
      File.close file
  end
end
