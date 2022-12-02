-- Autor:

SET SERVEROUTPUT ON SIZE UNLIMITED

@@apply_plsql_lab7.sql
--@@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SPOOL apply_plsql_lab8.txt

/* STEP 1: Create a contact_package package specification that holds overloaded insert_contact procedures. 
One procedure supports batch programs with a user’s name and another supports authenticated web forms with a user’s ID; 
where the ID is a value from the system_user_id column of the system_user table. */

-- borramos por si acaso
--DROP PACKAGE contact_package;

CREATE OR REPLACE PACKAGE contact_package IS
        PROCEDURE insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_name           VARCHAR2 );
        PROCEDURE insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER );
        
        FUNCTION insert_contact
        ( pv_first_name         VARCHAR2,
          pv_middle_name        VARCHAR2,
          pv_last_name          VARCHAR2,
          pv_contact_type       VARCHAR2,
          pv_account_number     VARCHAR2,
          pv_member_type        VARCHAR2,
          pv_credit_card_number VARCHAR2,
          pv_credit_card_type   VARCHAR2,
          pv_city               VARCHAR2,
          pv_state_province     VARCHAR2,
          pv_postal_code        VARCHAR2,
          pv_address_type       VARCHAR2,
          pv_country_code       VARCHAR2,
          pv_area_code          VARCHAR2,
          pv_telephone_number   VARCHAR2,
          pv_telephone_type     VARCHAR2,
          pv_user_name          VARCHAR2) RETURN NUMBER;
          
        FUNCTION insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER ) return NUMBER;
        
        END contact_package;
/

/* Step 2: Create a contact_package package body that implements two 
           insert_contact procedures. */
           
CREATE OR REPLACE PACKAGE BODY contact_package IS
       PROCEDURE insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_name           VARCHAR2 )IS PRAGMA AUTONOMOUS_TRANSACTION;
        
        -- Local variables
        lv_address_type         NUMBER;
        lv_contact_type         NUMBER;
        lv_credit_card_type     NUMBER;
        lv_member_type          NUMBER;
        lv_telephone_type       NUMBER;

        lv_system_user_id       NUMBER;
        lv_time                 DATE := SYSDATE;
        
         
  CURSOR c
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
        SELECT      common_lookup_id
            FROM    common_lookup
            WHERE   common_lookup_table =   cv_table_name
            AND     common_lookup_column =  cv_column_name
            AND     common_lookup_type =    cv_lookup_type;
BEGIN



-- Member 
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;
  dbms_output.put_line('Member_TYPE ['||lv_member_type|| ']');

-- credit card type
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

-- Address 
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;

-- Contact 
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

-- telephone 
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;

    -- variable for Username
  SELECT system_user_id
  INTO   lv_system_user_id
  FROM   system_user
  WHERE  system_user_name = pv_user_name;

  --starting point.
  SAVEPOINT starting_point;

  

    INSERT INTO member(member_id, member_type, account_number, credit_card_number, credit_card_type, created_by, creation_date, last_updated_by, last_update_date )
    VALUES            (member_s1.NEXTVAL, lv_member_type, pv_account_number, pv_credit_card_number, lv_credit_card_type,lv_system_user_id, lv_time, lv_system_user_id,  lv_time );

    INSERT INTO contact(contact_id, member_id, contact_type, last_name, first_name, middle_name, created_by, creation_date, last_updated_by, last_update_date)
    VALUES             (contact_s1.NEXTVAL, member_s1.CURRVAL, lv_contact_type, pv_last_name, pv_first_name, pv_middle_name, lv_system_user_id, lv_time, lv_system_user_id       , lv_time );

    INSERT INTO address
    VALUES( address_s1.NEXTVAL , contact_s1.CURRVAL, lv_address_type, pv_city, pv_state_province, pv_postal_code, lv_system_user_id, lv_time, lv_system_user_id, lv_time);

    INSERT INTO telephone
    VALUES(telephone_s1.NEXTVAL, contact_s1.CURRVAL, address_s1.CURRVAL, lv_telephone_type, pv_country_code, pv_area_code, pv_telephone_number, lv_system_user_id, lv_time     ,lv_system_user_id, lv_time );

  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   -- dbms_output.put_line('ERROR IN PROCEDURE 1: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;

-- Procedure 2

        PROCEDURE insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER )IS
 
/* Declare local constants. */
        lv_creation_date     DATE := SYSDATE;
 
/* Declare a who-audit ID variable. */
        lv_created_by        NUMBER;
 
