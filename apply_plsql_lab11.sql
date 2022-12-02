 
SET SERVEROUTPUT ON
--@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SPOOL apply_plsql_lab11.txt;
-- Add a text_file_name column to the item table
ALTER TABLE item
ADD text_file_name VARCHAR2(30);

-- verification
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;
CREATE SEQUENCE item_s;

desc item;
-- create de logger table
CREATE TABLE logger(
logger_id  NUMBER,
old_item_id    NUMBER,
OLD_ITEM_BARCODE VARCHAR2(20),
OLD_ITEM_TYPE  NUMBER,
old_item_title  VARCHAR2(60),
OLD_ITEM_SUBTITLE VARCHAR2(60),
OLD_ITEM_RATING VARCHAR2(8),
OLD_ITEM_RATING_AGENCY VARCHAR2(4),
OLD_ITEM_RELEASE_DATE DATE,
OLD_CREATED_BY  NUMBER,
OLD_CREATION_DATE DATE,
OLD_LAST_UPDATED_BY  NUMBER,
OLD_LAST_UPDATE_DATE DATE,
OLD_TEXT_FILE_NAME VARCHAR2(40),
NEW_ITEM_ID NUMBER,
NEW_ITEM_BARCODE VARCHAR2(20),
NEW_ITEM_TYPE  NUMBER,
NEW_ITEM_TITLE VARCHAR2(60),
NEW_ITEM_SUBTITLE VARCHAR2(60),
NEW_ITEM_RATING	 VARCHAR2(8),
NEW_ITEM_RATING_AGENCY VARCHAR2(4),
NEW_ITEM_RELEASE_DATE DATE,
NEW_CREATED_BY  NUMBER,
NEW_CREATION_DATE  DATE,
NEW_LAST_UPDATED_BY	 NUMBER,
NEW_LAST_UPDATE_DATE  DATE,
NEW_TEXT_FILE_NAME   VARCHAR2(40),
CONSTRAINT logger_pk PRIMARY KEY (logger_id));

CREATE SEQUENCE logger_s;

desc logger;
CREATE OR REPLACE PACKAGE manage_item IS
    --INSERT
    PROCEDURE insert_item (
    PV_NEW_ITEM_ID 				     NUMBER,
    PV_NEW_ITEM_BARCODE			     VARCHAR2,
    PV_NEW_ITEM_TYPE				 NUMBER,
    PV_NEW_ITEM_TITLE				 VARCHAR2,
    PV_NEW_ITEM_SUBTITLE			 VARCHAR2,
    PV_NEW_ITEM_RATING				 VARCHAR2,
    PV_NEW_ITEM_RATING_AGENCY		 VARCHAR2,
    PV_NEW_ITEM_RELEASE_DATE		 DATE,
    PV_NEW_CREATED_BY				 NUMBER,
    PV_NEW_CREATION_DATE			 DATE,
    PV_NEW_LAST_UPDATED_BY 		     NUMBER,
    PV_NEW_LAST_UPDATE_DATE		     DATE,
    PV_NEW_TEXT_FILE_NAME			 VARCHAR2
    );
    --UPDATE
    PROCEDURE insert_item (
    PV_OLD_ITEM_ID   			     NUMBER,
    PV_OLD_ITEM_BARCODE	    		 VARCHAR2,
    PV_OLD_ITEM_TYPE	   		     NUMBER,
    PV_OLD_ITEM_TITLE				 VARCHAR2,
    PV_OLD_ITEM_SUBTITLE			 VARCHAR2,
    PV_OLD_ITEM_RATING				 VARCHAR2,
    PV_OLD_ITEM_RATING_AGENCY		 VARCHAR2,
    PV_OLD_ITEM_RELEASE_DATE		 DATE,
    PV_OLD_CREATED_BY				 NUMBER,
    PV_OLD_CREATION_DATE			 DATE,
    PV_OLD_LAST_UPDATED_BY 		     NUMBER,
    PV_OLD_LAST_UPDATE_DATE		     DATE,
    PV_OLD_TEXT_FILE_NAME			 VARCHAR2,
    PV_NEW_ITEM_ID 				     NUMBER,
    PV_NEW_ITEM_BARCODE			     VARCHAR2,
    PV_NEW_ITEM_TYPE				 NUMBER,
    PV_NEW_ITEM_TITLE				 VARCHAR2,
    PV_NEW_ITEM_SUBTITLE			 VARCHAR2,
    PV_NEW_ITEM_RATING				 VARCHAR2,
    PV_NEW_ITEM_RATING_AGENCY		 VARCHAR2,
    PV_NEW_ITEM_RELEASE_DATE		 DATE,
    PV_NEW_CREATED_BY				 NUMBER,
    PV_NEW_CREATION_DATE			 DATE,
    PV_NEW_LAST_UPDATED_BY 		     NUMBER,
    PV_NEW_LAST_UPDATE_DATE		     DATE,
    PV_NEW_TEXT_FILE_NAME			 VARCHAR2	
    );
    --DELETING
    PROCEDURE insert_item (
    PV_OLD_ITEM_ID  			     NUMBER,
    PV_OLD_ITEM_BARCODE              VARCHAR2,
    PV_OLD_ITEM_TYPE				 NUMBER,
    PV_OLD_ITEM_TITLE				 VARCHAR2,
    PV_OLD_ITEM_SUBTITLE			 VARCHAR2,
    PV_OLD_ITEM_RATING				 VARCHAR2,
    PV_OLD_ITEM_RATING_AGENCY		 VARCHAR2,
    PV_OLD_ITEM_RELEASE_DATE		 DATE,
    PV_OLD_CREATED_BY				 NUMBER,
    PV_OLD_CREATION_DATE			 DATE,
    PV_OLD_LAST_UPDATED_BY 		     NUMBER,
    PV_OLD_LAST_UPDATE_DATE		     DATE,
    PV_OLD_TEXT_FILE_NAME			 VARCHAR2
    );
