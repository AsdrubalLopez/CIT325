
/*

14-Oct-2022
*/


SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

-- limpio los datos
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql
SPOOL apply_plsql_lab5.txt
-- adiciono un campo para la secuencia a la tabla Item(sufri para descibir eso)
ALTER TABLE item
    ADD rating_agency_id NUMBER;

-- Creo la secuencia (otra cosa mas que tarde en descubir)
CREATE SEQUENCE rating_agency_s START WITH 1001;

-- codigo dado en las instrucciones
         
CREATE TABLE rating_agency AS
SELECT rating_agency_s.NEXTVAL AS rating_agency_id
,      il.item_rating AS rating
,      il.item_rating_agency AS rating_agency
FROM  (SELECT DISTINCT
              i.item_rating
       ,      i.item_rating_agency
       FROM   item i) il;
         



SELECT * FROM rating_agency;
		 
-- modified ITEM table
SET NULL ''
COLUMN table_name   FORMAT A18
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

-- Creo el OBJETO
CREATE OR REPLACE
    TYPE rating_agency_obj IS OBJECT
    ( rating_agency_id     NUMBER
    , rating               VARCHAR2(8)
    , rating_agency        VARCHAR2(4));
/

-- la collection
CREATE OR REPLACE
    TYPE rating_agency_obj_list IS TABLE OF rating_agency_obj; 
/


DECLARE

    lv_rating_agency_id     NUMBER;
    lv_rating               VARCHAR2(8);    
    lv_rating_agency        VARCHAR2(4);

/****** CURSOR**/
    CURSOR c IS
        SELECT  i.rating_agency_id 
        ,       i.rating
        ,       i.rating_agency 
        FROM    rating_agency i;


    lv_rating_agency_obj_list RATING_AGENCY_OBJ_LIST := rating_agency_obj_list();
BEGIN
-- usar el CURSOR PARA RELLENAR  la tabla
    FOR i IN c LOOP
        lv_rating_agency_obj_list.EXTEND;
        lv_rating_agency_obj_list(lv_rating_agency_obj_list.COUNT) := rating_agency_obj( lv_rating_agency_id
                                                               , lv_rating
                                                               , lv_rating_agency);
-- Update 
        UPDATE item
        SET rating_agency_id = i.rating_agency_id
        WHERE item_rating = i.rating AND item_rating_agency = i.rating_agency;
    END LOOP;
    COMMIT;
END;
/

-- confirmar

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;
/
SPOOL OFF
QUIT;