/* Declare type variables. */
        lv_member_type       NUMBER;
        lv_credit_card_type  NUMBER;
        lv_contact_type      NUMBER;
        lv_address_type      NUMBER;
        lv_telephone_type    NUMBER;
        lv_user_id           NUMBER;
        
        CURSOR GET_LOOKUP_TYPE
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
        SELECT      common_lookup_id
            FROM    common_lookup
            WHERE   common_lookup_table =   cv_table_name
            AND     common_lookup_column =  cv_column_name
            AND     common_lookup_type =    cv_lookup_type;
        cursor A is SELECT common_lookup_id from common_lookup;-- para una verificacion
        LV_MEMBER_ID         NUMBER;
 BEGIN
/* Declare a local cursor./* Get the member_type ID value. */
        FOR i IN get_lookup_type('MEMBER','MEMBER_TYPE',pv_member_type) LOOP
        lv_member_type := i.common_lookup_id;
        END LOOP;
 
/* Get the credit_card_type ID value. */
        FOR i IN get_lookup_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
        END LOOP;
 
/* Get the contact_type ID value. */
        FOR i IN get_lookup_type('CONTACT','CONTACT_TYPE',pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
        END LOOP;
 
/* Get the address_type ID value. */
        FOR i IN get_lookup_type('ADDRESS','ADDRESS_TYPE',pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
        END LOOP;
 
/* Get the telephone_type ID value. */
        FOR i IN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
        END LOOP;
 
/* Set save point. */
        SAVEPOINT start_point;

-- Open get Member Cursor --- revisa que exista
        --FETCH get_lookup_type INTO lv_member_id;
          OPEN A;
          fetch a into lv_member_id;
-- Insert row when one does not exist
       -- IF get_lookup_type%NOTFOUND THEN
        IF A%ISOPEN THEN
/* Insert into member table. */
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date);
 
/* Insert into contact table. */
        INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , first_name
        , middle_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_first_name
        , pv_middle_name
        , pv_last_name
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 
/* Insert into ADDRESS table. */
        INSERT INTO address
        ( address_id
        , contact_id
        , address_type
         , city
         , state_province
         , postal_code
         , created_by
         , creation_date
         , last_updated_by
         , last_update_date )
         VALUES
         ( address_s1.NEXTVAL
         , contact_s1.CURRVAL
         , lv_address_type
         , pv_city
         , pv_state_province
         , pv_postal_code
         , lv_created_by
         , lv_creation_date
         , lv_created_by
         , lv_creation_date); 
 
/* Insert into telephone table. */
        INSERT INTO telephone
        ( telephone_id
        , contact_id
        , address_id
        , telephone_type
        , country_code
        , area_code
        , telephone_number
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 end if;
-- close get_lookup_type;
/* Commit the writes to all four tables. */
COMMIT;
 
EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line('ERROR IN PROCEDURE 2: '||SQLERRM);
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;		

-- funtion 1 		
		FUNCTION insert_contact
        ( pv_first_name         VARCHAR2,
          pv_middle_name        VARCHAR2,
          pv_last_name          VARCHAR2,
          pv_contact_type       VARCHAR2,
          pv_account_number     VARCHAR2,
          pv_member_type        VARCHAR2,
          pv_credit_card_number VARCHAR2,
          pv_credit_card_type   VARCHAR2,
          pv_city               VARCHAR2,
          pv_state_province     VARCHAR2,
          pv_postal_code        VARCHAR2,
          pv_address_type       VARCHAR2,
          pv_country_code       VARCHAR2,
          pv_area_code          VARCHAR2,
          pv_telephone_number   VARCHAR2,
          pv_telephone_type     VARCHAR2,
          pv_user_name          VARCHAR2) RETURN NUMBER IS
 
/* Declare local constants. */
        lv_creation_date     DATE := SYSDATE;
 
/* Declare a who-audit ID variable. */
        lv_created_by        NUMBER;
 
/* Declare type variables. */
        lv_member_type       NUMBER;
        lv_credit_card_type  NUMBER;
        lv_contact_type      NUMBER;
        lv_address_type      NUMBER;
        lv_telephone_type    NUMBER;
        lv_user_id           NUMBER;
 
/* Declare a local cursor. */
        CURSOR get_lookup_type
        ( cv_table_name    VARCHAR2
        , cv_column_name   VARCHAR2
        , cv_type_name     VARCHAR2 ) IS
        SELECT common_lookup_id
        FROM   common_lookup
        WHERE  common_lookup_table = cv_table_name
        AND    common_lookup_column = cv_column_name
        AND    common_lookup_type = cv_type_name;
        /**/

BEGIN
/* Get the member_type ID value. */
        FOR i IN get_lookup_type('MEMBER','MEMBER_TYPE',pv_member_type) LOOP
        lv_member_type := i.common_lookup_id;
        END LOOP;
 
/* Get the credit_card_type ID value. */
        FOR i IN get_lookup_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
        END LOOP;
 
/* Get the contact_type ID value. */
        FOR i IN get_lookup_type('CONTACT','CONTACT_TYPE',pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
        END LOOP;
 
/* Get the address_type ID value. */
        FOR i IN get_lookup_type('ADDRESS','ADDRESS_TYPE',pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
        END LOOP;
 
/* Get the telephone_type ID value. */
        FOR i IN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
        END LOOP;
 
/* Get the system user ID value. */
        SELECT system_user_id
        INTO   lv_created_by
        FROM   system_user
        WHERE  system_user_name = pv_user_name;
 
/* Set save point. */
        SAVEPOINT start_point;
 
-- Insert into member table.
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )

        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date);
 
/* Insert into contact table. */
        INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , first_name
        , middle_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_first_name
        , pv_middle_name
        , pv_last_name
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 
/* Insert into ADDRESS table. */
        INSERT INTO address
        ( address_id
        , contact_id
        , address_type
         , city
         , state_province
         , postal_code
         , created_by
         , creation_date
         , last_updated_by
         , last_update_date )
         VALUES
         ( address_s1.NEXTVAL
         , contact_s1.CURRVAL
         , lv_address_type
         , pv_city
         , pv_state_province
         , pv_postal_code
         , lv_created_by
         , lv_creation_date
         , lv_created_by
         , lv_creation_date); 
 
/* Insert into telephone table. */
        INSERT INTO telephone
        ( telephone_id
        , contact_id
        , address_id
        , telephone_type
        , country_code
        , area_code
        , telephone_number
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 
/* Commit the writes to all four tables. */
COMMIT;
 return 0;
EXCEPTION
/* Catch all errors. */
        WHEN OTHERS THEN
                --dbms_output.put_line('['||lv_debug||']['||lv_debug_id||']');
                --dbms_output.put_line('ERROR IN FUNCTION 1: '||SQLERRM);
                ROLLBACK TO start_place;
                return 1;
END insert_contact;
--FUNCTION 2
 FUNCTION insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER ) RETURN NUMBER IS
 
/* Declare local constants. */
        lv_creation_date     DATE := SYSDATE;
 
/* Declare a who-audit ID variable. */
        lv_created_by        NUMBER;
 
/* Declare type variables. */
        lv_member_type       NUMBER;
        lv_credit_card_type  NUMBER;
        lv_contact_type      NUMBER;
        lv_address_type      NUMBER;
        lv_telephone_type    NUMBER;
        lv_user_id           NUMBER;
        
         CURSOR GET_LOOKUP_TYPE
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
        SELECT      common_lookup_id
            FROM    common_lookup
            WHERE   common_lookup_table =   cv_table_name
            AND     common_lookup_column =  cv_column_name
            AND     common_lookup_type =    cv_lookup_type;
            lv_member_id         NUMBER;
        /**/cursor A is SELECT common_lookup_id from common_lookup;
 
BEGIN
/* Get the credit_card_type ID value. */
        FOR i IN get_lookup_type('MEMBER','CREDIT_CARD_TYPE',pv_credit_card_type) LOOP
        lv_credit_card_type := i.common_lookup_id;
        END LOOP;
 
/* Get the contact_type ID value. */
        FOR i IN get_lookup_type('CONTACT','CONTACT_TYPE',pv_contact_type) LOOP
        lv_contact_type := i.common_lookup_id;
        END LOOP;
 
/* Get the address_type ID value. */
        FOR i IN get_lookup_type('ADDRESS','ADDRESS_TYPE',pv_address_type) LOOP
        lv_address_type := i.common_lookup_id;
        END LOOP;
 
/* Get the telephone_type ID value. */
        FOR i IN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type) LOOP
        lv_telephone_type := i.common_lookup_id;
        END LOOP;
 
/* Set save point. */
        SAVEPOINT start_point;

-- Open get Member Cursor
    /*    OPEN get_lookup_type('TELEPHONE','TELEPHONE_TYPE',pv_telephone_type);
        FETCH get_lookup_type INTO lv_member_id;*/
        OPEN A;
        fetch a into lv_member_id;

-- Insert row when one does not exist
        --IF get_lookup_type%NOTFOUND THEN
   IF A%ISOPEN THEN
/* Insert into member table. */
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date);
 