END manage_item;
/

CREATE OR REPLACE PACKAGE BODY manage_item IS
--PROCEDIRE1
       PROCEDURE insert_item(
        PV_NEW_ITEM_ID 				     NUMBER,
        PV_NEW_ITEM_BARCODE			     VARCHAR2,
        PV_NEW_ITEM_TYPE				 NUMBER,
        PV_NEW_ITEM_TITLE				 VARCHAR2,
        PV_NEW_ITEM_SUBTITLE			 VARCHAR2,
        PV_NEW_ITEM_RATING				 VARCHAR2,
        PV_NEW_ITEM_RATING_AGENCY		 VARCHAR2,
        PV_NEW_ITEM_RELEASE_DATE		 DATE,
        PV_NEW_CREATED_BY				 NUMBER,
        PV_NEW_CREATION_DATE			 DATE,
        PV_NEW_LAST_UPDATED_BY 		     NUMBER,
        PV_NEW_LAST_UPDATE_DATE		     DATE,
        PV_NEW_TEXT_FILE_NAME			 VARCHAR2
       )IS /*local variables*/
       lv_logger_id  NUMBER;
       PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
       lv_logger_id:=logger_s.NEXTVAL;
       SAVEPOINT starting_point;
       INSERT INTO logger( 
         LOOGER_ID       
        ,NEW_ITEM_ID                                       
        ,NEW_ITEM_BARCODE                                
        ,NEW_ITEM_TYPE,           
        ,NEW_ITEM_TITLE                                    
        ,NEW_ITEM_SUBTITLE                                  
        ,NEW_ITEM_RATING                                    
        ,NEW_ITEM_RATING_AGENCY                             
        ,NEW_ITEM_RELEASE_DATE                              
        ,NEW_CREATED_BY                                     
        ,NEW_CREATION_DATE                                  
        ,NEW_LAST_UPDATED_BY                                
        ,NEW_LAST_UPDATE_DATE                               
        ,NEW_TEXT_FILE_NAME)
        
        VALUES(
        lv_logger_id
        ,PV_NEW_ITEM_ID
        ,PV_NEW_ITEM_BARCODE
        ,PV_NEW_ITEM_TYPE
        ,PV_NEW_ITEM_TITLE
        ,PV_NEW_ITEM_SUBTITLE
        ,PV_NEW_ITEM_RATING
        ,PV_NEW_ITEM_RATING_AGENCY
        ,PV_NEW_ITEM_RELEASE_DATE
        ,PV_NEW_CREATED_BY		
        ,PV_NEW_CREATION_DATE	
        ,PV_NEW_LAST_UPDATED_BY
        ,PV_NEW_LAST_UPDATE_DATE
        ,PV_NEW_TEXT_FILE_NAME   
        );
    
       COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END insert_item;
