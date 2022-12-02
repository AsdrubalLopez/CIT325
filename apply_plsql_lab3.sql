CREATE OR REPLACE FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date  DATE;
BEGIN
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN
        lv_date := pv_date_in;
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN
        lv_date := pv_date_in;
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := pv_date_in;
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := pv_date_in;
          ELSE
            RETURN NULL;
          END IF;
        END IF;
      ELSE
        /* Assign a default date. */
        RETURN NULL;
    END CASE;
  ELSE
    /* Assign a default date. */
    RETURN NULL;
  END IF;
  /* Return date. */
  RETURN lv_date;
END verify_date;
/

SPOOL apply_plsql_lab3.txt

SET SERVEROUTPUT ON SIZE UNLIMITED
set Verify OFF

DECLARE
  TYPE three_type IS RECORD
    ( xnum NUMBER,
      xdate DATE,
      xstring VARCHAR2(30));
  lv_three_type THREE_TYPE;
  
  TYPE vstring IS VARRAY(3) OF VARCHAR2(100); 
  
  array_string vstring:= vstring(' ',' ',' ');

  lv_input1  VARCHAR2(100);
  lv_input2  VARCHAR2(100);
  lv_input3  VARCHAR2(100);

 

BEGIN
  lv_input1 := '&1';
  lv_input2 := '&2';
  lv_input3 := '&3';
  array_string(1):=lv_input1;
  array_string(2):=lv_input2;
  array_string(3):=lv_input3;
  
  FOR i IN 1..3 LOOP
   
        IF REGEXP_LIKE(array_string(i),'^[[:digit:]]*$') then
            --lv_three_type.xnum:= lv_input1;
            lv_three_type.xnum:= array_string(i);
            --array_string(1):= 
        end if;
    
    
     
        IF REGEXP_LIKE(array_string(i),'^[[:alnum:]]*$') and  i = 2 then
            lv_three_type.xstring:= array_string(i);
        end if;
    
    
    
        IF REGEXP_LIKE(array_string(i),'^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') and i = 3 then
            lv_three_type.xdate:= verify_date(array_string(i));
        end if;
        
    
  END LOOP;

  dbms_output.put_line('Record ['|| lv_three_type.xnum || '] [' || lv_three_type.xstring || '] ['|| lv_three_type.xdate ||']');
END;
/

SPOOL OFF

QUIT
 
 
