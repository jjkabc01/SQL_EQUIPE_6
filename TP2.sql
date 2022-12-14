/**** TP2 *******/ 

SET SERVEROUTPUT ON

/***** Création des tables du cas CIPRÉ ******/

drop table TP2_MEMBRE cascade constraints;
drop table TP2_PROJET cascade constraints;
drop table TP2_EQUIPE_PROJET cascade constraints;
drop table TP2_NOTIFICATION cascade constraints;
drop table TP2_RAPPORT cascade constraints;
drop table TP2_RAPPORT_ETAT cascade constraints;
drop table TP2_INSCRIPTION_CONFERENCE cascade constraints;
drop table TP2_CONFERENCE cascade constraints;
drop sequence NO_MEMBRE_SEQ;
drop sequence NO_PROJET_SEQ;
drop sequence NO_NOTIFICATION_SEQ;
drop sequence NO_RAPPORT_SEQ;


create table TP2_MEMBRE (
  NO_MEMBRE number(10) not null, 
  UTILISATEUR_MEM varchar2(20) not null,
  MOT_DE_PASSE_MEM varchar2(20) not null,
  NOM_MEM varchar2(30) not null,
  PRENOM_MEM varchar2(30) not null,
  ADRESSE_MEM varchar2(40) not null,  
  CODE_POSTAL_MEM char(7) not null,  /* 7 char parceque le code postal doit contenir un espace ? */
  PAYS_MEM varchar2(30) not null, 
  TEL_MEM char(13) not null, 
  FAX_MEM char(13) null,  
  LANGUE_CORRESPONDANCE_MEM varchar2(30) default 'Français' not null,
  NOM_FICHIER_PHOTO_MEM varchar2(200) null, 
  ADRESSE_WEB_MEM varchar2(30) null,
  INSTITUTION_MEM varchar2(30) not null,
  COURRIEL_MEM varchar2(30) not null,
  NO_MEMBRE_PATRON number(10) not null, 
  EST_ADMINISTRATEUR_MEM number(1) default 0 not null, 
  EST_SUPERVISEUR_MEM number(1) default 0 not null, 
  EST_APPOUVEE_INSCRIPTION_MEM number(1) default 0 not null, 
  constraint CT_COURRIEL_MEM_FORMAT check (COURRIEL_MEM like '%_@__%.__%'),
  constraint CT_LONGUEUR_ADRESSE_MEM check ( length(ADRESSE_MEM) > 20 and length (ADRESSE_MEM) < 40),
  constraint CT_CODE_POSTAL_MEM 
	check ( regexp_like( CODE_POSTAL_MEM, '[a-zA-Z][0-9][a-zA-Z] [0-9][a-zA-Z][0-9]')),
  constraint AK_TP2_MEMBRE_COURRIEL_MEM unique (COURRIEL_MEM),
  constraint AK_TP2_MEMBRE_UTILISATEUR_MEM unique (UTILISATEUR_MEM),
  constraint AK_TP2_MEMBRE_PRENOM_MEM unique (PRENOM_MEM),
  constraint AK_TP2_MEMBRE_NOM_MEM unique (NOM_MEM),
  constraint AK_TP2_MEMBRE_ADRESSE_MEM unique (ADRESSE_MEM),
  constraint AK_TP2_MEMBRE_CODE_POSTAL_MEM unique (CODE_POSTAL_MEM),
  constraint PK_TP2_MEMBRE primary key (NO_MEMBRE),
  constraint FK_TP2_MEMBRE foreign key (NO_MEMBRE_PATRON) 
				references TP2_MEMBRE (NO_MEMBRE)	
 );


create table TP2_PROJET (
  NO_PROJET number(10) not null, 
  NOM_PRO varchar2(30) not null,
  MNT_ALLOUE_PRO number(9,2) default 0.0 not null, 
  STATUT_PRO varchar2(30) default 'Débuté' not null,
  DATE_DEBUT_PRO date not null,
  DATE_FIN_PRO date not null,
  constraint PK_TP2_PROJET primary key (NO_PROJET),
  constraint AK_TP2_PROJET_NOM_PRO unique (NOM_PRO),
  constraint CT_STATUT_PRO check (STATUT_PRO in ('Débuté', ' En vérification', 'En correction', 'Terminé')),
  constraint CT_MNT_ALLOUE_PRO_SUPERIEUR_EGAL_0 check(MNT_ALLOUE_PRO >= 0),
  constraint CT_DATE_FIN_PRO_SUPERIEUR_DATE_DEBUT_PRO check (DATE_FIN_PRO > DATE_DEBUT_PRO)
  
);

create table TP2_EQUIPE_PROJET (
  NO_MEMBRE number(10) not null, 
  NO_PROJET number(10) not null, 
  EST_DIRECTEUR_PRO number(1) default 0 not null, 
  constraint PK_TP2_EQUIPE_PROJET primary key (NO_MEMBRE, NO_PROJET),
  constraint FK_TP2_EQUIPE_PROJET_NO_MEMBRE foreign key (NO_MEMBRE) 
				references TP2_MEMBRE (NO_MEMBRE) ,
  constraint FK_TP2_EQUIPE_PROJET_NO_PROJET foreign key (NO_PROJET) 
				references TP2_PROJET (NO_PROJET) 

);


create table TP2_NOTIFICATION (
  NO_NOTIFICATION number(10) not null,
  NOM_NOT varchar2(30) not null,
  DATE_ECHEANCE_NOT date not null,
  ETAT_NOT varchar2(30) default 'Non débutée' not null,
  NOTE_NOT varchar2(1000) null,
  NO_MEM_ADMIN_CREATION number(10) not null,
  NO_MEM_ATTRIBUTION number(10) not null,
  constraint PK_TP2_NOTIFICATION primary key (NO_NOTIFICATION),
  constraint CT_ETAT_NOT check (ETAT_NOT in ('Non débutée', 'En cours', 'À approuver ', 'Terminée')),
  constraint FK_TP2_NOTIFICATION_NO_MEM_ADMIN_CREATION foreign key (NO_MEM_ADMIN_CREATION) 
				references TP2_MEMBRE (NO_MEMBRE),
  constraint FK_TP2_NOTIFICATION_NO_MEM_ATTRIBUTION foreign key (NO_MEM_ATTRIBUTION) 
				references  TP2_MEMBRE(NO_MEMBRE)
  
);


create table TP2_RAPPORT_ETAT (
  CODE_ETAT_RAP char(4) not null,
  NOM_ETAT_RAP varchar2(30) not null,
  constraint PK_TP2_RAPPORT_ETAT primary key (CODE_ETAT_RAP),
  constraint CT_CODE_ETAT_RAP check ( CODE_ETAT_RAP in ( 'DEBU', 'VERI', 'CORR', 'APPR')),
  constraint CT_NOM_ETAT_RAP check ( NOM_ETAT_RAP in ('Débuté', 'En vérification', 'En correction', 'Approuvé'))
   
);

create table TP2_RAPPORT (
  NO_RAPPORT number(10) not null,
  NO_PROJET number(10) not null,
  TITRE_RAP varchar2(30) not null,
  NOM_FICHIER_RAP varchar2(200) not null, 
  DATE_DEPOT_RAP date not null,
  CODE_ETAT_RAP char(4) not null,
  constraint PK_TP2_RAPPORT primary key (NO_RAPPORT),
  constraint AK_TP2_RAPPORT_NOM_FICHIER_RAP unique (NOM_FICHIER_RAP),
  constraint FK_TP2_RAPPORT_NO_PROJET foreign key (NO_PROJET) 
				references TP2_PROJET (NO_PROJET),
  constraint FK_TP2_RAPPORT_CODE_ETAT_RAP foreign key (CODE_ETAT_RAP) 
				references TP2_RAPPORT_ETAT (CODE_ETAT_RAP)
	
);


