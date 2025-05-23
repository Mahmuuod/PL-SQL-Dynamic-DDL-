set serveroutput on size 1000000;
/*
select * from user_tab_columns;   
select * from user_constraints;
select * from user_cons_columns;  
*/
declare

    cursor CR_PKCOL_TABLES is
    
         select ucc.column_name,ucc.table_name from
        user_constraints uc inner join user_cons_columns ucc on uc.constraint_name=ucc.constraint_name and uc.constraint_type='P'
        inner join user_tab_columns utc on  utc.column_name=ucc.column_name and utc.table_name=ucc.table_name and utc.DATA_TYPE='NUMBER'
        
       where  ucc.table_name not in 
       (select uc.table_name from user_cons_columns ucc inner join user_constraints uc on 
        ucc.constraint_name=uc.Constraint_name and constraint_type='P'
        group by uc.table_name
        having count(uc.table_name)>1);
            
    cursor C_SQE is
        select sequence_name from user_sequences;   
        
      VmaxNo number(12);
sql_query varchar2(200);
begin


for V_SEQ in C_SQE
loop
    execute immediate 'drop sequence '||  V_SEQ.sequence_name  ; 
      DBMS_OUTPUT.PUT_LINE('dropped seq  '||V_SEQ.sequence_name);

end loop;


for C_DATA in CR_PKCOL_TABLES
loop
      SQL_QUERY := 'SELECT NVL(MAX(' || C_DATA.column_name || '), 0) +1 FROM ' || C_DATA.table_name;
     EXECUTE IMMEDIATE SQL_QUERY INTO VmaxNo;

   execute immediate 'CREATE SEQUENCE ' || C_DATA.table_name|| '_SEQ 
 START WITH '||VmaxNo||' 
  MAXVALUE 999999999999999999999999999
  NOCYCLE
  CACHE 20
  NOORDER';
  DBMS_OUTPUT.PUT_LINE('added seq on '||C_DATA.table_name);
  
    execute immediate '
      CREATE or replace TRIGGER ' || C_DATA.table_name || '_TRIG 
    BEFORE INSERT
    ON ' || C_DATA.table_name || ' 
    FOR EACH ROW
    BEGIN  
      :NEW.' || C_DATA.column_name || ' := ' || C_DATA.table_name || '_SEQ.NEXTVAL; 
    END;' ;
      DBMS_OUTPUT.PUT_LINE('added trigger on '||C_DATA.table_name);

 end loop;
 

end;
show errors



--tests 
select object_name from user_objects where 
 substr(object_name,instr(object_name,'_',-1)+1) = 'TRIG';
 
 select sequence_name from user_sequences where 
 substr(sequence_name,instr(sequence_name,'_',-1)+1) = 'SEQ';
 
 
 
 
 /*insert into departments(DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID) values
 ('deptt',200,1000);
 select * from departments*/