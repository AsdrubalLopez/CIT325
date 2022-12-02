
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
CREATE OR REPLACE TYPE lyric IS OBJECT
(xnumber VARCHAR(12),
 xstring VARCHAR(50));
/
SPOOL apply_plsql_lab4.txt
DECLARE
TYPE gifts IS TABLE OF lyric;
TYPE days IS TABLE OF VARCHAR(8); /*10*/

 /*initialize*/
lv_days days := days('first','second', 'third', 'fourth', 'fifth','sixth', 'seventh','eighth','ninth','tenth', 
                     'eleventh', 'twelfth');
lv_gifts gifts := gifts(lyric('and a', 'Partrige in apear tree'),
                        lyric('Two','Turtle doves'),
                        lyric('Three', 'French hens'),
                        lyric('Four', 'Calling birds'),
                        lyric('Five','Golden rings'),
                        lyric('Six','Geese a laying'),
                        lyric('Seven','Swans a swimming'),
                        lyric('Eight','Maids a milking'),
                        lyric('Nine', 'Ladies dancing'),
                        lyric('Ten','Lords leaping'),
                        lyric('Eleven', 'Pipers piping'),
                        lyric('Twelve','Drummers drumming')
                        );               
 
BEGIN
    FOR i IN 1..lv_days.COUNT LOOP
        dbms_output.put_line('On the '||lv_days(i) ||' day of Christmas');
        dbms_output.put_line('my true love sent to me:');
        
        FOR j IN  REVERSE 1..lv_gifts.COUNT LOOP
         
          IF i =1 then
            dbms_output.put_line('-A ' ||' and ' ||lv_gifts(1).xstring);
            exit;
          elsif j <= i then -- imprimir en caso de que de que j sea menor o igual a i
            dbms_output.put_line('-' || lv_gifts(j).xnumber ||' '||lv_gifts(j).xstring);
        
          end if;
          
            --dbms_output.put_line(letra);
        END LOOP;
        
        dbms_output.put_line(CHR(13));
    END LOOP;
END;
/


SPOOL OFF

QUIT;