create table TP2_CONFERENCE (
  SIGLE_CONFERENCE varchar2(10) not null,
  TITRE_CON varchar2(40) not null,
  DATE_DEBUT_CON date not null,
  DATE_FIN_CON date not null,
  LIEU_CON varchar2(40) not null,
  ADRESSE_CON varchar2(40) not null,
  constraint PK_TP2_CONFERENCE primary key (SIGLE_CONFERENCE),
  constraint AK_TP2_CONFERENCE_TITRE_CON unique (TITRE_CON),
  constraint CT_LONGUEUR_ADRESSE_CON check ( length(ADRESSE_CON) > 20 and length (ADRESSE_CON) < 40)

);

create table TP2_INSCRIPTION_CONFERENCE (
  SIGLE_CONFERENCE varchar2(10) not null,
  NO_MEMBRE number(10) not null, 
  DATE_DEMANDE_INS date not null,
  STATUT_APPROBATION_INS number(1) default 0 not null,   /* default 'Non débutée' not null,     ( il faut trouver les valeurs possible de STATUT_APPROBATION_INS) */
  constraint PK_TP2_INSCRIPTION_CONFERENCE primary key (SIGLE_CONFERENCE, NO_MEMBRE),
  constraint FK_TP2_INSCRIPTION_CONFERENCE_SIGLE_CONFERENCE foreign key (SIGLE_CONFERENCE)
	references TP2_CONFERENCE (SIGLE_CONFERENCE),
  constraint FK_TP2_INSCRIPTION_CONFERENCE_NO_MEMBRE foreign key (NO_MEMBRE)
	references TP2_MEMBRE (NO_MEMBRE)
  /* ( il faut trouver les valeurs possible de STATUT_APPROBATION_INS)
	constraint CT_INSCRIPTION_CONFERENCE check (STATUT_APPROBATION_INS in ('Non débutée', 'En cours', 'À approuver', 'Terminée'))
  */
	
);



/***** Creation des séquences ****/

create sequence NO_MEMBRE_SEQ
    start with 5
    increment by 5;
    
create sequence NO_PROJET_SEQ
    start with 1000
    increment by 1;
    
create sequence NO_NOTIFICATION_SEQ
    start with 1000
    increment by 1;
    
create sequence NO_RAPPORT_SEQ
    start with 1000
    increment by 1;
    
    
    
    
/******* Creation des Vues initiales *****/
    
    create or replace view VUE_ADMINISTRATEUR ( UTILISATEUR_ADMINISTRATEUR, MOT_DE_PASSE_ADM, COURRIEL_ADM, TEL_ADM, NOM_ADM, PRENOM_ADM, NO_MEMBRE)
        as select UTILISATEUR_MEM, MOT_DE_PASSE_MEM, COURRIEL_MEM, TEL_MEM, NOM_MEM, PRENOM_MEM,NO_MEMBRE
            from TP2_MEMBRE
            where EST_ADMINISTRATEUR_MEM = 1;
    
    create or replace view VUE_SUPERVISEUR ( UTILISATEUR_ADMINISTRATEUR, MOT_DE_PASSE_ADM, COURRIEL_ADM, TEL_ADM, NOM_ADM, PRENOM_ADM, NO_MEMBRE)
        as select UTILISATEUR_MEM, MOT_DE_PASSE_MEM, COURRIEL_MEM, TEL_MEM, NOM_MEM, PRENOM_MEM,NO_MEMBRE
            from TP2_MEMBRE
            where EST_SUPERVISEUR_MEM = 1;
            
            
            
            
