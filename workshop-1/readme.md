# Workshop 1 - FR - Introduction IaaS avec Azure
Déploiement d’une application sur une VM dans le cloud Azure via le portail web.

## Sommaire
1. Objectifs du TP
1. Accès au portail web Azure
1. Création de l’infrastructure
    1. Création du Groupe de Ressources
    1. Réseau virtuel et sous-réseau
    1. Groupe de sécurité
    1. IP Publique
1. Création de la machine virtuelle
1. Validation du déploiement
1. Nettoyage des ressources

## 1. Objectifs du TP
Mettre en place l’infrastructure nécessaire pour la création d’une machine virtuelle Azure.
Déployer une petite application web sur cette machine et l’exposer sur internet pour valider son fonctionnement.

## 2. Accès au portail web Azure
Toutes les manipulations de ce TP se font depuis le portail azure : https://portal.azure.com.

Utilisez le mail et mot de passe fourni en début de TP pour vous connecter : 

Il faudra initialiser un nouveau mot de passe à votre première connection.

> **Veillez à bien noter ce mot de passe pour la suite des TP !**




Une fois connecté, cochez la case pour rester connecter :


Vous arrivez ensuite sur le portail, refusez la visite :


Vous êtes maintenant connecté au portail :
Passez à la suite du TP.

## 3. Création de l’infrastructure
### 3.1. Création du Groupe de Ressources
Afin de regrouper les ressources azure de ce TP, nous allons créer un composant logique : le groupe de ressource.

Dans la barre latérale gauche, cliquez sur “Groupe de Ressources” :


Ensuite, cliquez sur  “Ajouter” dans la barre de menu de la fenêtre qui vient de s’ouvrir :

Dans la fenêtre “Créer un groupe de ressources”, remplir les champs :
“Abonnement” : laisser par défaut
“Groupe de ressource” : saisir “epsi-rg-tp1-” suivi de votre trigramme (exemple : “epsi-rg-tp1-bga” pour Baptiste Gauduchon)
“Région” : dans la liste déroulante, choisir “Europe du nord”

Cliquez ensuite sur “Vérifier et Créer” :

Enfin, cliquez sur “Créer” :

Une notification doit vous informer que votre groupe de ressource a bien été créé :

Vous pouvez rafraichir la page “Groupe de ressource” pour vérifier, en cliquant sur le bouton “Actualiser” du menu :

Votre groupe de ressource doit s’afficher :

Celui-ci devra regrouper toutes les ressources que vous allez créer dans la suite du TP.
### 3.2. Réseau virtuel privé et sous-réseau

Procédons maintenant à la création du réseau virtuel privé (vNET, équivalent à votre LAN privé sur le cloud Azure) et du sous-réseau qui accueillera la VM.

Dans la barre latérale gauche, cliquez sur “Réseaux virtuels” :

Dans la fenêtre “Réseaux Virtuels” qui vient de s’ouvrir, cliquez sur “Ajouter” dans la barre de menu :

Une fenêtre s’ouvre pour configurer votre réseau virtuel, remplir les champs :
“Nom” : saisir “epsi-vnet-tp1-” suivi de votre trigramme (ex : “epsi-vnet-tp1-bga”)
“Espace d’adressage” : saisir “10.0.0.0/16”
“Groupe de ressource” : dans la liste déroulante, choisir le groupe de ressource créé précédemment (“epsi-tp1-bga” dans notre exemple)
“Sous-réseau :
“Plage d’adresses” : saisir “10.0.0.0/24”
Laisser toutes les autres options par défaut.

Cliquez sur “Créer” pour lancer la création du réseau virtuel :

Une notification doit vous informer de la création du réseau virtuel :

Une fois la création terminée, cliquez sur “Actualiser” pour visualiser le nouveau réseau virtuel :

Votre réseau virtuel doit apparaître dans la liste :

### 3.3. Groupe de sécurité
Le groupe de sécurité fera office de pare-feu pour notre machine virtuelle et nous permet de configurer les services à exposer sur internet.

Dans le menu latéral, cliquez sur “Tous les services”:

Dans le nouvelle fenêtre qui s’ouvre, cliquez ensuite sur “Mise en réseau” dans le menu vertical :

Dans la liste de services qui s’affiche, cliquez sur “Groupe de sécurité réseau” :

Ajoutez un nouveau groupe de sécurité en cliquant sur “Ajouter” :


Dans la  fenêtre qui s’ouvre, configurez le groupe de sécurité :
“Nom” : saisir “epsi-nsg-tp1-” suivi de votre trigramme (ex : “epsi-nsg-tp1-bga”)
“Groupe de ressource” : choisir celui créé précédemment dans la liste déroulante
laisser les autres options par défaut.

De la même manière que les services précédents :
Cliquer sur “Créer” pour lancer la création du groupe de Sécurité
Une fois la notification confirmant la création du groupe reçue, vérifier que c’est le cas en rafraîchissant la liste comme précédemment.

Nous allons maintenant ajouter une règle pour autoriser le traffic entrant. Cliquez sur votre groupe de sécurité :

Cliquez ensuite sur “Régles de sécurité trafic entrant” :

Cliquez sur “Ajouter” dans le menu de la nouvelle fenêtre :

Configurer la règle de la manière suivante :
“Plage de ports de destination” : saisir 80
“Nom” : saisir “allow_port_80”
laisser le reste par défaut


