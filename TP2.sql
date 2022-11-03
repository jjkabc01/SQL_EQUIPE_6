                                                /**** TP2 *******/ 
/***** Création des tables du cas CIPRÉ ******/

drop table TP2_MEMBRE cascade constraints;
drop table TP2_PROJET cascade constraints;
drop table TP1_EQUIPE_PROJET cascade constraints;
drop table TP2_NOTIFICATION cascade constraints;
drop table TP2_RAPPORT cascade constraints;
drop table TP2_RAPPORT_ETAT cascade constraints;
drop table TP2_INSCRIPTION_CONFERENCE cascade constraints;
drop table TP2_CONFERENCE cascade constraints;
drop sequence NO_CHERCH_SEQ;


create table MEMBRE (
  NO_MEMBRE number(10) not null, 
  UTILISATEUR_MEM varchar2(10) not null,
  MOT_DE_PASSE_MEM varchar2(30) not null,
  NOM_MEM varchar2(30) not null,
  PRENOM_MEM varchar2(30) not null,
  ADRESSE_MEM varchar2(30) not null,  
  CODE_POSTAL_MEM char(7) not null, 
  PAYS_MEM varchar2(30) not null, 
  TEL_MEM char(13) null, 
  FAX_MEM char(13) null,  
  LANGUE_CORRESPONDANCE_MEM varchar2(30) default 'Français' not null,
  NOM_FICHIER_PHOTO_MEM varchar2(200) null, 
  ADRESSE_WEB_MEM varchar2(30) null,
  INSTITUTION_MEM varchar2(30) null,
  COURRIEL_MEM varchar2(30) not null,
  EST_ADMINISTRATEUR_MEM number(1) default 0 not null, 
  EST_SUPERVISEUR_MEM number(1) default 0 not null, 
  EST_APPOUVEE_INSCRIPTION_MEM number(1) default 0 not null, 
  NO_MEMBRE_PATRON# number(10) not null, 
  constraint PK_MEMBRE primary key (NO_MEMBRE),
  constraint FK_MEMBRE foreign key (NO_MEMBRE_PATRON) 
				references TP1_MEMBRE (NO_MEMBRE_PATRON) on delete set null
                   
 );

create table PROJET (
  NO_PROJET number(10) not null, 
  NOM_PRO varchar2(30) not null,
  MNT_ALLOUE_PRO number(6,2) default 0.0 not null, 
  STATUT_PRO varchar2(30) default 'Initial' not null,
  DATE_DEBUT_PRO DATE not null,
  DATE_FIN_PRO DATE not null,
  constraint PK_PROJET primary key (NO_PROJET),
 	constraint CT_STATUT_PRO check (STATUT_PRO in ('Initial', 'Intermédiaire', 'Final'))
  
);

create table EQUIPE_PROJET (
  NO_MEMBRE# number(10) not null, 
  NO_PROJET# number(10) not null, 
  EST_DIRECTEUR_PRO number(1) default 0 not null, 
  constraint PK_EQUIPE_PROJET primary key (NO_MEMBRE, NO_PROJET),
  constraint FK_EQUIPE_PROJET foreign key (NO_MEMBRE) 
				references TP1_MEMBRE (NO_MEMBRE) on delete set null,
  constraint FK_EQUIPE_PROJET foreign key (NO_PROJET) 
				references TP1_PROJET (NO_PROJET) on delete set null

);

create table NOTIFICATION (
  NO_NOTIFICATION number(10) not null,
  NOM_NOT varchar2(30) not null,
  DATE_ECHEANCE_NOT DATE not null,
  ETAT_NOT varchar2(30) default 'Débuté' not null,
  NOTE_NOT varchar2(1000) null,
  NO_MEM_ADMIN_CREATION# number(10) not null,
  NO_MEM_ATTRIBUTION# number(10) not null,
  constraint PK_NOTIFICATION primary key (NO_NOTIFICATION),
  constraint FK_NOTIFICATION foreign key (NO_MEM_ADMIN_CREATION) 
				references TP1_MEMBRE (NO_MEM_ADMIN_CREATION) on delete set null,
  constraint FK_NOTIFICATION foreign key (NO_MEM_ATTRIBUTION) 
				references TP1_PROJET (NO_MEM_ATTRIBUTION) on delete set null,
  constraint CT_ETAT_NOT check (ETAT_NOT in ('Débuté', 'En vérification', 'En correction', 'Approuvé'))
  
);

create table RAPPORT (
  NO_RAPPORT number(10) not null,
  NO_PROJET# number(10) not null,
  TITRE_RAP varchar2(30) not null,
  NOM_FICHIER_RAP varchar2(200) not null, 
  DATE_DEPOT_RAP DATE not null,
  CODE_ETAT_RAP# char(4) not null,
  constraint PK_RAPPORT primary key (NO_RAPPORT),
  constraint FK_RAPPORT foreign key (NO_PROJET) 
				references PROJET (NO_PROJET) on delete set null,
  constraint FK_RAPPORT foreign key (CODE_ETAT_RAP) 
				references RAPPORT_ETAT (CODE_ETAT_RAP) on delete set null
	
);

create table RAPPORT_ETAT (
  CODE_ETAT_RAP char(4) not null,
  NOM_ETAT_RAP varchar2(30) not null,
  constraint PK_RAPPORT_ETAT primary key (ODE_ETAT_RAP)
  
);

create table INSCRIPTION_CONFERENCE (
  SIGLE_CONFERENCE#,
  NO_MEMBRE#,
  DATE_DEMANDE_INS,
  STATUT_APPROBATION_INS
  
);

create table CONFERENCE (
  SIGLE_CONFERENCE,
  TITRE_CON,
  DATE_DEBUT_CON,
  DATE_FIN_CON,
  LIEU_CON,
  ADRESSE_CON

);

create sequence NO_CHERCH_SEQ
    start with 1000
    increment by 1;