/******* Insertion pour le test des vues initiales ********/
    
    insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
  values ( NO_MEMBRE_SEQ.nextval, 'admin', 'admin', 'admin', 'admin', 'admin hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j6', 'admin', '(514)699-2569','(514)699-2569','francais','admin','admin','admin','admin@cipre.com', 5 ,1,0,1);
  
  
      insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
  values ( NO_MEMBRE_SEQ.nextval, 'superviseur', 'superviseur', 'superviseur', 'superviseur', 'superviseur hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j7', 'cipre', '(514)699-2569','(514)699-2569','francais','superviseur','superviseur','superviseur','superviseur@cipre.com', 5 ,0,1,1);
  
  select * from VUE_ADMINISTRATEUR;
    
  select * from VUE_SUPERVISEUR;
  
  

  /*********** Question 2d) Donnez la requête SQL qui crée une fonction nommée FCT_GENERER_MOT_DE_PASSE pour la génération des mot de passe des membres ***********/
  
 create or replace function FCT_GENERER_MOT_DE_PASSE(V_NB_CARACTERE in number) return varchar2
  is
    V_NB_CARACTERE_FINALE number := 0;
    V_MOT_DE_PASSE varchar2 (14);
    V_MOT_DE_PASSE_temp varchar2 (14);
    V_QUIT_LOOP number (1) := 0;
    
  begin 
  
    V_NB_CARACTERE_FINALE := V_NB_CARACTERE;
  
    if V_NB_CARACTERE < 7 then
        V_NB_CARACTERE_FINALE := 7;
    end if;
        
    if V_NB_CARACTERE > 14 then
        V_NB_CARACTERE_FINALE := 14;
    end if;
     
    while V_QUIT_LOOP = 0
        loop
            V_MOT_DE_PASSE := dbms_random.string('a', V_NB_CARACTERE_FINALE-4) || substr('!?&$/|#', dbms_random.value (1, 8), 1 ) || dbms_random.string('x', 1)  || dbms_random.string('l', 1) ||  TRUNC(DBMS_RANDOM.value(1,9));
            V_QUIT_LOOP := 1;

           if (regexp_count(V_MOT_DE_PASSE, '[a-z]') > 0
                and regexp_count(V_MOT_DE_PASSE, '[A-Z]') > 0 
                and regexp_count(V_MOT_DE_PASSE, '[0-9]') > 0
                or regexp_count(V_MOT_DE_PASSE, '[!|?|&|$|/|#|]') > 0) then
                    V_QUIT_LOOP := 1;
            end if;
          
            
        end loop;
        
    return (V_MOT_DE_PASSE);
    
  end FCT_GENERER_MOT_DE_PASSE;
  /
  
  select FCT_GENERER_MOT_DE_PASSE(7) from DUAL;
  
  
  /******* Question 1) b) 2 requêtes d’insertion SQL valides pour chaque table du modèle. Pour la table des MEMBRE, utilisez la fonction de la question 2d)  ***********/
  
  /************ Table TP2_MEMBRE ********************/
  
  insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'john.doe', FCT_GENERER_MOT_DE_PASSE(14), 'Doe', 'John', '4 Derek Park 4 Sauthoff Circle', 'h3e 1j8', 'USA', '(514)699-3569','(514)699-4569','Anglais','/membre1.png','Jhondoes.com','NASA','john.doe@cipre.com', 5 ,1,0,1);
  
   insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'Thayne.Alpe', FCT_GENERER_MOT_DE_PASSE(7), 'Thayne', 'Alpe', '46 Straubel Pass 4 Sauthoff Circle', 'h2e 1j8', 'CANADA', '(514)299-3569','(514)399-4569','Francais','/membre2.png','earthlink.net','CRA','talpe0@earthlink.net', 5 ,0,1,1);
  
  select * from TP2_MEMBRE;
  
  /****************** Table TP2_PROJET ******************/
  
  insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Projet_1', 3500000.23, 'Débuté', to_date('15-01-01','RR-MM-DD'), to_date('15-08-01','RR-MM-DD'));
  
  insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Projet_2', 200000.23, 'Débuté', to_date('15-06-01','RR-MM-DD'), to_date('15-09-01','RR-MM-DD'));
  
  select * from TP2_PROJET;
  
  /****************** Table TP2_EQUIPE_PROJET **********/
  
  insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (20, 1000, 1);
  
  insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (20, 1001, 1);
  
  select * from TP2_EQUIPE_PROJET;
  
  /*************** Table TP2_NOTIFICATION **************/
  
  insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_1', to_date('15-09-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 5, 10);
  
  insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_2', to_date('15-10-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 5, 10);
  
  select * from TP2_NOTIFICATION;
  
   /*************** Table TP2_RAPPORT_ETAT **************/
   
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'DEBU', 'Débuté');
  
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'VERI', 'En vérification');
  
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'CORR', 'En correction');
  
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'APPR', 'Approuvé');
  
  select * from TP2_RAPPORT_ETAT;
  
  /************** Table TP2_RAPPORT ********************/
  
  insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1000, 'RAPPORT_1', '/fichier1.docx', to_date('15-10-02','RR-MM-DD'), 'DEBU');
  
  insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1001, 'RAPPORT_2', '/fichier2.docx', to_date('15-10-01','RR-MM-DD'), 'DEBU');
  
  select * from TP2_RAPPORT;
  
  /************* Table TP2_CONFERENCE ********************/
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CONF_1', 'TITRE_1', to_date('15-02-02','RR-MM-DD'), to_date('15-03-03','RR-MM-DD'), 'YAOUNDÉ', '22 RUE DE DOUALA AKOUA');
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CONF_2', 'TITRE_2', to_date('15-01-02','RR-MM-DD'), to_date('15-04-03','RR-MM-DD'), 'MONTRÉAL', '40 RUE GALT MONTREAL CANADA');
    
  select * from TP2_CONFERENCE;
  
  
  /************* TP2_INSCRIPTION_CONFERENCE *************/
  
  insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
    values ('CONF_1', 15,  to_date('15-04-03','RR-MM-DD'), 1);
  
  insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
    values ('CONF_2', 20,  to_date('15-02-03','RR-MM-DD'), 1);
    
  select * from TP2_INSCRIPTION_CONFERENCE;
  
  
  /************ Question 1) c) requête d'insertion de la forme insert select qui copie la conférence CRIP2022 dans l’événement CRIP2023 en ajoutant 1 an aux dates.  ****************/
  
   insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
        values ('CRIP2022', 'TITRE_3', to_date('21-01-01','RR-MM-DD'), to_date('21-02-01','RR-MM-DD'), 'PARIS', '22 RUE DE LA MARINE MARCHANDE');
    
  
  insert into TP2_CONFERENCE(SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    select 'CRIP2023', 'CONFERENCE 2023', DATE_DEBUT_CON + interval '1' year, DATE_FIN_CON + interval '1' year, LIEU_CON, ADRESSE_CON
        from TP2_CONFERENCE
        where SIGLE_CONFERENCE =  'CRIP2022';
        
        
   /************ Question 1)d) 2 requêtes SQL qui effacent toutes les conférences et leurs inscriptions dont la date de fin est passée depuis plus de 500 jours.  ***/
   
   insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
        values ('CONF_4', 'TITRE_4', to_date('21-08-01','RR-MM-DD'), to_date('21-09-01','RR-MM-DD'), 'ROME', '22 RUE DE LA CATHEDRALE SAINT
    ');
    
    insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
        values ('CONF_4', 20,  to_date('21-08-15','RR-MM-DD'), 1);
    
    delete
        from (select *  from TP2_INSCRIPTION_CONFERENCE I, TP2_CONFERENCE C
          where C.SIGLE_CONFERENCE = I.SIGLE_CONFERENCE 
          and C.DATE_FIN_CON < (sysdate - 500) 
          );
          
   delete 
    from TP2_CONFERENCE where DATE_FIN_CON < (sysdate - 500);
   
  
  /************* Question 1)e) requête SQL qui met à jour le lieu et l’adresse d’une conférence. ***************/
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CON_3', 'Congrès sur la pauvreté au Cambodge', to_date('15-01-02','RR-MM-DD'), to_date('15-04-03','RR-MM-DD'), 'STADE INTER SCOLAIRE', '1940 RUE DU PAVILLON CENTRAL');
  
  update TP2_CONFERENCE
    set LIEU_CON = 'Théâtre de la cité universitaire',
        ADRESSE_CON = '2325, rue de la terrasse'
    where TITRE_CON = 'Congrès sur la pauvreté au Cambodge';
    
  select * from TP2_CONFERENCE;
  
  
  /******* Question 1)f) Donnez la requête SQL qui affiche les notifications dont le pays du membre attribué est "Cameroun".  ***********/

insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'Fabrice.Camara', FCT_GENERER_MOT_DE_PASSE(7), 'Camara', 'Fabrice', '4 Derek Park 4 Bamenda Yaounde', 'g1v 1j8', 'Cameroun', '(514)699-3569','(514)699-4569','Anglais','/membre4.png','Cfabrice.com','NASA','fabrice.camara@cipre.com', 5 ,1,0,1);
   
   insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_3_CAM', to_date('15-10-01','RR-MM-DD'), 'Non débutée', 'Note notification_3_CAM', 5, 25);

select N.NO_NOTIFICATION, N.NOTE_NOT
    from TP2_NOTIFICATION N, TP2_MEMBRE M
    where N.NO_MEM_ATTRIBUTION = M.NO_MEMBRE and M.PAYS_MEM = 'Cameroun';
   

 /************ Question 1)g)requête SQL qui affiche le titre des rapports débutés en ordre décroissant de date de dépôt pour le projet « Économie au Sud soudan » **/ 
 
 insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Économie au Sud soudan', 2500000.23, 'Débuté', to_date('22-01-01','RR-MM-DD'), to_date('22-09-23','RR-MM-DD'));
    
    insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1002, 'RAPPORT_ECO_SUD', '/fichier1002_1.docx', to_date('22-03-15','RR-MM-DD'), 'DEBU');
    
     insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1002, 'RAPPORT_ECO_SUD', '/fichier1002_2.docx', to_date('22-06-02','RR-MM-DD'), 'DEBU');
    
 
  select P.NO_PROJET, NO_RAPPORT, TITRE_RAP, DATE_DEPOT_RAP,NOM_PRO
   from TP2_PROJET P, TP2_RAPPORT R
   where P.NO_PROJET = R.NO_PROJET and NOM_PRO = 'Économie au Sud soudan' and R.CODE_ETAT_RAP = 'DEBU'
   order by DATE_DEPOT_RAP desc;
  
  
   /*********** Question 1)h) Afficher le nom et l’état des notifications créées par l’administrateur ayant pour nom «Thomas» et pour prénom «Paul»  */
   
    insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'thomas.paul', FCT_GENERER_MOT_DE_PASSE(7), 'Paul', 'Thomas', '10 boulevard Park 4 Sauthoff Circle', 'h3e 4t1', 'USA', '(514)699-1569','(514)199-4569','Anglais','/membre1.png','Jhondoes.com','NASA','thomas.paul@cipre.com', 5 ,1,0,1);
  
  
    insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_2_thomas', to_date('15-09-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 30, 10);
  
  
  /* QUestion 1)h)i) avec un in */
  
  select NOM_NOT, ETAT_NOT
    from TP2_NOTIFICATION N, TP2_MEMBRE M
    where N.NO_MEM_ADMIN_CREATION = M.NO_MEMBRE and NO_MEMBRE in (select NO_MEMBRE
                                                           from TP2_MEMBRE
                                                           where NOM_MEM = 'Paul' and PRENOM_MEM = 'Thomas');


  /**Question  1)h)ii)avec une jointure **/
  
   select NOM_NOT, ETAT_NOT
  from TP2_NOTIFICATION N, TP2_MEMBRE M
  where N.NO_MEM_ADMIN_CREATION = M.NO_MEMBRE and NO_MEMBRE = (select NO_MEMBRE
                                                           from TP2_MEMBRE
                                                           where NOM_MEM = 'Paul' and PRENOM_MEM = 'Thomas');
                                                           
 /* Question  1)h)iii) avec un exists */   
 
 select N.NOM_NOT, N.ETAT_NOT
  from TP2_NOTIFICATION N, TP2_MEMBRE M
  where N.NO_MEM_ADMIN_CREATION = M.NO_MEMBRE and M.NOM_MEM = 'Paul' and M.PRENOM_MEM = 'Thomas' and exists (select NO_MEMBRE
                                                           from TP2_MEMBRE
                                                           where NOM_MEM = 'Paul' and PRENOM_MEM = 'Thomas');
                                                           
      
 /************* Question 1)I) requête SQL qui affiche le prénom et le nom du membre séparé par un espace et le nombre de notifications qui lui sont attribuées  ****************/
 
 insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'nsteagalld', FCT_GENERER_MOT_DE_PASSE(7), 'Steagall', 'Nessi', '4086 Delladonna Parkway cresent', 'T9N 1v5', 'Albania', '(632)699-3500','(414)699-0102','Anglais','/membre3.png','si.edu','Wordware','nsteagalld@baidu.com', 25 ,0,0,1);
  
   insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'rroundsj', FCT_GENERER_MOT_DE_PASSE(7), 'Rounds', 'Rheba', '49 Crescent Oaks Circle palaba seflo', 'L9T 3K8', 'CANADA', '(514)682-4292','(514)334-7706','Francais','/membre4.png','earthlink.net','Twitternation','rroundsj@php.net', 25 ,0,0,1);
 
 insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_1', to_date('15-09-01','RR-MM-DD'), 'En cours', 'Note notification_1', 15, 25);
  
  insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_2', to_date('15-10-01','RR-MM-DD'), 'En cours', 'Note notification_2', 15, 30);
    
    
    select  M.NOM_MEM  || ' ' || M.PRENOM_MEM  as NOM_COMPLET_MEMBRE, count(N.NO_NOTIFICATION) as NB_NOTIFICATION
        from TP2_NOTIFICATION N, TP2_MEMBRE M
        where N.NO_MEM_ATTRIBUTION = M.NO_MEMBRE and N.ETAT_NOT = 'En cours'
        group by  M.NOM_MEM  || ' ' || M.PRENOM_MEM 
        order by NB_NOTIFICATION desc;
        
                                                  /******************* Question 1)j) afficher le nom et le prénom des membres qui ne sont pas directeur d’au moins deux projets. *********************/
    /******************** Question 1)j)i) Utilisant un not in. **************************/
    
    insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
        values (NO_PROJET_SEQ.nextval, 'Projet_3', 10000, 'Débuté', to_date('15-01-01','RR-MM-DD'), to_date('15-08-01','RR-MM-DD'));
    
    insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (15, 1002, 1);
        insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (25, 1001, 0);
    
      select M.NOM_MEM, M.PRENOM_MEM 
        from TP2_MEMBRE M, TP2_EQUIPE_PROJET P 
        where M.NO_MEMBRE = P.NO_MEMBRE and P.EST_DIRECTEUR_PRO = 1 and M.NO_MEMBRE 
        not in (select NO_MEMBRE 
                    from TP2_EQUIPE_PROJET 
                    where EST_DIRECTEUR_PRO = 1 
                    group by NO_MEMBRE 
                    having count(NO_PROJET) > 1);
    
     /******************** Question 1) j)ii) Utilisant un minus (équivalent Oracle de except) *******************/
     
    select distinct M.NOM_MEM, M.PRENOM_MEM 
        from TP2_MEMBRE M, TP2_EQUIPE_PROJET P 
            where M.NO_MEMBRE = (select NO_MEMBRE 
                                    from TP2_EQUIPE_PROJET 
                                    where EST_DIRECTEUR_PRO = 1
                                    minus
                                    select NO_MEMBRE 
                                        from TP2_EQUIPE_PROJET 
                                        where EST_DIRECTEUR_PRO = 1 
                                        group by NO_MEMBRE 
                                        having count(NO_PROJET) > 1 );   
         
    /******************** Question 1)j)iii) Utilisant un not exists *******************/
        
       select M.NOM_MEM, M.PRENOM_MEM 
        from TP2_MEMBRE M, TP2_EQUIPE_PROJET P 
            where M.NO_MEMBRE = P.NO_MEMBRE and P.EST_DIRECTEUR_PRO = 1 and not exists (select * 
                                                                                            from TP2_EQUIPE_PROJET P
                                                                                            where M.NO_MEMBRE = P.NO_MEMBRE and P.EST_DIRECTEUR_PRO = 1
                                                                                            group by P.NO_MEMBRE 
                                                                                            having count(P.NO_PROJET) > 1); 
                                                                                            
                                                                                            
    /*****Question 1)k) Donnez la requête SQL qui affiche en ordre alphabétique le nom des projets qui n’ont fait aucun rapport dans les 18 derniers mois (par rapport à sysdate)******/

insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Accord parfait', 200030.23, 'Débuté', to_date('20-06-01','RR-MM-DD'), to_date('25-09-01','RR-MM-DD'));

insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Accord imparfait', 200030.23, 'Débuté', to_date('21-06-01','RR-MM-DD'), to_date('24-09-01','RR-MM-DD'));
    
    
insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1003, 'RAPPORT_Accord_parfait', '/fichierAcord.docx', to_date('22-10-01','RR-MM-DD'), 'DEBU');
    
    
insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1004, 'RAPPORT_Accord_imparfait', '/fichierAcord2.docx', to_date('21-06-01','RR-MM-DD'), 'VERI');
    

select M.NOM_PRO, N.DATE_DEPOT_RAP 
	from TP2_PROJET M, TP2_RAPPORT N
	where M.NO_PROJET = N.NO_PROJET and N.DATE_DEPOT_RAP < (sysdate - interval '18' MONTH)
    order by M.NOM_PRO asc;                
    


 /***** Question 1)L) Pour afficher les courriels des administrateurs dont le courriel termine par .ca qui sont aussi des courriels de
de superviseurs sans téléphone. Une seule colonne sera affichée. ***/

insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
    NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'jackson.Mike', FCT_GENERER_MOT_DE_PASSE(7), 'Mike', 'Jackson', '9 Derek Park 4 Sauthoff Court', 'g3e 1j8', 'CANADA', '(418)699-3569','(418)699-4569','Anglais','/membreJack.png','MJackson.com','NASA','mike.jackson@ulaval.ca', 5 ,1,0,1);

