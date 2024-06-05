#!/bin/bash

# Arrêter le script en cas d'erreur
set -e

# Fonction pour gérer les erreurs
error_exit() {
    echo "Erreur: $1" 1>&2
    exit 1
}

# Mise à jour des paquets existants
echo "Mise à jour des paquets..."
sudo apt update -y || error_exit "La mise à jour des paquets a échoué."

# Installation de curl
echo "Installation de curl..."
sudo apt install curl -y || error_exit "L'installation de curl a échoué."

# Téléchargement de Apache 2.4.49
echo "Téléchargement de Apache HTTP Server 2.4.49..."
sudo wget https://archive.apache.org/dist/httpd/httpd-2.4.49.tar.gz || error_exit "Le téléchargement a échoué."

# Extraction du fichier téléchargé
echo "Extraction du fichier tar.gz..."
sudo tar -xf httpd-2.4.49.tar.gz || error_exit "L'extraction a échoué."

# Installation des dépendances nécessaires
echo "Installation des dépendances..."
sudo apt install build-essential libssl-dev libexpat1-dev libpcre3-dev libapr1-dev libaprutil1-dev -y || error_exit "L'installation des dépendances a échoué."

# Se rendre dans le répertoire extrait
echo "Accès au répertoire httpd-2.4.49..."
cd httpd-2.4.49 || error_exit "Le répertoire httpd-2.4.49 est introuvable."

# Configuration de l'installation et activation des modules partagés
echo "Configuration de l'installation..."
sudo ./configure --prefix=/usr/local/apache-2.4.49 --enable-shared=max || error_exit "La configuration a échoué."

# Compilation et installation Apache
echo "Compilation et installation d'Apache..."
sudo make || error_exit "La compilation a échoué."
sudo make install || error_exit "L'installation a échoué."

# Suppression du fichier httpd.conf existant
echo "Suppression du fichier httpd.conf existant..."
sudo rm -f /usr/local/apache-2.4.49/conf/httpd.conf || error_exit "La suppression du fichier httpd.conf a échoué."

# Remplacement par le fichier httpd.conf modifié
echo "Copie du nouveau fichier httpd.conf..."
sudo cp /home/epsi/Script_MSPR/httpd.conf /usr/local/apache-2.4.49/conf/ || error_exit "La copie du nouveau fichier httpd.conf a échoué."

# Redémarrage du serveur
echo "Redémarrage d'Apache HTTP Server..."
sudo /usr/local/apache-2.4.49/bin/apachectl restart || error_exit "Le redémarrage du serveur Apache a échoué."

echo "Apache HTTP Server 2.4.49 a été installé, configuré et redémarré avec succès."
