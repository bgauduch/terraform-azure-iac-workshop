# Workshop 2 - FR - IaC sur Azure avec Terraform
Application de l’IaC sur Azure avec Terraform.

## Sommaire

1. [Objectif du TP](#1.-objectif-du-tp)
1. [Configuration de l’environnement de développement](#2.-configuration-de-l’environnement-de-développement)
    1. [Accès au portail Azure](#2.1.-accès-au-portail-azure)
    1. [Installation des outils](#2.2.-installation-des-outils)
    1. [Initialisation du projet](#2.3.-initialisation-du-projet)
1. [Création de l’infrastructure](#3.-création-de-l’infrastructure)
    1. [Groupe de ressources](#3.1.-groupe-de-ressources)
    1. [Groupe de sécurité](#3.2.-groupe-de-sécurité)
    1. [Réseau virtuel](#3.3.-réseau-virtuel)
    1. [IP publique](#3.4.-ip-publique)
    1. [Carte réseau](#3.5.-carte-réseau)
1. [Création de la VM](#4.-création-de-la-vm)
    1. [Configuration du script de démarrage](#4.1.-configuration-du-script-de-démarrage)
    1. [Configuration de la VM](#4.2.-configuration-de-la-vm)
1. [Validation du déploiement](#5.-validation-du-déploiement)
1. [Aller plus loin](#6.-aller-plus-loin)
1. [Nettoyage des ressources](#7.-nettoyage-des-ressources)

## 1. Objectif du TP
Vous allez déployer la même application que lors du TP précédent, en utilisant cette fois l’outil Terraform.

## 2. Configuration de l’environnement de développement

### 2.1. Accès au portail Azure
Vérifiez que vous avez bien accès au portail web azure (CF. [workshop 1](/workshop-1)).

Il vous servira uniquement à visualiser les ressources déployés pendant ce TP, visible sur la page `Ressources` accessible depuis le menu latéral.
N’oubliez pas que vous pouvez à tout moment rafraîchir cette vue pour visualiser les nouvelles ressources :

![Portail web Azure - liste des ressources, vide](/workshop-2/resources/az_resources_list.jpg)

### 2.2. Installation des outils
Pour ce TP, 2 outils sont nécessaires :

* Le CLI Azure, qui permet de vous authentifier localement ;
* Le CLI Terraform, qui permet de déployer des ressources depuis votre poste en fonction de la configuration que vous allez créer.

Afin d’en simplifier l’utilisation, nous allons utiliser un container Docker dans le terminal Cloudshell de Google Cloud (à faire en groupe avec l’animateur).

Pour valider votre configuration, ouvrez votre terminal et saisissez la commande suivante :
```bash
docker container run hello-world
```

> En cas de problème, notifier l’encadrant.

### 2.3. Initialisation du projet
Vous allez récupérer le squelette du TP afin d’initialiser votre environnement de travail.

Seul le contenu du répertoire `/workshop-2/skeleton` sera utilisé pour la suite.

A noter que les solutions des différentes étapes sont dans `/workshop-2/solution`, à n'utiliser qu'en dernier recours bien entendu, à vous de jouer le jeu !

Sur Cloudshell, clonez le dépôt github **en utilisant HTTPS** :
```bash
git clone https://github.com/bgauduch/terraform-azure-iac-workshop.git
```

Naviguez dans le répertoire `workshop-2/skeleton` :
```bash
cd terraform-azure-iac-workshop/workshop-2/skeleton/
```

Lancer le script de configuration de votre environnement, normalement il doit télécharger l’image Docker et lancer celle-ci (peut prendre du temps la première fois) :
```bash
./env-init.sh
```

Une fois que l’image Docker est téléchargé et que le container est lancé, vérifiez que vous avez bien accès aux commandes Azure et Terraform en affichant leurs aides :
```bash
az -h

terraform -h
```

Initialisez Terraform. Vous devriez voir apparaître de nouveaux fichiers téléchargés par Terraform pour communiquer avec Azure (provider AzureRM, sous forme de plugin) :
```bash
terraform init
```

Finalement, connectez vous à Azure en suivant les instructions de la commande suivante (vous aurez besoins de votre login du portail Azure) :
```bash
az login
```

Parfait, vous êtes fin prêts pour la suite du TP :-)

## 3. Création de l’infrastructure
Vous allez maintenant créer les bases de votre infrastructure, en utilisant Terraform.

### 3.1. Groupe de ressources
> Documentation : [groupe de ressource](https://www.terraform.io/docs/providers/azurerm/r/resource_group.html )

Ajoutez la configuration de votre groupe de ressource au fichier `main.tf` :
```tf
resource "azurerm_resource_group" "az_iac_rg" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_region}"

  tags {
    environment = "${var.environment_tag}"
  }
}
```

Comme vous le constatez, des variables sont utilisées. Il faut donc les ajouter dans le fichier `variables.tf`.
> Documentation : [variables](https://www.terraform.io/docs/configuration/variables.html)
 
Veillez à modifier la valeur par défaut de la variable `resource_group_name` en remplaçant `TRIGRAMME` par votre trigramme (1 occurrence) :
```tf
variable "azure_region" {
  description = "The Azure Region to be use"
  type        = "string"
  default     = "North Europe"
}

variable "resource_group_name" {
  description = "the resource group name"
  type        = "string"
  default     = "az_iac_rg_TRIGRAMME"
}

variable "environment_tag" {
  description = "the current environement tag"
  type        = "string"
  default     = "production"
}
```

Effectuer une validation syntaxique de votre configuration:
```bash
terraform validate
```

Vous pouvez alors visualiser les actions que Terraform va réaliser sur Azure :
```bash
terraform plan
```

Le résultat doit être similaire à ceci :
```bash
------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + azurerm_resource_group.terraform_demo_rg
      id:               <computed>
      location:         "northeurope"
      name:             "az-iac-rg-TRIGRAMME"
      tags.%:           "1"
      tags.environment: "production"


Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------
```

En cas d’erreur, bien lire les informations affichées dans la console pour identifier la source du problème et corriger la configuration !

Une fois que vous avez obtenu votre plan, vous pouvez alors appliquer ces modifications sur votre infrastructure (ne pas oublier de répondre `yes` lorsque c’est demandé) :
```bash
terraform apply
```

Pour vérifier que tout s’est bien déroulé, vérifier que le groupe de ressource est bien créé sur le portail web Azure (actualiser si besoin) :

![Portail web Azure - liste des groupes de ressources](/workshop-2/resources/az_resource_group_list.jpg)


Bravo, vous venez de déployer votre première ressource sur Azure avec Terraform !

**Remarque** : Notez bien le workflow de travail avec Terraform car **pour la suite du TP, il ne sera pas précisé à chaques étapes** :
* Ecriture de la configuration ;
* Validation syntaxique
* Planification de la création des ressources et correction si nécessaire ;
* Si tout est conforme, déploiement des ressources.

### 3.2. Groupe de sécurité
Vous allez maintenant ajouter le groupe de sécurité réseau ainsi que la règle autorisant les connexions entrantes HTTP.

> Documentation : 
> * [Groupe de sécurité](https://www.terraform.io/docs/providers/azure/r/security_group.html)
> * [Règle de sécurité](https://www.terraform.io/docs/providers/azurerm/r/network_security_rule.html)

Ajouter la configuration des ressources au fichier `main.tf`, veillez à remplacer `TRIGRAMME` par votre trigramme  (2 occurrences) :
```tf
resource "azurerm_network_security_group" "az_iac_nsg" {
 name                = "az_iac_nsg_TRIGRAMME"
 location            = "${azurerm_resource_group.az_iac_rg.location}"
 resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"
}

resource "azurerm_network_security_rule" "az_iac_nsg_rule_http_allow" {
 name                        = "az_iac_nsg_rule_http_allow_TRIGRAMME"
 priority                    = 100
 direction                   = "Inbound"
 access                      = "Allow"
 protocol                    = "*"
 source_port_range           = "*"
 destination_port_range      = "80"
 source_address_prefix       = "*"
 destination_address_prefix  = "*"
 resource_group_name         = "${azurerm_resource_group.az_iac_rg.name}"
 network_security_group_name = "${azurerm_network_security_group.az_iac_nsg.name}"
}
```

Comme aux étapes précédentes, planifiez le déploiement, corrigez les éventuelles erreurs, et déployez.

Vérifiez que votre groupe de sécurité apparaît bien dans les ressources du portail web Azure.

### 3.3. Réseau virtuel
Vous allez maintenant ajouter le réseau virtuel et son sous-réseau dans votre groupe de ressources. Vous allez aussi lier le subnet avec le groupe de sécurité créé précédemment.

> Documentation : 
> * [Réseau virtuel](https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html)
> * [Sous réseau](https://www.terraform.io/docs/providers/azurerm/r/subnet.html)
> * [Associer sous réseau et groupe de sécurité](https://www.terraform.io/docs/providers/azurerm/r/subnet_network_security_group_association.html)

Ajouter la configuration des ressources au fichier `main.tf`, veillez à remplacer `TRIGRAMME` par votre trigramme (2 occurrences) :
```tf
resource "azurerm_virtual_network" "az_iac_vnet" {
 name                = "az_iac_vnet_TRIGRAMME"
 location            = "${azurerm_resource_group.az_iac_rg.location}"
 resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"    
 address_space = ["${var.vnet_range}"]
 tags {
   environment = "${var.environment_tag}"
 }
}

resource "azurerm_subnet" "az_iac_subnet" {
 name                 = "az_iac_subnet_TRIGRAMME"
 resource_group_name  = "${azurerm_resource_group.az_iac_rg.name}"
 virtual_network_name = "${azurerm_virtual_network.az_iac_vnet.name}"
 address_prefix = "${cidrsubnet(var.vnet_range, 8, 1)}"
}

resource "azurerm_subnet_network_security_group_association" "az_iac_subnet_nsg_bind" {
 subnet_id                 = "${azurerm_subnet.az_iac_subnet.id}"
 network_security_group_id = "${azurerm_network_security_group.az_iac_nsg.id}"
}
```

Ajouter la variable nécessaire au fichier `variables.tf` :
```tf
variable "vnet_range" {
 description = "The ip range for the VNET"
 type        = "string"
 default     = "10.0.0.0/16"
}
```

Comme aux étapes précédentes, planifiez le déploiement, corrigez les éventuelles erreurs, et déployez.

Vérifiez que votre vnet apparaît bien dans les ressources du portail web Azure.

### 3.4. IP publique
Vous allez créer l’IP publique pour accéder à votre VM depuis internet.

> Documentation : [IP Publique](https://www.terraform.io/docs/providers/azurerm/r/public_ip.html)

Ajouter la configuration des ressources au fichier `main.tf`, veillez à remplacer `TRIGRAMME` par votre trigramme (2 occurrences) :
```tf
resource "azurerm_public_ip" "az_iac_pip" {
 name                         = "az_iac_pip_TRIGRAMME"
 location                     = "${azurerm_resource_group.az_iac_rg.location}"
 resource_group_name          = "${azurerm_resource_group.az_iac_rg.name}"
 ip_version = "ipv4"
 allocation_method = "Static"
 domain_name_label = "azure-iac-TRIGRAMME"
 tags {
   environment = "${var.environment_tag}"
 }
}
```

Comme aux étapes précédentes, planifiez le déploiement, corrigez les éventuelles erreurs, et déployez.

Vérifiez que votre IP publique apparaît bien dans les ressources du portail web Azure.

### 3.5. Carte réseau
Dernière étape de l’infrastructure réseau, vous allez créer la carte réseau qui sera utilisée par votre VM et qui va porter l’IP publique créée précédemment.

> Documentation : [Carte réseau virtuelle](https://www.terraform.io/docs/providers/azurerm/r/network_interface.html)

Ajouter la configuration des ressources au fichier `main.tf`, veillez à remplacer `TRIGRAMME` par votre trigramme (2 occurrences) :
```tf
resource "azurerm_network_interface" "az_iac_nic" {
 name                = "az_iac_nic_TRIGRAMME"
 location            = "${azurerm_resource_group.az_iac_rg.location}"
 resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"

 ip_configuration {
   name                          = "az_iac_nic_ip_config_TRIGRAMME"
   subnet_id                     = "${azurerm_subnet.az_iac_subnet.id}"
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = "${azurerm_public_ip.az_iac_pip.id}"
 }
 tags {
   environment = "${var.environment_tag}"
 }
}
```

Comme aux étapes précédentes, planifiez le déploiement, corrigez les éventuelles erreurs, et déployez.

Vérifiez que votre carte réseau apparaît bien dans les ressources du portail web Azure.

Félicitation, vous avez finalisé le déploiement de votre infrastructure réseau !

## 4. Création de la VM
Maintenant que la partie réseau est en place, il est temps de déployer votre machine virtuelle hébergeant l’application. elle sera lié à la carte réseau précédemment créée.

> Documentation : [machine virtuelle](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

### 4.1. Configuration du script de démarrage
La première étape consiste à charger le script qui va permettre l’installation de l’application au démarrage de la machine virtuelle.

> Documentation:
> * [lecture fichier de template](https://www.terraform.io/docs/providers/template/d/file.html)
> * [template Cloud-init](https://www.terraform.io/docs/providers/template/d/cloudinit_config.html)

Ajouter la configuration permettant de charger le script au fichier `main.tf` :
```tf
data "template_file" "az_iac_cloudinit_file" {
 template = "${file("${var.cloudinit_script_path}")}"
}
```

Ensuite, ajouter la configuration qui va encoder le script au fichier `main.tf` :
```tf
data "template_cloudinit_config" "az_iac_vm_cloudinit_script" {
 gzip          = true
 base64_encode = true

 part {
   content_type = "text/cloud-config"
   content      = "${data.template_file.az_iac_cloudinit_file.rendered}"
 }
}
```

Il faut enfin ajouter la variable qui référence le chemin du script dans le fichier `variable.tf` :
```tf
variable "cloudinit_script_path" {
 description = "The user password on the VM"
 type        = "string"
 default = "vm-cloud-init.yaml"
}
```

Notez que nous utilisons ici un nouveau plugin Terraform qu’il faut installer : `data`.
Effectuer une nouvelle initialisation du projet pour permettre à Terraform de télécharger le plugin manquant :
```
terraform init
```


### 4.2. Configuration de la VM
La seconde est dernière étape de déploiement consiste à ajouter la configuration de l’ensemble de la VM.

Ajouter la configuration au fichier `main.tf`, celle-ci est assez conséquente mais ne fait que reprendre ce que vous avez fait au premier TP.
Veillez à remplacer `TRIGRAMME` par votre trigramme (1 occurrences) :
```tf
resource "azurerm_virtual_machine" "az_iac_vm" {
 name                = "az_iac_vm_TRIGRAMME"
 location            = "${azurerm_resource_group.az_iac_rg.location}"
 resource_group_name = "${azurerm_resource_group.az_iac_rg.name}"

 network_interface_ids         = ["${azurerm_network_interface.az_iac_nic.id}"]
 vm_size                       = "${var.vm_size}"
 delete_os_disk_on_termination = true

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "${var.ubuntu_version}"
   version   = "latest"
 }
 storage_os_disk {
   name              = "az_iac_vm_os_disk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }
 os_profile {
   computer_name  = "az-iac-vm-bga"
   admin_username = "${var.user_name}"
   admin_password = "${var.user_password}"
   custom_data          = "${data.template_cloudinit_config.az_iac_vm_cloudinit_script.rendered}"
 }
 os_profile_linux_config {
   disable_password_authentication = false
 }
 tags {
   environment = "${var.environment_tag}"
 }
}
```

Ajouter les nouvelles variables nécéssaires au fichier `variables.tf` :
```tf
variable "ubuntu_version" {
 description = "The Ubuntu OS version to be used on VM"
 type        = "string"
 default     = "18.04-LTS"
}
variable "vm_size" {
 description = "The Vm Size"
 type        = "string"
 default     = "Standard_A1_v2"
}
variable "user_name" {
 description = "The username on the VM"
 type        = "string"
 default     = "azureuser"
}
variable "user_password" {
 description = "The user password on the VM"
 type        = "string"
}
```

Notez :
* l’usage du script d’initialisation de la VM dans la clée `os_profile.custom_Data`.
* l’absence de valeur par défaut pour le mot de passe : Terraform vous demande d’en saisir un. 
**Soyez vigilant lors de la saisie pour respecter les règles suivante** (au risque de vous voir refuser la création de la VM) :
  * plus de 6 caractères
  * doit contenir au moins
    * 1 majuscule
    * 1 minuscule
    * 1 nombre et 1 caractère spéciale.

Comme aux étapes précédentes, planifiez le déploiement, corrigez les éventuelles erreurs, et déployez.
Cette étape est potentiellement longue, soyez patient ;-)

Vérifiez que votre VM apparaît bien dans les ressources du portail web Azure, votre liste de ressources devrait être similaire à celle-ci :

![Portail web Azure - liste des ressources](/workshop-2/resources/az_resources_network_vm.jpg)


Si tout est en ordre : bravo ! Vous avez déployé une infrastructure complète ainsi qu’une application sur Azure !

## 5. Validation du déploiement
A la fin du déploiement, il faut encore patienter un peu pour que le script installe l’application sur votre VM.

Votre application doit être accessible dans votre navigateur internet à l’url configuré lors de la création de l’IP publique, à savoir :
http://azure-iac-TRIGRAMME.northeurope.cloudapp.azure.com/ (remplacer TRIGRAMME par le votre) 

Vous devriez voir apparaître la page suivante :

![Application web - Hello World !](/workshop-2/resources/webapp.jpg)

Bien joué ! Vous avez déployé une application dans le cloud Azure de A à Z, et ce grâce à Terraform. 

Maintenant que vous avez construit les scripts de configuration et variabilisé la configuration, ces opérations sont répétable !

Vous pouvez apporter les modifications souhaitées directement aux fichiers de configuration pour mettre à jour votre infrastructure, ou encore un déployer une nouvelle, sans passer par le portail web.

## 6. Aller plus loin
Si vous avez terminé les étapes précédentes et qu'il vous reste du temps, vous pouvez aller plus loin en effectuant les tâches suivantes :
* Explorer les autres fonctionnalitées offertes par le CLI Terraform:
  * Les graphs de ressource et leurs affichage
  * Le formatage des fichiers de votre projet
  * l'inspection de votre état courant
  * etc.
* Rendre votre déploiement modulaire, en séparant la création de votre stack réseau de la création de votre VM par exemple
* Explorer les workspaces pour déployer plusieurs environnements à partir des mêmes descripteurs Terraform
* Creuser le partage de l'état Terraform courant avec la notion de "remote state" pour travailler en équipe sur une infrastructure partagée

Vous pouvez vous référer à la [documentation](https://www.terraform.io/docs/index.html), des exemples sont aussi disponibles sur [ce repository](https://github.com/bgauduch/terraform-azure-demo) 

## 7. Nettoyage des ressources
Dernière étape de ce TP : la suppression des ressources déployée.

Rien de plus simple, une commande suffit (répondre `yes` à la demande de confirmation) :
terraform destroy

Le tour est joué. Félicitations, vous avez terminé ce TP !