--procedure 2
PROCEDURE insert_item(
    PV_OLD_ITEM_ID 				         NUMBER,
    PV_OLD_ITEM_BARCODE			         VARCHAR2,
    PV_OLD_ITEM_TYPE				     NUMBER,
    PV_OLD_ITEM_TITLE			         VARCHAR2,
    PV_OLD_ITEM_SUBTITLE			     VARCHAR2,
    PV_OLD_ITEM_RATING				     VARCHAR2,
    PV_OLD_ITEM_RATING_AGENCY		     VARCHAR2,
    PV_OLD_ITEM_RELEASE_DATE		     DATE,
    PV_OLD_CREATED_BY	        		 NUMBER,
    PV_OLD_CREATION_DATE		    	 DATE,
    PV_OLD_LAST_UPDATED_BY 		         NUMBER,
    PV_OLD_LAST_UPDATE_DATE		         DATE,
    PV_OLD_TEXT_FILE_NAME			     VARCHAR2,
    PV_NEW_ITEM_ID 				         NUMBER,
    PV_NEW_ITEM_BARCODE		        	 VARCHAR2,
    PV_NEW_ITEM_TYPE		             NUMBER,
    PV_NEW_ITEM_TITLE      				 VARCHAR2,
    PV_NEW_ITEM_SUBTITLE	    		 VARCHAR2,
    PV_NEW_ITEM_RATING		    		 VARCHAR2,
    PV_NEW_ITEM_RATING_AGENCY	    	 VARCHAR2,
    PV_NEW_ITEM_RELEASE_DATE	    	 DATE,
    PV_NEW_CREATED_BY				     NUMBER,
    PV_NEW_CREATION_DATE	    		 DATE,
    PV_NEW_LAST_UPDATED_BY 	          	 NUMBER,
    PV_NEW_LAST_UPDATE_DATE     		 DATE,
    PV_NEW_TEXT_FILE_NAME	    		 VARCHAR2
    )
    lv_logger_id  NUMBER;
    IS PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    lv_logger_id:= logger_s.NEXTVAL;
SAVEPOINT starting_point;
       INSERT INTO logger(  LOGGER_ID
                            ,OLD_ITEM_ID                                         
                            ,OLD_ITEM_BARCODE                                    
                            ,OLD_ITEM_TYPE                                     
                            ,OLD_ITEM_TITLE                                    
                            ,OLD_ITEM_SUBTITLE                                 
                            ,OLD_ITEM_RATING                                   
                            ,OLD_ITEM_RATING_AGENCY                            
                            ,OLD_ITEM_RELEASE_DATE                             
                            ,OLD_CREATED_BY                                      
                            ,OLD_CREATION_DATE                                   
                            ,OLD_LAST_UPDATED_BY                                 
                            ,OLD_LAST_UPDATE_DATE                                
                            ,OLD_TEXT_FILE_NAME
                            ,NEW_ITEM_ID                                       
                            ,NEW_ITEM_BARCODE                                
                            ,NEW_ITEM_TYPE,           
                            ,NEW_ITEM_TITLE                                    
                            ,NEW_ITEM_SUBTITLE                                  
                            ,NEW_ITEM_RATING                                    
                            ,NEW_ITEM_RATING_AGENCY                             
                            ,NEW_ITEM_RELEASE_DATE                              
                            ,NEW_CREATED_BY                                     
                            ,NEW_CREATION_DATE                                  
                            ,NEW_LAST_UPDATED_BY                                
                            ,NEW_LAST_UPDATE_DATE                               
                            ,NEW_TEXT_FILE_NAME
                            
                          )
                  VALUES(    lv_logger_id
                            ,PV_OLD_ITEM_ID 
                            ,PV_OLD_ITEM_BARCODE
                            ,PV_OLD_ITEM_TYPE
                            ,PV_OLD_ITEM_TITLE
                            ,PV_OLD_ITEM_SUBTITLE	
                            ,PV_OLD_ITEM_RATING
                            ,PV_OLD_ITEM_RATING_AGENCY	
                            ,PV_OLD_ITEM_RELEASE_DATE	
                            ,PV_OLD_CREATED_BY	
                            ,PV_OLD_CREATION_DATE	
                            ,PV_OLD_LAST_UPDATED_BY 	
                            ,PV_OLD_LAST_UPDATE_DATE
                            ,PV_OLD_TEXT_FILE_NAME
                            ,PV_NEW_ITEM_ID
                            ,PV_NEW_ITEM_BARCODE
                            ,PV_NEW_ITEM_TYPE
                            ,PV_NEW_ITEM_TITLE
                            ,PV_NEW_ITEM_SUBTITLE
                            ,PV_NEW_ITEM_RATING
                            ,PV_NEW_ITEM_RATING_AGENCY
                            ,PV_NEW_ITEM_RELEASE_DATE
                            ,PV_NEW_CREATED_BY		
                            ,PV_NEW_CREATION_DATE	
                            ,PV_NEW_LAST_UPDATED_BY
                            ,PV_NEW_LAST_UPDATE_DATE
                            ,PV_NEW_TEXT_FILE_NAME
                  );
    
       COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END insert_item;