/**** Question 1) L) i) Donnez la requête utilisant un intersect. **/

(select COURRIEL_MEM from TP2_MEMBRE
where EST_ADMINISTRATEUR_MEM = 1)
intersect
(select COURRIEL_MEM from TP2_MEMBRE
where COURRIEL_MEM like '%.ca');

/** Question 1) L) ii) Donnez la requête utilisant un exists. **/

select COURRIEL_MEM from TP2_MEMBRE M
where exists (select COURRIEL_MEM from TP2_MEMBRE N 
                where EST_ADMINISTRATEUR_MEM = 1 and M.COURRIEL_MEM = N.COURRIEL_MEM and COURRIEL_MEM like '%.ca');

/**Question 1) L iii) Donnez la requête utilisant un in **/

select COURRIEL_MEM 
    from TP2_MEMBRE
    where EST_ADMINISTRATEUR_MEM = 1 
    and COURRIEL_MEM in (select COURRIEL_MEM
                            from TP2_MEMBRE
                            where COURRIEL_MEM like '%.ca');      

    

/*****1)m) requête SQL définissant la vue affichant la hiérarchie des membres **********/

/*****1)m)i) requête SQL qui crée cette vue. ******/

create or replace view VUE_HIERACHIE_MEMBRE as 
    with TOUS_MANAGER( NO_MEMBRE, NO_MEMBRE_PATRON, NOM_MEM, COURRIEL_MEM, TEL_MEM, UTILISATEUR_MEM, NIVEAU ) as 
    ( select  NO_MEMBRE, NO_MEMBRE_PATRON, NOM_MEM, COURRIEL_MEM, TEL_MEM, UTILISATEUR_MEM, 1 
        from TP2_MEMBRE 
        union all
    select ENFANT.NO_MEMBRE, ENFANT.NO_MEMBRE_PATRON, ENFANT.NOM_MEM, ENFANT.COURRIEL_MEM, ENFANT.TEL_MEM, ENFANT.UTILISATEUR_MEM as chemin, NIVEAU+1
        from TOUS_MANAGER PERE, TP2_MEMBRE ENFANT 
        where PERE.NO_MEMBRE = ENFANT.NO_MEMBRE_PATRON  and ENFANT.NO_MEMBRE_PATRON is null)
        
    select lpad(' ', (NIVEAU) * 2, ' ') || COURRIEL_MEM as ARBRE, NO_MEMBRE, NO_MEMBRE_PATRON, NOM_MEM, TEL_MEM, sys_connect_by_path(UTILISATEUR_MEM, '/') as CHEMIN,
    level as NIVEAU
    from TOUS_MANAGER
    connect by nocycle prior NO_MEMBRE = NO_MEMBRE_PATRON 
    start with NO_MEMBRE_PATRON is not null
       
       with check option;
    /**** 1)m)ii   requête SQL qui affiche le contenu de la vue VUE_HIERACHIE_MEMBRE  ******/    
     select * from VUE_HIERACHIE_MEMBRE;
     
     /******** 1)m) iii) Ajout d' un enregistrement dans la table MEMBRE par la vue Oracle *******/
     
     /* L'insertion n'est pas possible à partir de la vue avec la version Oracle de l'abre
      /* Parce que la version oracle de l'arble ne permet la création de la vue.
      

                            
     
                                                /********************* Question n) requêtes de votre choix suivantes, qui s’appliquent au cas CRIPÉ ********************/
   /******************** Question 1)n)i) Une requête d’effacement de donnée: Supprimer une conference annulée *******************/
   
    insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
        values ('CONF_TEST', 'TITRE_SUPPRIMER', to_date('15-02-02','RR-MM-DD'), to_date('15-03-03','RR-MM-DD'), 'ABIDJAN', '22 RUE DE LA VERENDRILLE');
   
    delete from TP2_CONFERENCE where SIGLE_CONFERENCE = 'CONF_TEST'; 
   
   /******************** Question 1)n)ii) Une requête de mise à jour de donnée:  Activer le compte d'un usager qui s'est inscrit sur la plateforme CIPRÉ  ******************/
   
   update TP2_MEMBRE
   	set EST_APPOUVEE_INSCRIPTION_MEM = 1
   	where NO_MEMBRE = 10;
    
    
    /*********Question 1)n)iii) creation d'un nouveau rapport mis à l'état vérifié en se basant sur les informations d'un ancien rapport *****/
 
    insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
        select NO_RAPPORT_SEQ.nextval, NO_PROJET, TITRE_RAP, '/'|| TITRE_RAP || '.docx',DATE_DEPOT_RAP,'VERI'
        from TP2_RAPPORT
        where NO_RAPPORT = 1003;     
            
    
    /** Question n)iv) Une requète d'ajout de colonne à une table : ajouter s'il y a lieu le nom de l'organisateur de la conference **/
    
	 alter table TP2_CONFERENCE
        add ORGANISATEUR_CONF varchar2(40) null;
    
    
    /*************************** 2)a) la requête SQL qui crée un déclencheur en ajout et modification sur la table EQUIPE_PROJET et qui s’assure que pour un projet, il y a au plus un membre qui est directeur.  ********************************************/
  
       create or replace trigger TRG_BIU_DIRECTEUR_PROJET
            before insert or update of EST_DIRECTEUR_PRO on TP2_EQUIPE_PROJET
            for each row 
            when (NEW.EST_DIRECTEUR_PRO = 1)
       declare
            V_NB_DIRECTEUR_PROJET number(1);
      begin            
            if :OLD.EST_DIRECTEUR_PRO  = 1 then
                raise_application_error(-20052, 'Ce projet à déjà un directeur');
            end if;
                              
            if :OLD.EST_DIRECTEUR_PRO is null  then 
                select count(*) into V_NB_DIRECTEUR_PROJET
                    from TP2_EQUIPE_PROJET
                where NO_PROJET = :NEW.NO_PROJET and EST_DIRECTEUR_PRO = 1 ;                
            else 
                dbms_output.put_line('OIF3- ' || :OLD.EST_DIRECTEUR_PRO || ' - ' || :NEW.EST_DIRECTEUR_PRO );
                select count(*) into V_NB_DIRECTEUR_PROJET
                    from TP2_EQUIPE_PROJET
                where NO_PROJET = :NEW.NO_PROJET and EST_DIRECTEUR_PRO = 1 ;
            end if;
            
            if V_NB_DIRECTEUR_PROJET > 0 then
                raise_application_error(-20052, 'Ce projet à déjà un directeur');
                end if;
    end TRG_BIU_DIRECTEUR_PROJET;
    /
    
    
    insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
        values (NO_PROJET_SEQ.nextval, 'Projet_4', 1000, 'Débuté', to_date('15-01-01','RR-MM-DD'), to_date('15-08-01','RR-MM-DD'));
        
    insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (25, 1006, 0);
    
    insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (15, 1006, 1);
    
    insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (20, 1006, 1);
    
    
    update TP2_EQUIPE_PROJET set EST_DIRECTEUR_PRO = 0 where NO_PROJET = 1002 and NO_MEMBRE = 15;
    
    update TP2_EQUIPE_PROJET set EST_DIRECTEUR_PRO = 1 where NO_PROJET = 1006 and NO_MEMBRE = 15;
    

   	
   	/******************* Question 2) b) Fonction FCT_MOYENNE_MNT_ALLOUE qui reçoit en paramètre un numéro de membre et retourne le montant moyen alloué pour tous ses projets **************/
   	
    create or replace function FCT_MOYENNE_MNT_ALLOUE(V_NO_MEMBRE in number) return number
    is 
        V_MNT_MOYEN TP2_PROJET.MNT_ALLOUE_PRO%type;
    begin
        select avg(P.MNT_ALLOUE_PRO) into V_MNT_MOYEN
            from TP2_PROJET P, TP2_EQUIPE_PROJET E
            where P.NO_PROJET = E.NO_PROJET and E.NO_MEMBRE = V_NO_MEMBRE
            group by E.NO_MEMBRE;
            return V_MNT_MOYEN;
        
    end FCT_MOYENNE_MNT_ALLOUE;
    /
    
    select FCT_MOYENNE_MNT_ALLOUE(20) from DUAL;
    
    /******************** Question 2) c) procédure stockée SP_ARCHIVER_PROJET qui reçoit en paramètre une date et déplace tous les projets dans une nouvelle table PROJET_ARCHIVE et leurs rapports dans la table RAPPORT_ARCHIVE. **********/
    
    /******************** Creation des Tables PROJET_ARCHIVE et RAPPORT_ARCHIVE ******************/
    
    drop table TP2_PROJET_ARCHIVE cascade constraints;
    drop table TP2_RAPPORT_ARCHIVE cascade constraints;
    
    create table TP2_PROJET_ARCHIVE (
      NO_PROJET number(10) not null, 
      NOM_PRO varchar2(30) not null,
      MNT_ALLOUE_PRO number(9,2) default 0.0 not null, 
      STATUT_PRO varchar2(30) default 'Initiale' not null,
      DATE_DEBUT_PRO date not null,
      DATE_FIN_PRO date not null,
      constraint PK_TP2_PROJET_ARCHIVE primary key (NO_PROJET)
);
    
    create table TP2_RAPPORT_ARCHIVE (
      NO_RAPPORT number(10) not null,
      NO_PROJET number(10) not null,
      TITRE_RAP varchar2(30) not null,
      NOM_FICHIER_RAP varchar2(200) not null, 
      DATE_DEPOT_RAP date not null,
      CODE_ETAT_RAP char(4) not null,
      constraint PK_TP2_RAPPORT_ARCHIVE primary key (NO_RAPPORT),
      constraint FK_TP2_RAPPORT_ARCHIVE_NO_PROJET foreign key (NO_PROJET) 
                    references TP2_PROJET_ARCHIVE (NO_PROJET),
      constraint FK_TP2_RAPPORT_ARCHIVE_CODE_ETAT_RAP foreign key (CODE_ETAT_RAP) 
                    references TP2_RAPPORT_ETAT (CODE_ETAT_RAP)	
);

    /********* Création de la Procédure stockée SP_ARCHIVER_PROJET *************/
    create or replace procedure SP_ARCHIVER_PROJET (V_DATE_FIN_PROJET date) is 
        V_DATE_2_ANS date;
        
    begin 
        select (TRUNC(SYSDATE) - INTERVAL '2' YEAR) into V_DATE_2_ANS from DUAL ;   

        declare 
            E_DATE_INVALIDE exception;

            cursor ANCIEN_PROJET_CURSEUR is
                select NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO 
                    from TP2_PROJET
                    where DATE_FIN_PRO < V_DATE_FIN_PROJET  and STATUT_PRO = 'Terminé'
                    order by NO_PROJET asc;
                    
        begin
        
         if V_DATE_FIN_PROJET > V_DATE_2_ANS then
            raise E_DATE_INVALIDE;
            end if;
        
            for ENR_PROJET in ANCIEN_PROJET_CURSEUR
            loop 
                insert into TP2_PROJET_ARCHIVE( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO) 
                    values ( ENR_PROJET.NO_PROJET, ENR_PROJET.NOM_PRO, ENR_PROJET.MNT_ALLOUE_PRO, ENR_PROJET.STATUT_PRO, ENR_PROJET.DATE_DEBUT_PRO, ENR_PROJET.DATE_FIN_PRO);
                    
                 insert into TP2_RAPPORT_ARCHIVE (NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
                    select NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP
                        from TP2_RAPPORT
                        where NO_PROJET = ENR_PROJET.NO_PROJET;
                
                
                delete from TP2_RAPPORT where NO_PROJET = ENR_PROJET.NO_PROJET;
                
                delete from TP2_PROJET where NO_PROJET = ENR_PROJET.NO_PROJET;
                
                
            end loop;
                       
        exception
            When E_DATE_INVALIDE then
                dbms_output.put_line('La date fournie dois être veille que 2 ans');
        end;
        
end SP_ARCHIVER_PROJET;
  /

 insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
        values (NO_PROJET_SEQ.nextval, 'Projet_5', 10000, 'Terminé', to_date('15-01-01','RR-MM-DD'), to_date('15-08-01','RR-MM-DD'));       
        
    insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
        values (NO_PROJET_SEQ.nextval, 'Projet_6', 11000, 'Terminé', to_date('11-01-01','RR-MM-DD'), to_date('11-06-15','RR-MM-DD'));
        
    insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
        values ( NO_RAPPORT_SEQ.nextval, 1004, 'RAPPORT_5', '/fichier_RAP_5.docx', to_date('15-06-02','RR-MM-DD'), 'DEBU');
  
    insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
        values ( NO_RAPPORT_SEQ.nextval, 1005, 'RAPPORT_6', '/fichier_RAP_6.docx', to_date('11-03-10','RR-MM-DD'), 'DEBU');
        

  execute SP_ARCHIVER_PROJET(to_date('15-10-01','RR-MM-DD'));
  
  
  /**************** 2)e) 3 requêtes PL/SQL de votre choix (1 stored procedure, 1 function et 1 trigger) *****************/
   /**************** 2)e)i) requêtes PL/SQL stored procedure pour la réinitialisation d' un mot de passe temporaire à un utilisateur *****************/
  create or replace procedure SP_RÉINITIALISER_MOT_DE_PASSE (V_NO_MEMBRE number, V_NB_CARACTERE number) is
  
    begin        
        update TP2_MEMBRE
            set MOT_DE_PASSE_MEM = FCT_GENERER_MOT_DE_PASSE(V_NB_CARACTERE)
            where NO_MEMBRE = V_NO_MEMBRE;
        
  end SP_RÉINITIALISER_MOT_DE_PASSE;
  /
   
   execute SP_RÉINITIALISER_MOT_DE_PASSE(30, 6);  
   execute SP_RÉINITIALISER_MOT_DE_PASSE(25, 19);  
   
   
   /**************** 2) e) ii) requêtes PL/SQL une fonction pour afficher la date d'une conference programmée *****************/
    
   insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('COOP', 'Sommet des coop', to_date('22-12-02','RR-MM-DD'), to_date('22-12-10','RR-MM-DD'), 'QUEBEC', '2325 RUE DELGADO QUEBEC CANADA');
    
    
   create or replace function FCT_DATE_CONFERENCE (P_I_SIGLE_CONFERENCE in varchar2) return date
    is
        V_DATE_DEBUT_CON date;
    begin
        select DATE_DEBUT_CON into V_DATE_DEBUT_CON from TP2_CONFERENCE
            where SIGLE_CONFERENCE = P_I_SIGLE_CONFERENCE;

        return V_DATE_DEBUT_CON;
        
    end FCT_DATE_CONFERENCE;
    /
    
    select FCT_DATE_CONFERENCE('COOP') from DUAL;
   
   
   /********************************2) e) iii) requêtes PL/SQL un trigger qui empêche l'inscription à une conférence qui n'existe pas  *****************************************/
   
    create or replace trigger TRG_BI_INSCRIPTION_CONFERENCE
            before insert on TP2_INSCRIPTION_CONFERENCE
            for each row 
       declare
            V_EXISTE_CONFERENCE number(1);
      begin   
            select count(*) into V_EXISTE_CONFERENCE
                    from TP2_CONFERENCE
                where SIGLE_CONFERENCE = :NEW.SIGLE_CONFERENCE;    
                           
            if V_EXISTE_CONFERENCE < 1 then
                raise_application_error(-20053,  'La conférence n'' existe pas ');
            end if;
    end TRG_BIU_DIRECTEUR_PROJET;
    /
    
     insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
    values ('NOT_EXIST', 15,  to_date('15-04-03','RR-MM-DD'), 1);
   
   
   
   /************************ 3) a)Indexation * ******************************************/
   /************************3) a) i)requêtes SQL dont vous auriez besoin pour créer les Index nécessaires pour améliorer les performances de ces recherches des membre  ******************************************/
     /* 
      drop index IDX_TP2_MEMBRE_INSTITUTION_MEM;
      drop index IDX_TP2_MEMBRE_INSTITUTION_NOM_MEM;
      drop index IDX_TP2_MEMBRE_NOM_INSTITUTION_MEM;
      drop index IDX_TP2_MEMBRE_NOM_PRENOM_MEM;
      drop index IDX_TP2_MEMBRE_PRENOM_NOM_MEM;
      */
       explain plan for
            select * from TP2_MEMBRE where NOM_MEM = 'Doe' and PRENOM_MEM = 'John' order by INSTITUTION_MEM;
             select * from table(dbms_xplan.display);
        explain plan for
            select * from TP2_MEMBRE where PRENOM_MEM = 'John' and NOM_MEM = 'Doe' order by INSTITUTION_MEM;
            select * from table(dbms_xplan.display);
        explain plan for
            select * from TP2_MEMBRE where INSTITUTION_MEM='NASA' and NOM_MEM = 'Doe' order by INSTITUTION_MEM;
            select * from table(dbms_xplan.display);
        explain plan for
            select * from TP2_MEMBRE where NOM_MEM = 'Doe' and INSTITUTION_MEM='NASA' order by INSTITUTION_MEM ;
            select * from table(dbms_xplan.display);
            
      
        create index IDX_TP2_MEMBRE_INSTITUTION_MEM
            on TP2_MEMBRE (INSTITUTION_MEM);  
            
        create index IDX_TP2_MEMBRE_INSTITUTION_NOM_MEM
            on TP2_MEMBRE (INSTITUTION_MEM, NOM_MEM); 
            
        create index IDX_TP2_MEMBRE_NOM_INSTITUTION_MEM
            on TP2_MEMBRE (NOM_MEM, INSTITUTION_MEM); 
        
        create index IDX_TP2_MEMBRE_NOM_PRENOM_MEM
            on TP2_MEMBRE (NOM_MEM, PRENOM_MEM); 
            
        create index IDX_TP2_MEMBRE_PRENOM_NOM_MEM
            on TP2_MEMBRE (PRENOM_MEM, NOM_MEM);
            
            
        explain plan for
            select * from TP2_MEMBRE where NOM_MEM = 'Doe' and PRENOM_MEM = 'John' order by INSTITUTION_MEM;
            select * from table(dbms_xplan.display); 
        explain plan for
            select * from TP2_MEMBRE where PRENOM_MEM = 'John' and NOM_MEM = 'Doe' order by INSTITUTION_MEM;
            select * from table(dbms_xplan.display);
        explain plan for
            select * from TP2_MEMBRE where INSTITUTION_MEM='NASA' and NOM_MEM = 'Doe' order by INSTITUTION_MEM;
            select *from table(dbms_xplan.display);
        explain plan for
            select * from TP2_MEMBRE where NOM_MEM = 'Doe' and INSTITUTION_MEM='NASA' order by INSTITUTION_MEM;
            select * from table(dbms_xplan.display);

            
   /************************************ 3) a) ii) 1) Justifions nos choix Pour les index choisis  ***********************************/       
    
     /* 
        Les combinaison des champs NOM_MEM et PRENOM_MEM permet de créer deux index différents notamment 
        IDX_TP2_MEMBRE_NOM_PRENOM_MEM et IDX_TP2_MEMBRE_PRENON_NOM_MEM qui permettent de retourner les informations d'un membre avec la condition du nom et du prénom plus rapidement.
        Aussi on ne modifife pas souvent les noms des membres donc les mises à jour sont mois férquente sur les noms des membres un index sur ces champs ne posera pas de problème de performances.
        
        Les combinaison des champs NOM_MEM et INSTITUTION_MEM permet de créer deux index différents notamment 
        IDX_TP2_MEMBRE_INSTITUTION_NOM_MEM et IDX_TP2_MEMBRE_NOM_INSTITUTION_MEM qui permettent de retourner les information d'un membre avec la condition du nom et du prénom rapidement.
        
        Enfin, les resultats étant groupé par INSTITUTION_MEM et INSTITUTION_MEM n'étant pas une clé alternative de la table MEMBRE, ceci nous permet d'avoir un autre index sur ce champ que 
        nous avons nommé IDX_TP2_MEMBRE_INSTITUTION_MEM qui permet de recupérer les information des membres par rapport à leur institution rapidement.
    */
    
    
   /************************************ 3) a) ii) 2) Justifions nos  choix pour les index non choisis   ***********************************/  
    
   /*
       Un Index sur le champ NOM_PRO de la table TP2_PROJET n'aurait pas été utilement exploitable pour trouver les informations des membres.
       Aussi, les attributs de la table TP2_PROJET ne sont assez nombreux pour justifier la création d'un index sur cette table.
   */
   
   
        /****** Question 3)a)iii)1)Trois autres situations avec explication où l'index est nécessaire pour CRIPÉ
        
            SITUATION 1 : Recherche d'une conférence 
            EXPLICATION : lorsqu'un membre cherche dans le système une conférence, il se sert du titre de la conference et du lieu de la conférence
                   
            SITUATION 2 : Rechercher un rapport 
            EXPLICATION : lorsqu'un membre cherche dans le système un rapport, il se sert du nom du fichier rapport et de la date de dépot du rapport
            
            SITUATION 3 : Recherche d'un projet
            EXPLICATION : Lorsqu'un membre cherche un projet, il se sert du nom du projet et du montant alloué au dit projet
        
        *******/
        
        /****** Question 3)a)iii)2)Les requètes d'index pour chacune des trois situations *******/ 
        /******SITUATION 1 : Recherche d'une conférence *******/
        
        /*
        drop index IDX_TP2_CONFERENCE_TITRE_LIEU_CON;
        drop index IDX_TP2_CONFERENCE_LIEU_TITRE_CON;
        drop index IDX_TP2_CONFERENCE_TITRE_CON;
        drop index IDX_TP2_RAPPORT_NOM_FICHIER_DATE_DEPOT_RAP;
        drop index IDX_TP2_RAPPORT_DATE_DEPOT_NOM_FICHIER_RAP;
        drop index IDX_TP2_DATE_NOM_FICHIER_RAP;
        drop index IDX_TP2_PROJET_NOM_MONTANT_PRO;
        drop index IDX_TP2_PROJET_MONTANT_NOM_PRO;
      */
        
        
        create index IDX_TP2_CONFERENCE_TITRE_LIEU_CON
        on TP2_CONFERENCE(TITRE_CON, LIEU_CON);
        
        create index IDX_TP2_CONFERENCE_LIEU_TITRE_CON
        on TP2_CONFERENCE(LIEU_CON, TITRE_CON);
        
        
        /******SITUATION 2 : Recherche d'un rapport *******/
        
        create index IDX_TP2_RAPPORT_NOM_FICHIER_DATE_DEPOT_RAP
            on TP2_RAPPORT (NOM_FICHIER_RAP, DATE_DEPOT_RAP);
            
        create index IDX_TP2_RAPPORT_DATE_DEPOT_NOM_FICHIER_RAP
        on TP2_RAPPORT (DATE_DEPOT_RAP, NOM_FICHIER_RAP);
        
        
        /******SITUATION 3 : Recherche d'un projet *******/
        create index IDX_TP2_PROJET_NOM_MONTANT_PRO
        on TP2_PROJET (NOM_PRO, MNT_ALLOUE_PRO);
        
        create index IDX_TP2_PROJET_MONTANT_NOM_PRO
        on TP2_PROJET (MNT_ALLOUE_PRO, NOM_PRO);




    /*****Indexation et amélioration des performances***/
    
    /*****question 3) b) i) 2 techniques différentes pour dénormaliser le modèle****/
    /*** Technique 1: 7.1 Combinaison des associations 1:1
    
        Nous constatons qu'il y a une relation de type 1:1 entre les tables TP2_EQUIPE_PROJET et TP2_PROJET
        on peut donc denormaliser en combinant ces deux tables afin d'obtenir une seule table qu'on pourrait nommer
        TP2_PROJET cela va  donc améliorer la performance (en ce qui concerne les recherches et les redondances), 
        parce toutes les données seront centralisées dans une seule table.
        
    *****/
    
    /*** Technique 2 : 7.2.2 Dupliquer les attributs non clés dans une association 1:* 
        Nous constatons qu'il y a une relation de type 1:* entre les tables TP2_RAPPORT et TP2_RAPPORT_ETAT 
        on peut donc denormaliser en dupliquant les attributs de la TP2_RAPPORT_ETAT dans la table TP2_RAPPORT afin d'obtenir une table TP2_RAPPORT plus complète.
        Cela va donc améliorer la performance (en ce qui concerne la reduction des jointures).
        De sorte que si nous souhaitons accéder à une information dans la table TP2_RAPPORT_ETAT, nous puissions y accéder dans la table TP2_RAPPORT (sans faire de jointure).
    ****/
    
    /********************************** 3) b) ii)requêtes SQL qui vous ont permis de modifier les structures des tables concernées  ***************/
     
     /*** Technique 1: 7.1 **/
    alter table TP2_PROJET
        add NO_MEMBRE number(10) null;
        
    alter table TP2_PROJET
        add EST_DIRECTEUR_PRO number(1) default 0 null;
    
    alter table TP2_PROJET
        add constraint FK_TP2_PROJET_NO_MEMBRE foreign key (NO_MEMBRE) 
				references TP2_MEMBRE (NO_MEMBRE); 
     
    /*** Technique 2 : 7.2.2 **/
    alter table TP2_RAPPORT
        add NOM_ETAT_RAP varchar2(30) null;
        
  /********************************** 3) b) iii) Requêtes de déclencheur PL/SQL nécessaires pour compenser la dénormalisation et conserver l'intégrité des données. ***************/
  create or replace trigger TRG_BIU_TP2_RAPPORT   
    before insert or update on TP2_RAPPORT   
    for each row
    declare 
        V_ETAT_RAP varchar2(30);
    begin 
        select NOM_ETAT_RAP into V_ETAT_RAP
        from TP2_RAPPORT_ETAT
        where CODE_ETAT_RAP = :NEW.CODE_ETAT_RAP;
        
        :NEW.NOM_ETAT_RAP := V_ETAT_RAP;
        
    end TRG_BIU_TP2_RAPPORT ;
    /
    
    
    create or replace procedure SP_ACTIVER_TRIGGER(P_I_NOM_TRIGGER in varchar2)
    is
    pragma AUTONOMOUS_TRANSACTION;
    begin
        execute immediate 'alter trigger ' || P_I_NOM_TRIGGER || ' enable';
    end;
    /
    
    create or replace procedure SP_DESACTIVER_TRIGGER(P_I_NOM_TRIGGER in varchar2)
    is
    pragma AUTONOMOUS_TRANSACTION;
    begin
        execute immediate 'alter trigger ' || P_I_NOM_TRIGGER || ' disable';
    end;
    /
    
    
    create or replace trigger TRG_BU_TP2_RAPPORT_ETAT  
    before update on TP2_RAPPORT_ETAT 
    for each row
    declare 
    begin
        SP_DESACTIVER_TRIGGER('TRG_BIU_TP2_RAPPORT');
        
        update TP2_RAPPORT
            set NOM_ETAT_RAP = :NEW.NOM_ETAT_RAP
            where CODE_ETAT_RAP = :NEW.CODE_ETAT_RAP;
            
        SP_ACTIVER_TRIGGER('TRG_BIU_TP2_RAPPORT');
        
    end TRG_BU_TP2_RAPPORT_ETAT;
    /
   
    insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP, NOM_ETAT_RAP)
        values ( NO_RAPPORT_SEQ.nextval, 1001, 'RAPPORT_2', '/fichierTRIGGER.docx', to_date('15-10-01','RR-MM-DD'), 'DEBU', 'Approuvé');
            
        
       
  /********************************** 3) b) iv) requêtes SQL pour déplacer/copier les données de vos tables dénormalisées ***************/  
       
    /*** Technique 1: 7.1 **/                                          
  /*  update TP2_PROJET P set P.NO_MEMBRE = (select E.NO_MEMBRE 
                                                from TP2_EQUIPE_PROJET E
                                                where E.NO_PROJET = E.NO_PROJET );
                                                
    update TP2_PROJET P set P.EST_DIRECTEUR_PRO = (select E.EST_DIRECTEUR_PRO 
                                                from TP2_EQUIPE_PROJET E
                                                where P.NO_PROJET = E.NO_PROJET);      */   
                                                
    create or replace procedure SP_COPIER_DONNEE is 
        
    begin  

        declare 
            cursor DONNEE_TABLE_EQUIPE_PROJET_CURSEUR is
                select * 
                    from  TP2_EQUIPE_PROJET;                   
        begin

            for ENR_PROJET in DONNEE_TABLE_EQUIPE_PROJET_CURSEUR
            loop 
                insert into TP2_PROJET( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO, NO_MEMBRE, EST_DIRECTEUR_PRO) 
                    select NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO, ENR_PROJET.NO_MEMBRE, ENR_PROJET.EST_DIRECTEUR_PRO
                        from TP2_PROJET
                        where NO_PROJET = ENR_PROJET.NO_PROJET;                                    
            end loop;
        
    end;
end SP_COPIER_DONNEE;
/
  
  execute SP_COPIER_DONNEE;
  
                                                
    drop table TP2_EQUIPE_PROJET cascade constraints;
      
    /*** Technique 2 : 7.2.2 **/                                                                   
    update TP2_RAPPORT R
        set R.NOM_ETAT_RAP = (select E.NOM_ETAT_RAP
                                    from TP2_RAPPORT_ETAT E
                                    where R.CODE_ETAT_RAP = E.CODE_ETAT_RAP);
    
    
    
    
    
    
    