/* Insert into contact table. */
        INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , first_name
        , middle_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_first_name
        , pv_middle_name
        , pv_last_name
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 
/* Insert into ADDRESS table. */
        INSERT INTO address
        ( address_id
        , contact_id
        , address_type
         , city
         , state_province
         , postal_code
         , created_by
         , creation_date
         , last_updated_by
         , last_update_date )
         VALUES
         ( address_s1.NEXTVAL
         , contact_s1.CURRVAL
         , lv_address_type
         , pv_city
         , pv_state_province
         , pv_postal_code
         , lv_created_by
         , lv_creation_date
         , lv_created_by
         , lv_creation_date); 
 
/* Insert into telephone table. */
        INSERT INTO telephone
        ( telephone_id
        , contact_id
        , address_id
        , telephone_type
        , country_code
        , area_code
        , telephone_number
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
        VALUES
         ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_created_by
        , lv_creation_date
        , lv_created_by
        , lv_creation_date); 
 
/* Commit the writes to all four tables. */
COMMIT;

end if;
--close get_lookup_type;
 return 0;
EXCEPTION
/* Catch all errors. */
        WHEN OTHERS THEN
        --dbms_output.put_line('ERROR IN function 2: '||SQLERRM);
		ROLLBACK TO start_place;
		return 1;
