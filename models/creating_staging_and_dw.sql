-- movies data warehouse

-- creating staging area

-- adjusting state regions

-- "estado" table

DROP TABLE IF EXISTS AST.AST_ESTADO;

CREATE TABLE AST.AST_ESTADO AS SELECT DISTINCT * FROM ESTADO;

UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 59;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 60;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 61;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 62;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 63;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 64;
UPDATE AST_ESTADO SET CODREGIAO = 8 WHERE NUM = 65;
UPDATE AST_ESTADO SET CODREGIAO = 6 WHERE NUM = 66;
UPDATE AST_ESTADO SET CODREGIAO = 8 WHERE NUM = 67;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 68;
UPDATE AST_ESTADO SET CODREGIAO = 6 WHERE NUM = 69;
UPDATE AST_ESTADO SET CODREGIAO = 8 WHERE NUM = 70;
UPDATE AST_ESTADO SET CODREGIAO = 8 WHERE NUM = 71;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 72;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 73;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 74;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 75;
UPDATE AST_ESTADO SET CODREGIAO = 9 WHERE NUM = 76;
UPDATE AST_ESTADO SET CODREGIAO = 6 WHERE NUM = 77;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 78;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 79;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 80;
UPDATE AST_ESTADO SET CODREGIAO = 9 WHERE NUM = 81;
UPDATE AST_ESTADO SET CODREGIAO = 9 WHERE NUM = 82;
UPDATE AST_ESTADO SET CODREGIAO = 7 WHERE NUM = 83;
UPDATE AST_ESTADO SET CODREGIAO = 6 WHERE NUM = 84;
UPDATE AST_ESTADO SET CODREGIAO = 10 WHERE NUM = 85;

-- adjusting city names

-- "cidade" table

SELECT * FROM CIDADE WHERE (NOME="Rio de Janeiro" OR NOME="Rio de Janerio");

DROP TABLE IF EXISTS AST.AST_CIDADE;

CREATE TABLE AST.AST_CIDADE AS SELECT DISTINCT * FROM CIDADE
EXCEPT
SELECT DISTINCT * FROM CIDADE WHERE (NOME='Rio de Janerio' 
                                     OR (NOME='Rio de Janeiro' AND CODESTADO!=77)
                                     OR NOME='Sao Luiz'
                                     OR (NOME='Santos' AND CODESTADO=77)
                                     OR (NOME='Sao Paulo' AND CODESTADO!=84));

-- "local" table

DROP TABLE IF EXISTS AST.AST_LOCAL;

CREATE TABLE AST.AST_LOCAL AS 
SELECT DISTINCT L.NUM AS num,
                LOCAL,
                CIDADE,
                ESTADO,
                CODREGIAO AS regiao,
                PAIS 
FROM LOCAL AS L JOIN AST_ESTADO AS E ON L.ESTADO=E.NUM;

SELECT * FROM CIDADE WHERE NOME="Rio de Janeiro";
SELECT * FROM AST_CIDADE WHERE NOME="Rio de Janeiro";

UPDATE AST_LOCAL SET CIDADE = 1198 WHERE CIDADE = 1024;
UPDATE AST_LOCAL SET CIDADE = 1198 WHERE CIDADE = 1264;
UPDATE AST_LOCAL SET CIDADE = 1198 WHERE CIDADE = 1416;

SELECT * FROM CIDADE WHERE NOME="Sao Luiz";
SELECT * FROM AST_CIDADE WHERE NOME="Sao Luis";

UPDATE AST_LOCAL SET CIDADE = 1053 WHERE CIDADE = 1055;

SELECT * FROM CIDADE WHERE NOME="Santos";
SELECT * FROM AST_CIDADE WHERE NOME="Santos";

UPDATE AST_LOCAL SET CIDADE = 1424 WHERE CIDADE = 1200;

SELECT * FROM CIDADE WHERE NOME="Sao Paulo";
SELECT * FROM AST_CIDADE WHERE NOME="Sao Paulo";

UPDATE AST_LOCAL SET CIDADE = 1431 WHERE CIDADE = 1007;
UPDATE AST_LOCAL SET CIDADE = 1431 WHERE CIDADE = 1203;
UPDATE AST_LOCAL SET CIDADE = 1431 WHERE CIDADE = 1279;

UPDATE AST_LOCAL SET ESTADO = 84 WHERE CIDADE = 1431;
UPDATE AST_LOCAL SET ESTADO = 84 WHERE CIDADE = 1424;

