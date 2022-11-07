/************ Question 1)d)  ***/
   
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