end insert_contact;

END contact_package;
/
LIST
SHOW ERRORS
-- insert data

BEGIN
 /*Insert System Users manually*/
 
  INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '6'
        , 'BONDSB'
        , '1'
        , '2'
        , 'Barry'
        , 'Bonds'
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);

        INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '7'
        , 'OWENSR'
        , '1'
        , '2'
        , 'Wardell'
        , 'Curry'
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);

        INSERT INTO system_user
        ( system_user_id
        , system_user_name 
        , system_user_group_id
        , system_user_type
        , first_name
        , last_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( '-1'
        , 'ANONYMOUS'
        , '1'
        , '2'
        , ''
        , ''
        , '1'
        , SYSDATE
        , '1'
        , SYSDATE);
        
        /* You can confirm the inserts with the following query: */
   end; --
   /
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

/*Insert Contacts*/

BEGIN
  contact_package.insert_contact
        ( pv_first_name => 'Charlie'
        , pv_middle_name => ''
        , pv_last_name => 'Brown'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000011'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
        , pv_user_name => 'DBA 3');  --elimine el ultimo parametro      
END;
/

BEGIN
        contact_package.insert_contact
        ( pv_first_name => 'Peppermint'
        , pv_middle_name => ''
        , pv_last_name => 'Patty'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000011'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
       -- , pv_user_name => ''
        , pv_user_id => 0);        
END;
/

BEGIN
        contact_package.insert_contact
        ( pv_first_name => 'Sally'
        , pv_middle_name => ''
        , pv_last_name => 'Brown'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000011'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
        --, pv_user_name => ''
        , pv_user_id => 6);        
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name IN ('Brown','Patty');

begin
-- Function 1
if contact_package.insert_contact(
          pv_first_name => 'Shirley'
        , pv_middle_name => ''
        , pv_last_name => 'Partridge'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000012'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
        , pv_user_name => 'DBA 3'
        ) =0 then
        dbms_output.put_line('function was successful');
        end if;
        
        if  contact_package.insert_contact( 
          pv_first_name => 'Keith'
        , pv_middle_name => ''
        , pv_last_name => 'Partridge'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000012'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
        --, pv_user_name => ''
        , pv_user_id => 6) = 0 then
            dbms_output.put_line('function was successful');
        end if;
        
        IF  contact_package.insert_contact(
          pv_first_name => 'Laurie'
        , pv_middle_name => ''
        , pv_last_name => 'Partridge'
        , pv_contact_type => 'CUSTOMER'
        , pv_account_number => 'SLC-000012'
        , pv_member_type => 'GROUP'
        , pv_credit_card_number => '8888-6666-8888-4444'
        , pv_credit_card_type => 'VISA_CARD'
        , pv_city => 'Lehi'
        , pv_state_province => 'Utah'
        , pv_postal_code => '84043'
        , pv_address_type => 'HOME'
        , pv_country_code => '001'
        , pv_area_code => '207'
        , pv_telephone_number => '877-4321'
        , pv_telephone_type => 'HOME'
        --, pv_user_name => ''
        , pv_user_id => -1) = 0 then
            dbms_output.put_line('function was successful');
        
        end if; 
        
end;
/
--After you call the overloaded insert_contact procedures three times, you should be able to run the following verification query:        


COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';


SHOW ERRORS;

SPOOL OFF;
EXIT;


        
        
 