-- adjusting movie participation and direction

DROP TABLE IF EXISTS AST.AST_PARTIC;

CREATE TABLE AST.AST_PARTIC AS SELECT DISTINCT * FROM PARTIC WHERE NOT (CODARTISTA=52 AND PAPEL="Diretor" AND (CODFILME=326 OR CODFILME=327));

UPDATE AST_PARTIC SET RANK = 1 WHERE (CODARTISTA=52 AND PAPEL="Ator" AND (CODFILME=326 OR CODFILME=327));

-- "sala" table

DROP TABLE IF EXISTS AST.AST_DIM_SALA;

CREATE TABLE AST.AST_DIM_SALA(
SALA_CODE INTEGER PRIMARY KEY,
REGIAO_CODE INTEGER,
REGIAO_NOME TEXT,
CIDADE_CODE INTEGER,
CIDADE_NOME TEXT,
ESTADO_CODE INTEGER,
ESTADO_NOME TEXT);

-- loading data into "sala" table

INSERT INTO AST.AST_DIM_SALA(SALA_CODE,REGIAO_CODE,REGIAO_NOME,CIDADE_CODE,CIDADE_NOME,ESTADO_CODE,ESTADO_NOME) 
SELECT DISTINCT S.NUM AS SALA_CODE,
                L.REGIAO AS REGIAO_CODE,
                R.NOME AS REGIAO_NOME,
                L.CIDADE AS CIDADE_CODE,
                C.NOME AS CIDADE_NOME,
                L.ESTADO AS ESTADO_CODE,
                E.NOME AS ESTADO_NOME 
FROM SALA AS S 
JOIN AST_LOCAL AS L ON S.CODLOCAL=L.NUM 
JOIN REGIAO AS R ON L.REGIAO=R.NUM 
JOIN AST_CIDADE AS C ON L.CIDADE=C.NUM 
JOIN AST_ESTADO AS E ON L.ESTADO=E.NUM;

-- "filme" table

DROP TABLE IF EXISTS AST.AST_DIM_FILME;

CREATE TABLE AST.AST_DIM_FILME(
FILME_CODE INTEGER PRIMARY KEY,
FILME_NOME TEXT,
GENERO TEXT);

-- loading "filme" table

INSERT INTO AST.AST_DIM_FILME(FILME_CODE,FILME_NOME,GENERO)
SELECT DISTINCT F.NUM AS FILME_CODE,
                F.NOME AS FILME_NOME,
                G.NOME AS GENERO
FROM FILME AS F
JOIN GENERO AS G ON F.GENERO=G.NUM;

-- "artista" table

DROP TABLE IF EXISTS AST.AST_DIM_ARTISTA;

CREATE TABLE AST.AST_DIM_ARTISTA(
ARTISTA_CODE INTEGER PRIMARY KEY,
ARTISTA_NOME TEXT);

-- loading "artista" table

INSERT INTO AST.AST_DIM_ARTISTA(ARTISTA_CODE,ARTISTA_NOME)
SELECT DISTINCT A.NUM AS ARTISTA_CODE,
                A.NOME AS ARTISTA_NOME
FROM ARTISTA AS A;

-- "partic" table

DROP TABLE IF EXISTS AST.AST_DIM_PARTIC;

CREATE TABLE AST.AST_DIM_PARTIC(
PARTIC_CODE INTEGER PRIMARY KEY AUTOINCREMENT,
FILME_CODE INTEGER,
FILME_NOME TEXT,
GENERO_CODE INTEGER,
GENERO_NOME TEXT,
ARTISTA_CODE INTEGER,
ARTISTA_NOME TEXT,
RANKING REAL,
PAPEL TEXT,
FOREIGN KEY(FILME_CODE) REFERENCES AST_DIM_FILME(FILME_CODE)
FOREIGN KEY(ARTISTA_CODE) REFERENCES AST_DIM_ARTISTA(ARTISTA_CODE));

-- loading "partic" table

INSERT INTO AST_DIM_PARTIC(FILME_CODE,FILME_NOME,GENERO_CODE,GENERO_NOME,ARTISTA_CODE,ARTISTA_NOME,RANKING,PAPEL)
SELECT P.CODFILME AS FILME_CODE,
       F.NOME AS FILME_NOME,
       F.GENERO AS GENERO_CODE,
       G.NOME AS GENERO_NOME,
       P.CODARTISTA AS ARTISTA_CODE,
       A.NOME AS ARTISTA_NOME,
       RANK/SUM_RANK AS RANKING,
       P.PAPEL 