Comme les étapes précédentes, valider en cliquant sur “Ajouter”.
Une fois la notification confirmant la création de la règle reçue, vous devez la voir apparaître dans la liste :

### 3.4. IP Publique
Pour pouvoir accéder à notre machine depuis internet, nous avons besoins de créer une IP publique.

Dans le menu latéral, cliquer sur “Tous les services”, puis sur “Mise en réseau”, puis sur “Adresse IP public” :

Comme précédemment, cliquer sur “Ajouter” dans le menu de la nouvelle fenêtre, et configurer l’IP publique :
“Nom” : saisir “epsi-pip-” suivi de votre trigramme (ex : “epsi-pip-bga”)
“Etiquette nom DNS” : saisir “epsi-” suivi de votre trigramme (ex : “epsi-bga”)
“Groupe de ressource” : sélectionner celui créé précédemment dans la liste déroulante
laisser le reste par défaut

Cliquez sur “Créer”. Une fois la notification de validation de création reçue, cliquez sur “Actualiser” et vérifiez que l’ip publique apparaît bien dans la liste.

Vous avez terminé les fondations de votre infrastructure, bien joué !
## 4. Création de la machine virtuelle
Vous avez créé tous les éléments d’infrastructure nécessaires pour déployer votre VM, nous pouvons donc procéder à la création de celle-ci pour héberger notre application.

Dans le menu latérale, cliquez sur “Machine Virtuelle” puis sur “Ajouter” :

Dans la fenêtre qui s’ouvre, remplir la configuration de base de la VM :
Vérifiez que votre groupe de ressource est bon dans “Groupe de ressource”
“Nom de la machine virtuelle” : saisir “epsi-vm-tp1-” suivi de votre trigramme (ex : “epsi-vm-tp1-bga”)
“Taille” : 
Cliquez sur “changer de taille”
dans le fenêtre qui s’ouvre, cliquez sur “A0, standard, Usage général” puis valider en cliquant sur “Sélectionner”

 “Compte administrateur” :
“Type d’authentification” : cocher “Mot de passe”
“Nom d’utilisateur” : saisir votre trigramme suivi de “-admin” (ex : “bga-admin”)
“Mot de passe” : saisir ‘Epsi-tp1-” suivi de votre trigramme (ex : “Epsi-tp1-bga”, le mot de passe ne sera pas utilisé dans ce TP)
Laisser tous les autres réglages par défaut


Cliquez ensuite sur “Suivant - Disques” :


Laisser les options par défaut et cliquez sur “Suivant - Mise en réseau” :

Configurez les paramètres réseau de machine virtuelle :
Vérifier que le réseau virtuel, le sous-réseau et l’IP publique correspondent à ceux créés précédemment
“Adresse IP publique” : sélectionner celle créée précédemment.
>> Attention à ne pas en créer une nouvelle ! <<
“Groupe de sécurité réseau de la carte réseau” : cochez “paramètres avancés”
“Configurer le groupe de sécurité réseau” : choisir celui créé précédemment dans la liste déroulante
>> Attention à ne pas en créer un nouveau ! <<
laisser le reste des options par défaut

Cliquez sur “Suivant - Administration”, puis décocher “Diagnostics de démarrage” dans les options de supervision :

Cliquez sur “Suivant - configuration de l’invité”, puis configurer les options :
“Cloud init” : 
remarque : ce script va automatiquement installer au démarrage de la machine une application node.js et un serveur web qui écoutera sur le port 80.
récupérez le script sur le dépôt github du TP : https://raw.githubusercontent.com/bgauduch/azure-iac-workshop/master/TP1/vm-cloud-init.yaml 
Copiez ce script, et collez-le dans le champ “cloud init”
Laisser le reste par défaut


Cliquez ensuite sur “valider + créer”, profitez de la page récapitulative pour vérifier votre configuration, puis cliquez sur “Créer” :


La création de la machine virtuelle peut prendre quelques minutes.
Une fois la notification de validation du déploiement reçue, passer à la suite. 

## 5. Validation du déploiement
Notre application est maintenant déployé, nous allons vérifier que nous y avons accès et qu’elle fonctionne en naviguant sur le nom de domain de notre IP publique.

Votre application est normalement accessible à l’URL suivante :
http://epsi-TRIGRAMME.northeurope.cloudapp.azure.com/ (remplacer TRIGRAMME par votre trigramme)

Si vous obtenez la page suivante, félicitation, vous avez réussi !



Remarque : l’application étant déployée une fois la machine démarrée, son installation peut prendre un peu de temps : ne soyez pas étonné de devoir attendre quelques minutes avant que la page web fonctionne !

## 6. Nettoyage des ressources
Une fois que l’application est déployée avec succès et que son fonctionnement est vérifié, nous pouvons détruire les ressources.

Se rendre sur la liste des groupes de ressources :

Cliquez ensuite sur votre groupe de ressource :

Cliquez sur le bouton “Supprimer le groupe de ressource” :

Vous devez confirmer la demande de suppression en saisissant le nom du groupe (suppression de toutes les ressources du groupe), puis valider en cliquant sur “Supprimer”

Il suffit alors d’attendre, toutes les ressources du groupe seront supprimées !

Bravo, vous avez terminé le TP :-)
