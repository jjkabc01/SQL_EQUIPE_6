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
  MNT_ALLOUE_PRO number(9,2) default 0.0 not null, 
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
  ETAT_NOT varchar2(30) default 'Non débutée' not null,
  NOTE_NOT varchar2(1000) null,
  NO_MEM_ADMIN_CREATION number(10) not null,
  NO_MEM_ATTRIBUTION number(10) not null,
  constraint PK_TP2_NOTIFICATION primary key (NO_NOTIFICATION),
  constraint CT_ETAT_NOT check (ETAT_NOT in ('Non débutée', 'En cours', 'À approuver ', 'Terminée'))
  
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
  TITRE_CON varchar2(40) not null,
  DATE_DEBUT_CON date not null,
  DATE_FIN_CON date not null,
  LIEU_CON varchar2(40) not null,
  ADRESSE_CON varchar2(40) not null,
  constraint PK_TP2_CONFERENCE primary key (SIGLE_CONFERENCE),
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
  values ( NO_MEMBRE_SEQ.nextval, 'admin', 'admin', 'admin', 'admin', 'admin hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j6', 'admin', '(514)699-2569','(514)699-2569','francais','admin','admin','admin','admin@cipre.com', 1500 ,1,0,1);
  
  
      insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
  values ( NO_MEMBRE_SEQ.nextval, 'superviseur', 'superviseur', 'superviseur', 'superviseur', 'superviseur hdhdg gdgd gdgg dggd ggdgd', 'h3e 1j7', 'cipre', '(514)699-2569','(514)699-2569','francais','superviseur','superviseur','superviseur','superviseur@cipre.com', 1500 ,0,1,1);
  
  select * from VUE_ADMINISTRATEUR;
    
  select * from VUE_SUPERVISEUR;
  
  

  /*********** Question 2b) Donnez la requête SQL qui crée une fonction nommée FCT_GENERER_MOT_DE_PASSE pour la génération des mot de passe des membres ***********/
  
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
  
  /************ Table TP2_MEMBRE ********************/
  
  insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'john.doe', FCT_GENERER_MOT_DE_PASSE(7), 'Doe', 'John', '4 Derek Park 4 Sauthoff Circle', 'h3e 1j8', 'USA', '(514)699-3569','(514)699-4569','Anglais','/membre1.png','Jhondoes.com','NASA','john.doe@cipre.com', 1550 ,1,0,1);
  
   insert into TP2_MEMBRE( NO_MEMBRE,  UTILISATEUR_MEM, MOT_DE_PASSE_MEM, NOM_MEM, PRENOM_MEM, ADRESSE_MEM, CODE_POSTAL_MEM, PAYS_MEM, TEL_MEM, FAX_MEM, LANGUE_CORRESPONDANCE_MEM,
  NOM_FICHIER_PHOTO_MEM, ADRESSE_WEB_MEM, INSTITUTION_MEM, COURRIEL_MEM, NO_MEMBRE_PATRON, EST_ADMINISTRATEUR_MEM, EST_SUPERVISEUR_MEM, EST_APPOUVEE_INSCRIPTION_MEM) 
    values ( NO_MEMBRE_SEQ.nextval, 'Thayne.Alpe', FCT_GENERER_MOT_DE_PASSE(7), 'Thayne', 'Alpe', '46 Straubel Pass 4 Sauthoff Circle', 'h2e 1j8', 'CANADA', '(514)299-3569','(514)399-4569','Francais','/membre2.png','earthlink.net','CRA','talpe0@earthlink.net', 1550 ,0,1,1);
  
  select * from TP2_MEMBRE;
  
  /****************** Table TP2_PROJET ******************/
  
  insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Projet_1', 3500000.23, 'Initiale', to_date('15-01-01','RR-MM-DD'), to_date('15-08-01','RR-MM-DD'));
  
  insert into TP2_PROJET ( NO_PROJET, NOM_PRO, MNT_ALLOUE_PRO, STATUT_PRO, DATE_DEBUT_PRO, DATE_FIN_PRO ) 
    values (NO_PROJET_SEQ.nextval, 'Projet_2', 200000.23, 'Initiale', to_date('15-06-01','RR-MM-DD'), to_date('15-09-01','RR-MM-DD'));
  
  select * from TP2_PROJET;
  
  /****************** Table TP2_EQUIPE_PROJET **********/
  
  insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (5, 1000, 1);
  
  insert into TP2_EQUIPE_PROJET ( NO_MEMBRE, NO_PROJET, EST_DIRECTEUR_PRO) values (10, 1001, 0);
  
  select * from TP2_EQUIPE_PROJET;
  
  /*************** Table TP2_NOTIFICATION **************/
  
  insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_1', to_date('15-09-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 1000, 1001);
  
  insert into TP2_NOTIFICATION ( NO_NOTIFICATION, NOM_NOT, DATE_ECHEANCE_NOT, ETAT_NOT, NOTE_NOT, NO_MEM_ADMIN_CREATION, NO_MEM_ATTRIBUTION) 
    values ( NO_NOTIFICATION_SEQ.nextval, 'Nom_notif_2', to_date('15-10-01','RR-MM-DD'), 'Non débutée', 'Note notification_1', 1000, 1001);
  
  select * from TP2_NOTIFICATION;
  
   /*************** Table TP2_RAPPORT_ETAT **************/
   
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'ABCD', 'NOM_ETAT_RAPPORT_1');
  
  insert into TP2_RAPPORT_ETAT ( CODE_ETAT_RAP, NOM_ETAT_RAP) values ( 'ABCE', 'NOM_ETAT_RAPPORT_2');
  
  select * from TP2_RAPPORT_ETAT;
  
  /************** Table TP2_RAPPORT ********************/
  
  insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1000, 'RAPPORT_1', '/fichier1.docx', to_date('15-10-02','RR-MM-DD'), 'ABCD');
  
  insert into TP2_RAPPORT ( NO_RAPPORT, NO_PROJET, TITRE_RAP, NOM_FICHIER_RAP, DATE_DEPOT_RAP, CODE_ETAT_RAP)
    values ( NO_RAPPORT_SEQ.nextval, 1001, 'RAPPORT_2', '/fichier2.docx', to_date('15-10-01','RR-MM-DD'), 'ABCD');
  
  select * from TP2_RAPPORT;
  
  /************* Table TP2_CONFERENCE ********************/
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CONF_1', 'TITRE_1', to_date('15-02-02','RR-MM-DD'), to_date('15-03-03','RR-MM-DD'), 'YAOUNDÉ', '22 RUE DE DOUALA AKOUA');
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CON_2', 'TITRE_2', to_date('15-01-02','RR-MM-DD'), to_date('15-04-03','RR-MM-DD'), 'MONTRÉAL', '40 RUE GALT MONTREAL CANADA');
    
  select * from TP2_CONFERENCE;
  
  
  /************* TP2_INSCRIPTION_CONFERENCE *************/
  
  insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
    values ('CONF_1', 15,  to_date('15-04-03','RR-MM-DD'), 1);
  
  insert into TP2_INSCRIPTION_CONFERENCE ( SIGLE_CONFERENCE, NO_MEMBRE, DATE_DEMANDE_INS, STATUT_APPROBATION_INS)
    values ('CONF_1', 20,  to_date('15-04-03','RR-MM-DD'), 1);
    
  select * from TP2_INSCRIPTION_CONFERENCE;
  
  /************* Question 1e) requête SQL qui met à jour le lieu et l’adresse d’une conférence. ***************/
  
  insert into TP2_CONFERENCE ( SIGLE_CONFERENCE, TITRE_CON, DATE_DEBUT_CON, DATE_FIN_CON, LIEU_CON, ADRESSE_CON)
    values ('CON_3', 'Congrès sur la pauvreté au Cambodge', to_date('15-01-02','RR-MM-DD'), to_date('15-04-03','RR-MM-DD'), 'STADE INTER SCOLAIRE', '1940 RUE DU PAVILLON CENTRAL');
  
  update TP2_CONFERENCE
    set LIEU_CON = 'Théâtre de la cité universitaire',
        ADRESSE_CON = '2325, rue de la terrasse'
    where TITRE_CON = 'Congrès sur la pauvreté au Cambodge';
    
  select * from TP2_CONFERENCE;
    
 /************* Question 1i) requête SQL qui affiche le prénom et le nom du membre séparé par un espace et le nombre de notifications qui lui sont attribuées  ****************/
 
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