--procedure 3

PROCEDURE insert_item(
    PV_OLD_ITEM_ID                       NUMBER,
    PV_OLD_ITEM_BARCODE                  VARCHAR2,
    PV_OLD_ITEM_TYPE                     NUMBER,
    PV_OLD_ITEM_TITLE				     VARCHAR2,
    PV_OLD_ITEM_SUBTITLE	    		 VARCHAR2,
    PV_OLD_ITEM_RATING			         VARCHAR2,
    PV_OLD_ITEM_RATING_AGENCY            VARCHAR2,
    PV_OLD_ITEM_RELEASE_DATE             DATE,
    PV_OLD_CREATED_BY                    NUMBER,
    PV_OLD_CREATION_DATE                 DATE,
    PV_OLD_LAST_UPDATED_BY               NUMBER,
    PV_OLD_LAST_UPDATE_DATE	             DATE,
    PV_OLD_TEXT_FILE_NAME                VARCHAR2

) IS 
lv_logger_id  NUMBER;
PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    lv_logger_id:= logger_s.NEXTVAL;
SAVEPOINT starting_point;
       INSERT INTO logger(LOGGER_ID
                        ,OLD_ITEM_ID                                         
                        ,OLD_ITEM_BARCODE                                    
                        ,OLD_ITEM_TYPE                                     
                        ,OLD_ITEM_TITLE                                    
                        ,OLD_ITEM_SUBTITLE                                 
                        ,OLD_ITEM_RATING                                   
                        ,OLD_ITEM_RATING_AGENCY                            
                        ,OLD_ITEM_RELEASE_DATE                             
                        ,OLD_CREATED_BY                                      
                        ,OLD_CREATION_DATE                                   
                        ,OLD_LAST_UPDATED_BY                                 
                        ,OLD_LAST_UPDATE_DATE                                
                        ,OLD_TEXT_FILE_NAME)
                  VALUES(
                        lv_logger_id
                        ,PV_OLD_ITEM_ID 
                        ,PV_OLD_ITEM_BARCODE
                        ,PV_OLD_ITEM_TYPE
                        ,PV_OLD_ITEM_TITLE
                        ,PV_OLD_ITEM_SUBTITLE	
                        ,PV_OLD_ITEM_RATING	
                        ,PV_OLD_ITEM_RATING_AGENCY	
                        ,PV_OLD_ITEM_RELEASE_DATE	
                        ,PV_OLD_CREATED_BY	
                        ,PV_OLD_CREATION_DATE	
                        ,PV_OLD_LAST_UPDATED_BY 	
                        ,PV_OLD_LAST_UPDATE_DATE
                        ,PV_OLD_TEXT_FILE_NAME
                        );
    
       COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END insert_item;


END manage_item;/*PACKAGE*/
/
-- Trigger
CREATE OR REPLACE TRIGGER item_trig 
 AFTER INSERT OR UPDATE OR DELETE ON item