FROM AST_PARTIC AS P
JOIN(SELECT DISTINCT CODFILME,SUM(RANK) AS SUM_RANK FROM AST_PARTIC GROUP BY(CODFILME)) AS PA ON P.CODFILME=PA.CODFILME
JOIN FILME AS F ON P.CODFILME=F.NUM
JOIN ARTISTA AS A ON P.CODARTISTA=A.NUM
JOIN GENERO AS G ON F.GENERO=G.NUM
ORDER BY FILME_CODE;

-- holidays dimension

DROP TABLE IF EXISTS AST.AST_FERIADO;
CREATE  TABLE  AST.AST_FERIADO (NFER INTEGER PRIMARY KEY,NSEM INTEGER, FER TEXT);
  INSERT INTO AST_FERIADO(FER,NSEM) VALUES
('CONFRATERNIZACAO UNIVERSAL', 0),
('CARNAVAL',                  9),
('PAIXAO DE CRISTO',         15),
('TIRADENTES',               16),
('DIA DO TRABALHO',          17),
('CORPUS CHRISTI',           24),
('INDEPENDENCIA DO BRASIL',  35),
('PADROEIRA DO BRASIL',      40),
('FINADOS',                  43),
('PROCLAMACAO DA REPUBLICA', 45),
('NATAL',                    51);

-- time dimension

DROP TABLE IF EXISTS AST.AST_DIM_TEMPO;

CREATE TABLE AST.AST_DIM_TEMPO(
ANO_SEM INTEGER,
SEM INTEGER,
INI_SEM DATE,
N_DIA_SEMANA INTEGER,
NOME_DIA TEXT,
MES_NOME TEXT,
MES_NOME_AB TEXT,
MES_ANO TEXT,
DIA INTEGER,
MES INTEGER,
ANO INTEGER,
TRI INTEGER,
SEMT INTEGER,
FER TEXT);

-- loading time dimension

INSERT INTO AST_DIM_TEMPO(ANO_SEM,SEM,INI_SEM,N_DIA_SEMANA,NOME_DIA,
                          MES_NOME,MES_NOME_AB,MES_ANO,DIA,MES,ANO,TRI,SEMT,FER)
-- ST_CALENDARIO_AUTO
SELECT 
ANO * 100 + SEM ANO_SEM
, SEM
, INI_SEM
, N_DIA_SEMANA
, NOME_DIA
, MES_NOME
, SUBSTR ( MES_NOME , 1 , 3 ) MES_NOME_AB
, SUBSTR ( MES_NOME , 1 , 3 ) || '/' || ANO MES_ANO
, DIA
, MES
, ANO
, TRI
, SEMT
, FER
FROM (
  WITH RECURSIVE
    ld AS
    ( SELECT date(MIN(DTX),'start of year') DI, date(MAX(DTX),'start of year','+12 month','-1 day') DF FROM
     ( SELECT substr(data,7,4)||'-'||substr(data,4,2)||'-'||substr(data,1,2) DTX FROM EXIBT  ) 
    )
    ,
    dates(d) AS (
    SELECT DI FROM LD
    UNION ALL
    SELECT date(d, '+1 day')
    FROM dates
    WHERE d < ( SELECT DF FROM LD )
    )
  SELECT d INI_SEM ,
    CAST(strftime('%w', d) AS INT) + 1 AS N_DIA_SEMANA,
    CAST(strftime('%W', d ) AS INT) AS SEM,
    CASE
      CAST(strftime('%w', d) AS INT) 
      WHEN 1 THEN 'Segunda-feira'
      WHEN 2 THEN 'Ter???a-feira'
      WHEN 3 THEN 'Quata-feira'
      WHEN 4 THEN 'Quinta-feira'
      WHEN 5 THEN 'Sexta-feira'
      WHEN 6 THEN 'S???bado'
      ELSE 'Domingo'
    END AS NOME_DIA,
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 3 THEN 1
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 4 AND 6 THEN 2
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END AS TRI,
    CASE
      WHEN CAST(strftime('%m', d) AS INT) BETWEEN 1 AND 6 THEN 1
      ELSE 2
    END AS SEMT,
    CAST(strftime('%Y', d) AS INT) AS ANO,
    CAST(strftime('%m', d) AS INT) AS MES,
    CASE CAST(strftime('%m', d) AS INT)
         WHEN  1 THEN 'Janeiro'
         WHEN  2 THEN 'Feveiro'
         WHEN  3 THEN 'Mar???o'
         WHEN  4 THEN 'Abril'
         WHEN  5 THEN 'Maio'
         WHEN  6 THEN 'Junho'
         WHEN  7 THEN 'Julho'
         WHEN  8 THEN 'Agosto'
         WHEN  9 THEN 'Setembro'
         WHEN  10 THEN 'Outubro'
         WHEN  11 THEN 'Novembro'
         ELSE 'Dezembro'
    END AS MES_NOME ,  
    CAST(strftime('%d', d) AS INT) AS DIA
  FROM dates
)
LEFT JOIN AST_FERIADO ON SEM=NSEM
GROUP BY ANO * 100 + SEM;

