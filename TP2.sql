                                                /**** TP2 *******/ 



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
  constraint PK_TP2_MEMBRE primary key (NO_MEMBRE)

/** table reference  clé étrangère inexistante à touver

  constraint FK_MEMBRE foreign key (NO_MEMBRE_PATRON) 
				references MEMBRE (NO_MEMBRE_PATRON) on delete set null
**/
	
 );



create table TP2_PROJET (
  NO_PROJET number(10) not null, 
  NOM_PRO varchar2(30) not null,
  MNT_ALLOUE_PRO number(6,2) default 0.0 not null, 
  STATUT_PRO varchar2(30) default 'Initiale' not null,
  DATE_DEBUT_PRO date not null,
  DATE_FIN_PRO date not null,
  constraint PK_TP2_PROJET primary key (NO_PROJET),
  constraint CT_STATUT_PRO check (STATUT_PRO in ('Initiale', 'Intermédiaire', 'Finale')),
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
  ETAT_NOT varchar2(30) default 'Débuté' not null,
  NOTE_NOT varchar2(1000) null,
  NO_MEM_ADMIN_CREATION number(10) not null,
  NO_MEM_ATTRIBUTION number(10) not null,
  constraint PK_TP2_NOTIFICATION primary key (NO_NOTIFICATION),
  constraint CT_ETAT_NOT check (ETAT_NOT in ('Débuté', 'En vérification', 'En correction', 'Approuvé'))
  
/* table reference  clé étrangère inexistante à touver

  constraint FK_NOTIFICATION_NO_MEM_ADMIN_CREATION foreign key (NO_MEM_ADMIN_CREATION) 
				references TP1_MEMBRE (NO_MEM_ADMIN_CREATION),
  constraint FK_NOTIFICATION foreign key (NO_MEM_ATTRIBUTION) 
				references TP1_PROJET (NO_MEM_ATTRIBUTION),
  */
  
);


create table TP2_RAPPORT_ETAT (
  CODE_ETAT_RAP char(4) not null,
  NOM_ETAT_RAP varchar2(30) not null,
  constraint PK_TP2_RAPPORT_ETAT primary key (CODE_ETAT_RAP)
  
);

create table TP2_RAPPORT (
  NO_RAPPORT number(10) not null,
  NO_PROJET number(10) not null,
  TITRE_RAP varchar2(30) not null,
  NOM_FICHIER_RAP varchar2(200) not null, 
  DATE_DEPOT_RAP date not null,
  CODE_ETAT_RAP char(4) not null,
  constraint PK_TP2_RAPPORT primary key (NO_RAPPORT),
  constraint FK_TP2_RAPPORT_NO_PROJET foreign key (NO_PROJET) 
				references TP2_PROJET (NO_PROJET),
  constraint FK_TP2_RAPPORT_CODE_ETAT_RAP foreign key (CODE_ETAT_RAP) 
				references TP2_RAPPORT_ETAT (CODE_ETAT_RAP)
	
);


create table TP2_CONFERENCE (
  SIGLE_CONFERENCE varchar2(10) not null,
  TITRE_CON varchar2(30) not null,
  DATE_DEBUT_CON date not null,
  DATE_FIN_CON date not null,
  LIEU_CON varchar2(30) not null,
  ADRESSE_CON varchar2(40) not null,
  constraint PK_TP2_CONFERENCE primary key (SIGLE_CONFERENCE),
  constraint CT_LONGUEUR_ADRESSE_CON check ( length(ADRESSE_CON) > 20 and length (ADRESSE_CON) < 40)

);

create table TP2_INSCRIPTION_CONFERENCE (
  SIGLE_CONFERENCE varchar2(10) not null,
  NO_MEMBRE number(10) not null, 
  DATE_DEMANDE_INS date not null,
  STATUT_APPROBATION_INS varchar2(30) not null,   /* default 'Non débutée' not null,     ( il faut trouver les valeurs possible de STATUT_APPROBATION_INS) */
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
    start with 1000
    increment by 1;
    
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
  values ( NO_MEMBRE_SEQ.nextval, 'admin', 'admin', 'admin', 'admin', 'admin hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j6', 'admin', '(514)699-2569','(514)699-2569','francais','admin','admin','admin','admin@cipre.com', 1500 ,1,0,1);
  
  
      insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
  values ( NO_MEMBRE_SEQ.nextval, 'superviseur', 'superviseur', 'superviseur', 'superviseur', 'superviseur hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j7', 'cipre', '(514)699-2569','(514)699-2569','francais','superviseur','superviseur','superviseur','superviseur@cipre.com', 1500 ,0,1,1);
  
  select * from VUE_ADMINISTRATEUR;
    
  select * from VUE_SUPERVISEUR;
  
  
  
  /******* création de la function pour la génération des mot de passe des membres *******/
  
 create or replace function FCT_GENERER_MOT_DE_PASSE(V_NB_CARACTERE in number) return varchar2
  is
    V_NB_CARACTERE_FINALE number := 0;
    V_MOT_DE_PASSE varchar2 (14);
    V_MOT_DE_PASSE_temp varchar2 (14);
    V_QUIT_LOOP number (1) := 0;
    
  begin 
  
    if V_NB_CARACTERE < 7 then
        V_NB_CARACTERE_FINALE := 7;
    end if;
        
    if V_NB_CARACTERE > 14 then
        V_NB_CARACTERE_FINALE := 14;
    end if;
     
    while V_QUIT_LOOP = 0
        loop
            V_MOT_DE_PASSE := dbms_random.string('a', V_NB_CARACTERE-4) || substr('!?&$/|#', dbms_random.value (1, 8), 1 ) || dbms_random.string('x', 1)  || dbms_random.string('l', 1) ||  TRUNC(DBMS_RANDOM.value(1,9));
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
  
  
  /******* Question 1b) 2 requêtes d’insertion SQL valides pour chaque table du modèle. Pour la table des MEMBRE, utilisez la fonction de la question 2d)  ***********/
  
  insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
  values ( NO_MEMBRE_SEQ.nextval, 'jhon.doe', 'admin', 'admin', 'admin', 'admin hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j6', 'admin', '(514)699-2569','(514)699-2569','francais','admin','admin','admin','admin@cipre.com', 1500 ,1,0,1);
