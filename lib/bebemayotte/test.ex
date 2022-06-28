defmodule Bebemayotte.Test do
  def exec(date, id, nom, adresse1, prenom, codep, ville, tel, email, paniers, quantites, prix, num_commande) do
    commande = %{
      "Document - Numéro du document" => num_commande,
      "Document - Date" => date,
      "Document - Code client" => id,
      "Document - Nom du client" => nom,
      "Document - Adresse 1 (facturation)" => adresse1,
      "Document - Adresse 2 (facturation)" => "",
      "Document - Nom (contact) (facturation)" => nom,
      "Document - Prénom (facturation)" => prenom,
      "Document - Code postal (facturation)" => codep,
      "Document - Ville (facturation)" => ville,
      "Document - Code Pays (facturation)" => "YT",
      "Document - Téléphone portable (facturation)" => tel,
      "Document - E-mail (facturation)" => email,
      "Document - Adresse 1 (livraison)" => adresse1,
      "Document - Adresse 2 (livraison)" => "",
      "Document - Nom (contact) (livraison)" => nom,
      "Document - Code postal (livraison)" => codep,
      "Document - Prénom (livraison)" => prenom,
      "Document - Ville (livraison)" => ville,
      "Document - Code Pays (livraison)" => "YT",
      "Document - Téléphone portable (livraison)" => tel,
      "Document - E-mail (livraison)" => email,
      "Ligne - Code article" => paniers, #id_produit
      "Ligne - Quantité" => quantites, #quantie
      "Ligne - PV TTC" => prix, #prix_unitaire
      "Ligne - Poids Net" => "0.0",
      "Document - IdCdeWeb*" => num_commande, #num_commande
      "Document - Frais de port HT" => "0.00"
    }

    date = if commande["Document - Date"] != "" do
      # "\"" <> commande["Document - Date"] <> "\""
      ~s("#{commande["Document - Date"]}")
    else
      commande["Document - Date"]
    end

    IO.puts "#{date} CEST LA DATE"

    adresse_1_facturation = if commande["Document - Adresse 1 (facturation)"] != "" do
      "\"" <> commande["Document - Adresse 1 (facturation)"] <> "\""
    else
      commande["Document - Adresse 1 (facturation)"]
    end

    adresse_2_facturation = if commande["Document - Adresse 2 (facturation)"] != "" do
     "\"" <> commande["Document - Adresse 2 (facturation)"] <> "\""
    else
      commande["Document - Adresse 2 (facturation)"]
    end

    adresse_1_livraison = if commande["Document - Adresse 1 (livraison)"] != "" do
      "\"" <> commande["Document - Adresse 1 (livraison)"] <> "\""
    else
      commande["Document - Adresse 1 (livraison)"]
    end

    adresse_2_livraison = if commande["Document - Adresse 2 (livraison)"] != "" do
      "\"" <> commande["Document - Adresse 2 (livraison)"] <> "\""
    else
      commande["Document - Adresse 2 (livraison)"]
    end




    IO.inspect commande
    # commandes_vals = Enum.map(commande, fn {k, v} -> v end)

    commande_as_list = [
      commande["Document - Numéro du document"],
      # commande["Document - Date"],
      date,
      commande["Document - Code client"],
      commande["Document - Nom du client"],
      # commande["Document - Adresse 1 (facturation)"],
      adresse_1_facturation,
      # commande["Document - Adresse 2 (facturation)"],
      adresse_2_facturation,
      commande["Document - Nom (contact) (facturation)"],
      commande["Document - Prénom (facturation)"],
      commande["Document - Code postal (facturation)"],
      commande["Document - Ville (facturation)"],
      commande["Document - Code Pays (facturation)"],
      commande["Document - Téléphone portable (facturation)"],
      commande["Document - E-mail (facturation)"],
      # commande["Document - Adresse 1 (livraison)"],
      adresse_1_livraison,
      # commande["Document - Adresse 2 (livraison)"],
      adresse_2_livraison,
      commande["Document - Nom (contact) (livraison)"],
      commande["Document - Code postal (livraison)"],
      commande["Document - Prénom (livraison)"],
      commande["Document - Ville (livraison)"],
      commande["Document - Code Pays (livraison)"],
      commande["Document - Téléphone portable (livraison)"],
      commande["Document - E-mail (livraison)"],
      commande["Ligne - Code article"],
      commande["Ligne - Quantité"],
      commande["Ligne - PV TTC"],
      commande["Ligne - Poids Net"],
      commande["Document - IdCdeWeb*"],
      commande["Document - Frais de port HT"]
   ]

   IO.inspect commande_as_list
   commande_joined = Enum.join(commande_as_list, ";")

    #Donnée de test
    # 31656960;"2022-02-23 11:31:35";191;Hadia;"178 rue Baobab";;Hadia;Djoumoi;97660;DEMBÉNI;YT;0617790907;hadiadjoumoi@yahoo.fr;"178 rue Baobab";;Hadia;97660;Djoumoi;DEMBÉNI;YT;0617790907;hadiadjoumoi@yahoo.fr;630131;1;72.00;0.0;31656960;0.00

    # {:ok, file} = File.open("facturation.csv", [:append])
    # IO.binwrite(file, "#{commande_joined}\n")
    # File.close file

    {:ok, chemin} = File.cwd
    {:ok, file} = File.open("#{chemin}/facturation.csv", [:append])
    IO.binwrite(file, "#{commande_joined}\n")
    File.close file

  end
  def open do
    {:ok, file} = File.open(Path.expand("assets/static/images/uploads/facturation.csv"), [:append])
    # IO.binwrite(file, "#{commande_joined}\n")
    File.close file
  end
end
