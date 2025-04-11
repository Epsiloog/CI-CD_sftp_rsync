#!/bin/bash
# Script de mise en prod de la branche preprod
# Il faut être sur la branche preprod pour l'exécuter

echo "NE PAS OUBLIER DE COMMIT SES MODIFICATIONS AVANT DE LANCER CE SCRIPT (ET DE LES INTEGRER AVEC LES MODIFICATIONS ENTRANTES -> cf git pull suivant)"
echo 
git pull

echo "Ajout de la date et du nombre de lignes de code dans le fichier site/infos_site.html"
echo "PENSER À L'ÉLAGUER AU BESOIN"
HTML=$(find site -name '*.html' | xargs wc -l | tail -n 1 | awk '{print $1}')
CSS=$(find site -name '*.css' | xargs wc -l | tail -n 1 | awk '{print $1}')
PHP=$(find site -name '*.php' | xargs wc -l | tail -n 1 | awk '{print $1}')
JS=$(find site -name '*.js' | xargs wc -l | tail -n 1 | awk '{print $1}')
total=$(($HTML + $CSS + $PHP + $JS))
current_date_time=$(date +"%Y-%m-%d_%Hh%M")
echo "
    <tr>
    <td></td>
    <td><b>${current_date_time}</b></td>
    <td>${HTML}</td>
    <td>${CSS}</td>
    <td>${PHP}</td>
    <td>${JS}</td>
    <td><b>${total}</b></td>
    <tr>" >> site/infos_site.html

echo "Début synchro avec le serveur de prod"
echo "--- Les fichiers connexion.php et .htaccess sont exlus pour éviter des problèmes avec le serveur ---"
echo 
read -p "Enter user: " user
echo $user
host = ""
lftp -e "set sftp:connect-program 'ssh -a -o StrictHostKeyChecking=no'; mirror -R --verbose --ignore-time --only-newer --delete --exclude 'connexion.php' --exclude '.htaccess' dossier_local/ dossier_distant/; quit" sftp://$user@$hote
unset user
unset host
echo "NE SURTOUT PAS REMPLACER LE FICHIER connexion.php sur le serveur de prod par le fichier de TEST du CODESPACE !!!"

echo "Début du commit, tag et push de la mise à jour officielle du repo Github EN ACCORD/SYNCRO AVEC LE SERVEUR DE PROD"

git add site/infos_site.html
git commit -m "Mise à jour des infos du site avec le nombre de lignes de code HTML, CSS, PHP et JS"

git tag -a $current_date_time -m "Mise en prod de la branche preprod :)"
git push --follow-tags

echo "NE SURTOUT PAS REMPLACER LE FICHIER connexion.php sur le serveur de prod par le fichier de TEST du CODESPACE !!!"
echo "SCRIPT TERMINE !"
