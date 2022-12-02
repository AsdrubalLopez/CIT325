/*
   Name:   apply_plsql_lab2-2.sql
 
   Date:   30-April-2022
*/

SPOOL apply_plsql_lab2-2.txt
SET SERVEROUTPUT ON SIZE UNLIMITED

SET VERIFY OFF
DECLARE

lv_raw_input VARCHAR2(30);
lv_input VARCHAR2(10);

BEGIN
    lv_raw_input := '&1';
    
	IF LENGTH(lv_raw_input)>10 THEN
	
        lv_input := SUBSTR(lv_raw_input,'1','10');
        dbms_output.put_line('Hello '||lv_input||'!');
		
	
	ELSIF LENGTH(lv_raw_input)<10 then
		dbms_output.put_line('Hello '||lv_raw_input||'!');
		
    ELSE  
        
        dbms_output.put_line('Hello '||'World'||'!');
        
	END IF;
EXCEPTION
 WHEN OTHERS THEN
 dbms_output.put_line(SQLERRM);
END;
/

SPOOL OFF

QUIT;
