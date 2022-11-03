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
  INSTITUTION_MEM, 
  COURRIEL_MEM, 
  EST_ADMINISTRATEUR_MEM, 
  EST_SUPERVISEUR_MEM,
  EST_APPOUVEE_INSCRIPTION_MEM, NO_MEMBRE_PATRON#
                   
 );

create table PROJET (
  NO_PROJET, 
  NOM_PRO, 
  MNT_ALLOUE_PRO, 
  STATUT_PRO, 
  DATE_DEBUT_PRO, 
  DATE_FIN_PRO
  
);

create table EQUIPE_PROJET (
  NO_MEMBRE#,
  NO_PROJET#, 
  EST_DIRECTEUR_PRO
  
);

create table NOTIFICATION (
  NO_NOTIFICATION,
  NOM_NOT,
  DATE_ECHEANCE_NOT,
  ETAT_NOT,
  NOTE_NOT,
  NO_MEM_ADMIN_CREATION#,
  NO_MEM_ATTRIBUTION#
  
);

create table RAPPORT (
  NO_RAPPORT, 
  NO_PROJET#,
  TITRE_RAP,
  NOM_FICHIER_RAP,
  DATE_DEPOT_RAP,
  CODE_ETAT_RAP#
  
);

create table RAPPORT_ETAT (
  CODE_ETAT_RAP,
  NOM_ETAT_RAP
  
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
