--RUN THESE FIRST TWO LINES ON SYSTEM ADMINISTRATOR RDS
CREATE USER LOGIN_TEST_DB IDENTIFIED BY p4ssw0rd;
GRANT DBA TO LOGIN_TEST_DB WITH ADMIN OPTION;

--CONNECT TO NEW USER CREATED BEFORE ALL THESE STEPS

--MAIN ENTITY
CREATE TABLE CUSTOMER
(
  C_ID NUMBER NOT NULL,
  C_FIRSTNAME VARCHAR2(20) NOT NULL,
  C_LASTNAME VARCHAR2(20) NOT NULL,
  C_USERNAME VARCHAR2(20) NOT NULL,
  C_PASSWORD VARCHAR2(100) NOT NULL,
  CONSTRAINT PK_CUSTOMER PRIMARY KEY (C_ID)
);

--UNIQUE CONSTRAINT FOR USERNAME
ALTER TABLE CUSTOMER ADD CONSTRAINT UNQ_USERNAME
  UNIQUE (C_USERNAME);

--SEQUENCE USED FOR AUTOINCREMENT  
CREATE SEQUENCE CUSTOMER_SEQ
  START WITH 1
  INCREMENT BY 1;

--HASHING FUNCTION THAT COMBINES USERNAME, PASSWORD AND A SPECIAL WORD  
CREATE OR REPLACE FUNCTION GET_CUSTOMER_HASH(USERNAME VARCHAR2, PASSWORD VARCHAR2) RETURN VARCHAR2
IS
EXTRA VARCHAR2(10) := 'SALT';
BEGIN
  RETURN TO_CHAR(DBMS_OBFUSCATION_TOOLKIT.MD5(
  INPUT => UTL_I18N.STRING_TO_RAW(DATA => USERNAME || PASSWORD || EXTRA)));
END;
/

--TRIGGET THAT GETS NEXT SEQUENCE VALUE FOR ID AND HASHES BLANK PASSWORD
CREATE OR REPLACE TRIGGER CUSTOMER_B_INSERT
BEFORE INSERT
ON CUSTOMER
FOR EACH ROW
BEGIN
  /* INCREASE THE SEQUENCE */
  IF :NEW.C_ID IS NULL THEN
    SELECT CUSTOMER_SEQ.NEXTVAL INTO :NEW.C_ID FROM DUAL;
  END IF;
  
  /* SAVE HASH INSTEAD OF PASSWORD */
  SELECT GET_CUSTOMER_HASH(:NEW.C_USERNAME,:NEW.C_PASSWORD) INTO :NEW.C_PASSWORD FROM DUAL;
END;
/

--STORED PROCEDURE TO INSERT CUSTOMER
CREATE OR REPLACE PROCEDURE INSERT_CUSTOMER(
FIRSTNAME VARCHAR2, LASTNAME VARCHAR2, USERNAME VARCHAR2, PASSWORD VARCHAR2)
AS
BEGIN
  INSERT INTO CUSTOMER VALUES(NULL, FIRSTNAME, LASTNAME, USERNAME, PASSWORD);
  COMMIT;
END;
/

--TESTING
EXEC INSERT_CUSTOMER('Peter','Alagna','peter','1234');
SELECT * FROM CUSTOMER;
