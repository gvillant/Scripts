Générer l’iso DIA en suivant le guide puis j’ai apporté les modifications suivantes : 

1.	J’ai créé un dossier VMware sous Dell_Tools, et j’y ai ajouté 
-	Les fichiers Dropship-Package.ppkg et Dropship-Unattend.xml (générés à partir de la console UEM)
-	le msi du provisioning tool
-	le .bat modifié avec les noms 
-	un fichier unattend.xml qui permet de démarrer en audit mode.

2.	J’ai modifié le fichier Dell_Tools\start.cmd en ajoutant les lignes suivantes :

Ensuite j’ai démarré ma VM avec mon ISO. 
Une fois DIA lancé, j’ai du tricher (car je n ai pas de clé USB) en montant un partage de fichiers dans lequel j’ai mis mon image Windows Wim + le pack de drivers family, et sur ce point, j’ai besoin de ton aide pour identifier la lettre de lecteur de la partition qui contient l’image Wim et le driver package, car je pense que ce serait plus judicieux de placer le ppkg et l’unattend ici … 

Voici le déroulement : 
-	DIA installe la Wim
-	Copie des fichiers vers Panther\unattend
-	Choisir « Reboot » à la fin du processus DIA.
-	La machine démarre en audit mode, installe, lance le provisioningTool, qui injecte le ppkg et l’unattend, puis sysprep et stoppe la machine. 
-	La machine est provisionnée, et prête à è tre utilisée. 

