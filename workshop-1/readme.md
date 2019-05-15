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

![Portail web Azure - connexion, saisie du mail](/workshop-1/resources/login/az_login.jpg)
![Portail web Azure - connexion, saisie du mot de passe](/workshop-1/resources/login/az_password_prompt.jpg)

Il faudra initialiser un nouveau mot de passe à votre première connection.
> **Veillez à bien noter ce mot de passe pour la suite des TP !**

![Portail web Azure - connexion, reinitialisation du mot de passe](/workshop-1/resources/login/az_password_update.jpg)

Une fois connecté, cochez la case pour rester connecter :

![Portail web Azure - connexion, rester connecté](/workshop-1/resources/login/az_stay_connected.jpg)

Vous arrivez ensuite sur le portail, refusez la visite :

![Portail web Azure - popup bienvenue, refuser la visite guidée](/workshop-1/resources/login/az_welcome_popup.jpg)

Vous êtes maintenant connecté au portail :

![Portail web Azure - page d'accueil du portail web](/workshop-1/resources/login/az_portal.jpg)

Passez à la suite du TP.

## 3. Création de l’infrastructure

### 3.1. Création du Groupe de Ressources
Afin de regrouper les ressources azure de ce TP, nous allons créer un composant logique : le groupe de ressource.

Dans la barre latérale gauche, cliquez sur `Groupe de Ressources` :

![Portail web Azure - groupe de resource](/workshop-1/resources/rg/01_az_rg.jpg)

Ensuite, cliquez sur  `Ajouter` dans la barre de menu de la fenêtre qui vient de s’ouvrir :

![Portail web Azure - ajouter un groupe de resource](/workshop-1/resources/rg/02_az_rg_add.jpg)

Dans la fenêtre `Créer un groupe de ressources`, remplir les champs :
* `Abonnement` : laisser par défaut
* `Groupe de ressource` : saisir `workshop-1-rg-` suivi de votre trigramme (exemple : `workshop-1-rg-bga` pour Baptiste Gauduchon)
* `Région` : dans la liste déroulante, choisir `Europe du nord`

![Portail web Azure - paramètrage du groupe de resource](/workshop-1/resources/rg/03_az_rg_config.jpg)

Cliquez ensuite sur `Vérifier et Créer` :

![Portail web Azure - vérification paramètres du groupe de resource](/workshop-1/resources/rg/04_az_rg_validate.jpg)

Enfin, cliquez sur `Créer` :

![Portail web Azure - création du groupe de resource](/workshop-1/resources/rg/05_az_rg_create.jpg)

Une notification doit vous informer que votre groupe de ressource a bien été créé :

![Portail web Azure - notification création groupe de resource](/workshop-1/resources/rg/06_az_rg_create_notification.jpg)

Vous pouvez rafraichir la page `Groupe de ressource` pour vérifier, en cliquant sur le bouton `Actualiser` du menu :

![Portail web Azure - rafraichir la liste des groupes de resource](/workshop-1/resources/rg/07_az_rg_list_refresh.jpg)

Votre groupe de ressource doit s’afficher :

![Portail web Azure - affichage lsite des groupes de resource](/workshop-1/resources/rg/08_az_rg_list_refreshed.jpg)

Celui-ci devra regrouper toutes les ressources que vous allez créer dans la suite du TP.

### 3.2. Réseau virtuel privé et sous-réseau

Procédons maintenant à la création du réseau virtuel privé (vNET, équivalent à votre LAN privé sur le cloud Azure) et du sous-réseau qui accueillera la VM.

Dans la barre latérale gauche, cliquez sur `Réseaux virtuels` :

![Portail web Azure - sélection du service réseaux virtuels](/workshop-1/resources/vnet/1_az_services_vnet.jpg)

Dans la fenêtre `Réseaux Virtuels` qui vient de s’ouvrir, cliquez sur `Ajouter` dans la barre de menu :

![Portail web Azure - ajouter un réseau virtuel](/workshop-1/resources/vnet/2_az_vnet_list_add.jpg)

Une fenêtre s’ouvre pour configurer votre réseau virtuel, remplir les champs :
* `Nom` : saisir `workshop-1-vnet-` suivi de votre trigramme (ex : `workshop-1-vnet-bga`)
* `Espace d’adressage` : saisir `10.0.0.0/16`
* `Groupe de ressource` : dans la liste déroulante, choisir le groupe de ressource créé précédemment (`workshop-1-bga` dans notre exemple)
* `Sous-réseau` :
* `Plage d’adresses` : saisir `10.0.0.0/24`

Laisser toutes les autres options par défaut.

![Portail web Azure - paramétrage du réseau virtuel](/workshop-1/resources/vnet/3_az_vnet_config.jpg)

Cliquez sur `Créer` pour lancer la création du réseau virtuel :

![Portail web Azure - création du réseau virtuel](/workshop-1/resources/vnet/4_az_vnet_create.jpg)

Une notification doit vous informer de la création du réseau virtuel :

![Portail web Azure - notification de création du réseau virtuel](/workshop-1/resources/vnet/5_az_vnet_create_notification.jpg)

Une fois la création terminée, cliquez sur `Actualiser` pour visualiser le nouveau réseau virtuel :

![Portail web Azure - création du réseau virtuel](/workshop-1/resources/vnet/6_az_vnet_list_refresh.jpg)

Votre réseau virtuel doit apparaître dans la liste :

![Portail web Azure - création du réseau virtuel](/workshop-1/resources/vnet/7_az_vnet_list_Refreshed.jpg)

### 3.3. Groupe de sécurité
Le groupe de sécurité fera office de pare-feu pour notre machine virtuelle et nous permet de configurer les services à exposer sur internet.

Dans le menu latéral, cliquez sur `Tous les services`:

![Portail web Azure - tous les services](/workshop-1/resources/nsg/01_az_services.jpg)

Dans le nouvelle fenêtre qui s’ouvre, cliquez ensuite sur `Mise en réseau` dans le menu vertical :

![Portail web Azure - services de mise en réseau](/workshop-1/resources/nsg/02_az_services_network.jpg)

Dans la liste de services qui s’affiche, cliquez sur `Groupe de sécurité réseau` :

![Portail web Azure - service groupe de sécurité](/workshop-1/resources/nsg/03_az_services_network_nsg.jpg)

Ajoutez un nouveau groupe de sécurité en cliquant sur `Ajouter` :

![Portail web Azure - ajout d'un groupe de sécurité](/workshop-1/resources/nsg/04_az_nsg_add.jpg)

Dans la  fenêtre qui s’ouvre, configurez le groupe de sécurité :
* `Nom` : saisir `workshop-1-nsg-` suivi de votre trigramme (ex : `workshop-1-nsg-bga`)
* `Groupe de ressource` : choisir celui créé précédemment dans la liste déroulante

Laisser les autres options par défaut.

![Portail web Azure - configuration du groupe de sécurité](/workshop-1/resources/nsg/05_az_nsg_config.jpg)

De la même manière que les services précédents :
* Cliquez sur `Créer` pour lancer la création du groupe de Sécurité
* Une fois la notification confirmant la création du groupe reçue, vérifier que c’est le cas en rafraîchissant la liste comme précédemment.

Nous allons maintenant ajouter une règle pour autoriser le traffic entrant. Cliquez sur votre groupe de sécurité :

![Portail web Azure - liste des groupes de sécurité](/workshop-1/resources/nsg/06_az_nsg_list_created.jpg)

Cliquez ensuite sur `Régles de sécurité trafic entrant` :

![Portail web Azure - régles entrantes du groupe de sécurité](/workshop-1/resources/nsg/07_az_nsg_rules.jpg)

Cliquez sur `Ajouter` dans le menu de la nouvelle fenêtre :

![Portail web Azure - ajouter une règle entrante au groupe de sécurité](/workshop-1/resources/nsg/08_az_nsg_rules_inbound.jpg)

Configurer la règle de la manière suivante :
* `Plage de ports de destination` : saisir 80
* `Nom` : saisir `allow_port_80`
Laisser le reste par défaut.

![Portail web Azure - configurer une régle entrante pour groupe de sécurité](/workshop-1/resources/nsg/09_az_nsg_rules_inbound_config.jpg)

Comme les étapes précédentes, valider en cliquant sur `Ajouter`.
Une fois la notification confirmant la création de la règle reçue, vous devez la voir apparaître dans la liste :

![Portail web Azure - liste des régles entrante du groupe de sécurité](/workshop-1/resources/nsg/10_az_nsg_rules_inbound_created.jpg)

### 3.4. IP Publique
Pour pouvoir accéder à notre machine depuis internet, nous avons besoins de créer une IP publique.

Dans le menu latéral, cliquer sur `Tous les services`, puis sur `Mise en réseau`, puis sur `Adresse IP public` :

![Portail web Azure - service IP publique](/workshop-1/resources/pip/01_az_services_pip.jpg)

Comme précédemment, cliquer sur `Ajouter` dans le menu de la nouvelle fenêtre, et configurer l’IP publique :
* `Nom` : saisir `workshop-1-pip-` suivi de votre trigramme (ex : `workshop-1-pip-bga`)
* `Etiquette nom DNS` : saisir `workshop-1-` suivi de votre trigramme (ex : `workshop-1-bga`)
* `Groupe de ressource` : sélectionner celui créé précédemment dans la liste déroulante

Laisser le reste par défaut.

![Portail web Azure - configuration d'une IP publique](/workshop-1/resources/pip/02_az_pip_add.jpg)

Cliquez sur `Créer`. Une fois la notification de validation de création reçue, cliquez sur `Actualiser` et vérifiez que l’ip publique apparaît bien dans la liste.

![Portail web Azure - liste des IP publiques](/workshop-1/resources/pip/03_az_pip_created.jpg)

Vous avez terminé les fondations de votre infrastructure, bien joué !

## 4. Création de la machine virtuelle
Vous avez créé tous les éléments d’infrastructure nécessaires pour déployer votre VM, nous pouvons donc procéder à la création de celle-ci pour héberger notre application.

Dans le menu latérale, cliquez sur `Machine Virtuelle` puis sur `Ajouter` :

![Portail web Azure - ajout d'une VM](/workshop-1/resources/vm/01_az_vm_add.jpg)

Dans la fenêtre qui s’ouvre, remplir la configuration de base de la VM :
* Vérifiez que votre groupe de ressource est bon dans `Groupe de ressource`
* `Nom de la machine virtuelle` : saisir `workshop-1-vm-` suivi de votre trigramme (ex : `workshop-1-vm-bga`)
* Vérifier que `Ubuntu server 18.04 LTS`est bien sélectionné dans la liste déroulante `Image`
* `Taille` : 
    * Cliquez sur `changer de taille` dans le fenêtre qui s’ouvre
    * Cliquez sur `A0, standard, Usage général` puis valider en cliquant sur `Sélectionner`

        ![Portail web Azure - configuration VM - choix de la taille](/workshop-1/resources/vm/02_az_vm_sizes.jpg)

* `Compte administrateur` :
    * `Type d’authentification` : cocher `Mot de passe`
    * `Nom d’utilisateur` : saisir votre trigramme suivi de `-admin` (ex : `bga-admin`)
    * `Mot de passe` : saisir `workshop-1-` suivi de votre trigramme (ex : `workshop-1-bga`, le mot de passe ne sera pas utilisé dans ce TP)

Laisser tous les autres réglages par défaut et cliquez ensuite sur `Suivant - Disques` :

![Portail web Azure - configuration VM - passage à l'étape de configuration des disques](/workshop-1/resources/vm/04_az_vm_config_main_next.jpg)

Laisser les options par défaut et cliquez sur `Suivant - Mise en réseau` :

![Portail web Azure - configuration VM - passage à l'étape de configuration du réseau](/workshop-1/resources/vm/05_az_vm_config_discs_next.jpg)

Configurez les paramètres réseau de machine virtuelle :
* Vérifier que le réseau virtuel, le sous-réseau et l’IP publique correspondent à ceux créés précédemment
* `Adresse IP publique` : sélectionner celle créée précédemment.
    > **Attention à ne pas en créer une nouvelle !**
* `Groupe de sécurité réseau de la carte réseau` : cochez `paramètres avancés`
* `Configurer le groupe de sécurité réseau` : choisir celui créé précédemment dans la liste déroulante
    > **Attention à ne pas en créer un nouveau !**

Laisser le reste des options par défaut.

![Portail web Azure - configuration VM - mise en réseau](/workshop-1/resources/vm/06_az_vm_config_network.jpg)

Cliquez sur `Suivant - Administration`, puis décocher `Diagnostics de démarrage` dans les options de supervision :

![Portail web Azure - configuration VM - administration](/workshop-1/resources/vm/07_az_vm_config_admin.jpg)

Cliquez sur `Suivant - configuration de l’invité`, puis configurer les options :
* `Cloud init` : 
    * récupérez le script sur le dépôt github du TP : https://raw.githubusercontent.com/bgauduch/terraform-azure-iac-workshop/workshop-rework/workshop-1/vm-cloud-init.yaml
    * Copiez ce script, et collez-le dans le champ `cloud init`
    > remarque : ce script va automatiquement installer au démarrage de la machine une application node.js et un serveur web qui écoutera sur le port 80.

Laisser le reste par défaut.

![Portail web Azure - configuration VM - cloud init](/workshop-1/resources/vm/08_az_vm_config_cloud_init.jpg)

Cliquez ensuite sur `valider + créer`, profitez de la page récapitulative pour vérifier votre configuration, puis cliquez sur `Créer` :

![Portail web Azure - création de la VM](/workshop-1/resources/vm/09_az_vm_create.jpg)

La création de la machine virtuelle peut prendre quelques minutes.
Une fois la notification de validation du déploiement reçue, passer à la suite. 

## 5. Validation du déploiement
Notre application est maintenant déployé, nous allons vérifier que nous y avons accès et qu’elle fonctionne en naviguant sur le nom de domain de notre IP publique.

Votre application est normalement accessible à l’URL suivante :
http://workshop-1-TRIGRAMME.northeurope.cloudapp.azure.com/ (remplacer TRIGRAMME par votre trigramme)

Si vous obtenez la page suivante, félicitation, vous avez réussi !

![Portail web Azure - VM](/workshop-1/resources/vm/11_webapp.jpg)

Remarque : l’application étant déployée une fois la machine démarrée, son installation peut prendre un peu de temps : ne soyez pas étonné de devoir attendre quelques minutes avant que la page web fonctionne !

## 6. Nettoyage des ressources
Une fois que l’application est déployée avec succès et que son fonctionnement est vérifié, nous pouvons détruire les ressources.

Se rendre sur la liste des groupes de ressources :

![Portail web Azure - liste des groupes de ressources](/workshop-1/resources/rg/01_az_rg.jpg)

Cliquez ensuite sur votre groupe de ressource :

![Portail web Azure - liste des groupes de ressources](/workshop-1/resources/rg/08_az_rg_list_refreshed.jpg)

Cliquez sur le bouton `Supprimer le groupe de ressource`, et confirmez la demande de suppression en saisissant le nom du groupe (suppression de toutes les ressources du groupe), puis valider en cliquant sur `Supprimer`

Il suffit alors d’attendre, toutes les ressources du groupe seront supprimées !

Bravo, vous avez terminé le TP :-)