-- "exibicao" table

DROP TABLE IF EXISTS AST.AST_FT_EXIBICAO_AUX;

CREATE TABLE AST.AST_FT_EXIBICAO_AUX(
PARTIC_CODE INTEGER,
ANO_SEM INTEGER,
DATA TEXT,
SALA_CODE INTEGER,
ARRECAD_PARTIC REAL,
PUBLICO_PARTIC INTEGER,
FOREIGN KEY(PARTIC_CODE) REFERENCES AST_DIM_PARTIC(PARTIC_CODE)
FOREIGN KEY(ANO_SEM) REFERENCES AST_DIM_TEMPO(ANO_SEM)
FOREIGN KEY(SALA_CODE) REFERENCES AST_DIM_SALA(SALA_CODE));

-- loading "exibicao" table

INSERT INTO AST_FT_EXIBICAO_AUX(PARTIC_CODE,DATA,ANO_SEM,SALA_CODE,ARRECAD_PARTIC,PUBLICO_PARTIC)
SELECT PARTIC_CODE,
       SUBSTR(DATA,7,4)||'-'||SUBSTR(DATA,4,2)||'-'||SUBSTR(DATA,1,2) AS DATA,
       CAST(strftime('%Y', SUBSTR(DATA,7,4)||'-'||SUBSTR(DATA,4,2)||'-'||SUBSTR(DATA,1,2)) AS INT) * 100 + 
       CAST(strftime('%W', SUBSTR(DATA,7,4)||'-'||SUBSTR(DATA,4,2)||'-'||SUBSTR(DATA,1,2)) AS INT) AS ANO_SEM,
       CODSALA AS SALA_CODE,
       ARRECAD*RANKING AS ARRECAD_PARTIC,
       PUBLICO*RANKING AS PUBLICO_PARTIC
FROM EXIBT AS E
INNER JOIN AST_DIM_PARTIC AS P ON CODFILME=FILME_CODE;

-- "exibicao em semanas" table

DROP TABLE IF EXISTS AST.AST_FT_EXIBICAO;

CREATE TABLE AST.AST_FT_EXIBICAO(
PARTIC_CODE INTEGER,
ANO_SEM INTEGER,
SALA_CODE INTEGER,
ARRECAD_PARTIC REAL,
PUBLICO_PARTIC INTEGER,
FOREIGN KEY(PARTIC_CODE) REFERENCES AST_DIM_PARTIC(PARTIC_CODE)
FOREIGN KEY(ANO_SEM) REFERENCES AST_DIM_TEMPO(ANO_SEM)
FOREIGN KEY(SALA_CODE) REFERENCES AST_DIM_SALA(SALA_CODE));

-- loading "exibicao em semanas" table

INSERT INTO AST_FT_EXIBICAO(PARTIC_CODE,ANO_SEM,SALA_CODE,ARRECAD_PARTIC,PUBLICO_PARTIC)
SELECT PARTIC_CODE,
       ANO_SEM,
       SALA_CODE,
       SUM(ARRECAD_PARTIC) AS ARRECAD_PARTIC,
       SUM(PUBLICO_PARTIC) AS PUBLICO_PARTIC
FROM AST_FT_EXIBICAO_AUX
GROUP BY PARTIC_CODE,ANO_SEM,SALA_CODE;

-- creating data warehouse tables

-- "sala"

DROP TABLE IF EXISTS DW.DW_DIM_SALA;

CREATE TABLE DW.DW_DIM_SALA(
SALA_CODE INTEGER PRIMARY KEY,
REGIAO_CODE INTEGER,
REGIAO_NOME TEXT,
CIDADE_CODE INTEGER,
CIDADE_NOME TEXT,
ESTADO_CODE INTEGER,
ESTADO_NOME TEXT);

-- loading "sala"