BEGIN
DBMS_OUTPUT.PUT_LINE('Enter to TRIGGER').
    IF INSERTING THEN
    manage_item.insert_item(
  :NEW.ITEM_ID                                       
 ,:NEW.ITEM_BARCODE                                
 ,:NEW.ITEM_TYPE,           
 ,:NEW.ITEM_TITLE                                    
 ,:NEW.ITEM_SUBTITLE                                  
 ,:NEW.ITEM_RATING                                    
 ,:NEW.ITEM_RATING_AGENCY                             
 ,:NEW.ITEM_RELEASE_DATE                              
 ,:NEW.CREATED_BY                                     
 ,:NEW.CREATION_DATE                                  
 ,:NEW.LAST_UPDATED_BY                                
 ,:NEW.LAST_UPDATE_DATE                               
 ,:NEW.TEXT_FILE_NAME
    );
ELSIF UPDATING THEN
manage_item.insert_item(
:OLD.ITEM_ID                                         
,:OLD.TEM_BARCODE                                    
,:OLD.ITEM_TYPE                                     
,:OLD.ITEM_TITLE                                    
,:OLD.ITEM_SUBTITLE                                 
,:OLD.ITEM_RATING                                   
,:OLD.ITEM_RATING_AGENCY                            
,:OLD.ITEM_RELEASE_DATE                             
,:OLD.CREATED_BY                                      
,:OLD.CREATION_DATE                                   
,:OLD.LAST_UPDATED_BY                                 
,:OLD.LAST_UPDATE_DATE                                
,:OLD.TEXT_FILE_NAME
,:NEW.ITEM_ID                                       
 ,:NEW.ITEM_BARCODE                                
 ,:NEW.ITEM_TYPE,           
 ,:NEW.ITEM_TITLE                                    
 ,:NEW.ITEM_SUBTITLE                                  
 ,:NEW.ITEM_RATING                                    
 ,:NEW.ITEM_RATING_AGENCY                             
 ,:NEW.ITEM_RELEASE_DATE                              
 ,:NEW.CREATED_BY                                     
 ,:NEW.CREATION_DATE                                  
 ,:NEW.LAST_UPDATED_BY                                
 ,:NEW.LAST_UPDATE_DATE                               
 ,:NEW.TEXT_FILE_NAME

);

ELSIF DELETING THEN
    manage_item.insert_item(
    :OLD.ITEM_ID                                         
,:OLD.TEM_BARCODE                                    
,:OLD.ITEM_TYPE                                     
,:OLD.ITEM_TITLE                                    
,:OLD.ITEM_SUBTITLE                                 
,:OLD.ITEM_RATING                                   
,:OLD.ITEM_RATING_AGENCY                            
,:OLD.ITEM_RELEASE_DATE                             
,:OLD.CREATED_BY                                      
,:OLD.CREATION_DATE                                   
,:OLD.LAST_UPDATED_BY                                 
,:OLD.LAST_UPDATE_DATE                                
,:OLD.TEXT_FILE_NAME)

END IF;

--  IF USER NOT IN ('SYSTEM','SYS') THEN
--   RAISE_APPLICATION_ERROR(-20001,'Esta tabla no debe ser modificada bajo ninguna circunstancia');
--  END IF;
END item_trig;

-- end Trigger
DECLARE
 
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
        
    /*... insert the data into the logger table ...*/
    INSERT INTO item (ITEM_ID, ITEM_BARCODE, ITEM_TYPE, ITEM_TITLE,
                    ITEM_DESC,ITEM_RATING,ITEM_RATING_AGENCY, ITEM_RELEASE_DATE,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY,LAST_UPDATE_DATE, 
                    TEXT_FILE_NAME)
                values(item_s.NEXTVAL,'111-111',5,'The BEST', 
                    'Clob large','PG-13', 'ASW',SYSDATE,
                    5,SYSDATE,5,SYSDATE,'By who i am'
                    
                    );
    
    update item
    SET ITEM_BARCODE='2222-2222', LAST_UPDATE_DATE=SYSDATE WHERE ITEM_TITLE='The BEST';
    
    DELETE FROM item WHERE ITEM_TITLE='The BEST';
 
  END LOOP;
END;
/
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

SPOOL OFF;

EXIT;
