  /*1h) Afficher le nom et l’état des notifications créées par l’administrateur ayant pour nom «Thomas» et pour prénom «Paul»  */
   
   /*1)h)i) avec un in */
  
    insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'thomas.paul', FCT_GENERER_MOT_DE_PASSE(7), 'Paul', 'Thomas', '10 boulevard Park 4 Sauthoff Circle', 'h3e 4t1', 'USA', '(514)699-1569','(514)199-4569','Anglais','/membre1.png','Jhondoes.com','NASA','thomas.paul@cipre.com', 5 ,1,0,1);
  
  
    insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_2_thomas', to_date('15-09-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 110, 10);
  

  select NOM_NOT, ETAT_NOT
  from TP2_NOTIFICATION N, TP2_MEMBRE M
  where N.NO_MEM_ADMIN_CREATION = M.NO_MEMBRE and NO_MEMBRE in (select NO_MEMBRE
                                                           from TP2_MEMBRE
                                                           where NOM_MEM = 'Paul' and PRENOM_MEM = 'Thomas');