INSERT INTO DW_DIM_SALA(SALA_CODE,REGIAO_CODE,REGIAO_NOME,CIDADE_CODE,CIDADE_NOME,ESTADO_CODE,ESTADO_NOME) 
SELECT * FROM AST_DIM_SALA;

-- "filme"

DROP TABLE IF EXISTS DW.DW_DIM_FILME;

CREATE TABLE DW.DW_DIM_FILME(
FILME_CODE INTEGER PRIMARY KEY,
FILME_NOME TEXT,
GENERO TEXT);

-- loading "filme"

INSERT INTO DW_DIM_FILME(FILME_CODE,FILME_NOME,GENERO)
SELECT * FROM AST_DIM_FILME;

-- "artista"

DROP TABLE IF EXISTS DW.DW_DIM_ARTISTA;

CREATE TABLE DW.DW_DIM_ARTISTA(
ARTISTA_CODE INTEGER PRIMARY KEY,
ARTISTA_NOME TEXT);

-- loading "artista"

INSERT INTO DW_DIM_ARTISTA(ARTISTA_CODE,ARTISTA_NOME)
SELECT * FROM AST_DIM_ARTISTA;

-- "partic"

DROP TABLE IF EXISTS DW.DW_DIM_PARTIC;

CREATE TABLE DW.DW_DIM_PARTIC(
PARTIC_CODE INTEGER PRIMARY KEY AUTOINCREMENT,
FILME_CODE INTEGER,
FILME_NOME TEXT,
GENERO_CODE INTEGER,
GENERO_NOME TEXT,
ARTISTA_CODE INTEGER,
ARTISTA_NOME TEXT,
RANKING REAL,
PAPEL TEXT,
FOREIGN KEY(FILME_CODE) REFERENCES DW_DIM_FILME(FILME_CODE)
FOREIGN KEY(ARTISTA_CODE) REFERENCES DW_DIM_ARTISTA(ARTISTA_CODE));

-- loading "partic"

INSERT INTO DW_DIM_PARTIC(FILME_CODE,FILME_NOME,GENERO_CODE,GENERO_NOME,ARTISTA_CODE,ARTISTA_NOME,RANKING,PAPEL)
SELECT FILME_CODE,FILME_NOME,GENERO_CODE,GENERO_NOME,ARTISTA_CODE,ARTISTA_NOME,RANKING,PAPEL FROM AST_DIM_PARTIC;

-- time

DROP TABLE IF EXISTS DW.DW_DIM_TEMPO;

CREATE TABLE DW.DW_DIM_TEMPO(
ANO_SEM INTEGER,
SEM INTEGER,
INI_SEM DATE,
N_DIA_SEMANA INTEGER,
NOME_DIA TEXT,
MES_NOME TEXT,
MES_NOME_AB TEXT,
MES_ANO TEXT,
DIA INTEGER,
MES INTEGER,
ANO INTEGER,
TRI INTEGER,
SEMT INTEGER,
FER TEXT);

-- loading time

INSERT INTO DW_DIM_TEMPO(ANO_SEM,SEM,INI_SEM,N_DIA_SEMANA,NOME_DIA,
                         MES_NOME,MES_NOME_AB,MES_ANO,DIA,MES,ANO,TRI,SEMT,FER)
SELECT ANO_SEM,SEM,INI_SEM,N_DIA_SEMANA,NOME_DIA,
       MES_NOME,MES_NOME_AB,MES_ANO,DIA,MES,ANO,TRI,SEMT,FER FROM AST_DIM_TEMPO;

-- "exibicao"

DROP TABLE IF EXISTS DW.DW_FT_EXIBICAO;

CREATE TABLE DW.DW_FT_EXIBICAO(
PARTIC_CODE INTEGER,
ANO_SEM INTEGER,
SALA_CODE INTEGER,
ARRECAD_PARTIC REAL,
PUBLICO_PARTIC INTEGER,
FOREIGN KEY(PARTIC_CODE) REFERENCES DW_DIM_PARTIC(PARTIC_CODE)
FOREIGN KEY(ANO_SEM) REFERENCES DW_DIM_TEMPO(ANO_SEM)
FOREIGN KEY(SALA_CODE) REFERENCES DW_DIM_SALA(SALA_CODE));

-- loading "exibicao"

INSERT INTO DW.DW_FT_EXIBICAO(PARTIC_CODE,ANO_SEM,SALA_CODE,ARRECAD_PARTIC,PUBLICO_PARTIC)
SELECT * FROM AST_FT_EXIBICAO;