/*drop table alimentação;
drop table exercício;
drop table notificações;
drop table objetivos_dia;
drop table pagamentos;
drop table perfil;
drop table valores_dia;
drop table utilizador cascade constraints;
drop type names_type;
drop type table_notificacoes;
drop type table_pagamentos;
drop type table_valores_dia;
drop type table_view;
drop type row_notificacoes;
drop type row_obj_dia;
drop type row_pagamentos;
drop type row_perfile;
drop type row_utilizador;
drop type row_valores_dia;
drop type row_view;*/

--início do modeler
CREATE TABLE exercício (
    id_exe                INTEGER NOT NULL,
    nome                  VARCHAR2(64),
    data                  DATE,
    nr_de_passos          INTEGER,
    distância_percorrida  INTEGER,
    calorias_perdidas     INTEGER,
    ritmo_cardíaco        INTEGER,
    início                VARCHAR2(8),
    fim                   VARCHAR2(8),
    utilizador_id         INTEGER NOT NULL
);

ALTER TABLE exercício ADD CONSTRAINT exercício_pk PRIMARY KEY ( id_exe );

CREATE TABLE notificações (
    id_notificação  INTEGER NOT NULL,
    data            DATE,
    ritmo_cardíaco  INTEGER,
    utilizador_id   INTEGER NOT NULL
);

ALTER TABLE notificações ADD CONSTRAINT notificações_pk PRIMARY KEY ( id_notificação );

CREATE TABLE objetivos_dia (
    data                    DATE NOT NULL,
    número_de_passos_a_dar  INTEGER,
    distância_a_percorrer   INTEGER,
    calorias_a_queimar      INTEGER,
    utilizador_id           INTEGER NOT NULL
);

CREATE TABLE pagamentos (
    id_pagamento integer,
    data_de_pagamento  DATE NOT NULL,
    valor              INTEGER not null,
    utilizador_id      INTEGER NOT NULL
);

ALTER TABLE pagamentos ADD CONSTRAINT pagamentos_pk PRIMARY KEY ( id_pagamento );

CREATE TABLE perfil (
    id_perfil           INTEGER NOT NULL,
    peso                INTEGER,
    altura              INTEGER,
    data_de_nascimento  DATE,
    utilizador_id       INTEGER NOT NULL
);

ALTER TABLE perfil ADD CONSTRAINT perfil_pk PRIMARY KEY ( id_perfil );

CREATE TABLE utilizador (
    id                 INTEGER NOT NULL,
    primeiro_nome      VARCHAR2(64) NOT NULL,
    último_nome        VARCHAR2(64) NOT NULL,
    data_de_inscrição  DATE,
    tipo_de_serviço    VARCHAR2(64),
    ativo              INTEGER,
    data_de_ativacao   DATE,
    data_de_expiracao  DATE 
);

ALTER TABLE utilizador ADD CONSTRAINT utilizador_pk PRIMARY KEY ( id );

CREATE TABLE valores_dia (
    data                  DATE NOT NULL,
    nr_passos             INTEGER,
    distância_percorrida  INTEGER,
    calorias_perdidas     INTEGER,
    utilizador_id         INTEGER NOT NULL
);

CREATE TABLE alimentação (
    alimento  VARCHAR2(64) NOT NULL,
    calorias  INTEGER
);

ALTER TABLE alimentação ADD CONSTRAINT alimentação_pk PRIMARY KEY ( alimento );

ALTER TABLE exercício
    ADD CONSTRAINT exercício_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );

ALTER TABLE notificações
    ADD CONSTRAINT notificações_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );

ALTER TABLE objetivos_dia
    ADD CONSTRAINT objetivos_dia_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );

ALTER TABLE pagamentos
    ADD CONSTRAINT pagamentos_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );

ALTER TABLE perfil
    ADD CONSTRAINT perfil_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );

ALTER TABLE valores_dia
    ADD CONSTRAINT valores_dia_utilizador_fk FOREIGN KEY ( utilizador_id )
        REFERENCES utilizador ( id );
--fim do modeler

/*SELECT 
    to_char(SYSDATE, 'HH24:MI:SS') 
FROM 
    dual;
    
select CURRENT_TIMESTAMP from dual;*/

/*drop table tempotemporario;

create table tempotemporario(
tempo varchar(8)
)

INSERT INTO tempotemporario (tempo)
SELECT to_char(SYSDATE, 'HH24:MI:SS') FROM dual;

select * from tempotemporario;*/

--atualizar tempo de início do exercício com id=1
/*
describe medição;
insert into medição (ID_MEDIÇÃO, EXERCÍCIO_ID_EXE) values (2,1); --criar row e depois os updates completam a row

UPDATE medição  --adicionar tempo como antes
   SET (Tempo) = (SELECT to_char(SYSDATE, 'HH24:MI:SS') FROM dual
                        WHERE ID_MEDIÇÃO = 2)
                        
    WHERE EXISTS (
    SELECT 1
      FROM dual
     WHERE ID_MEDIÇÃO = 2);    
     
select * from medição;
     
update medição --adicionar data, ritmo card e hidratação 
   set DATA = to_date(sysdate), RITMO_CARDÍACO = 60, HIDRATAÇÃO = 50
   where ID_MEDIÇÃO = 2;*/
     
/*create or replace NONEDITIONABLE PROCEDURE print_contact(in_customer_id NUMBER )
is
  l_customer_name utilizador.ID%TYPE;
BEGIN
  -- get name of the customer 100 and assign it to l_customer_name
  SELECT ID INTO l_customer_name
  FROM utilizador
  WHERE ID = in_customer_id;
  -- show the customer name
  dbms_output.put_line( l_customer_name );
END;
/*/

--call print_contact(1);

/*CREATE OR REPLACE TRIGGER utilizador_update_firstname_trg 
BEFORE UPDATE OF PRIMEIRO_NOME 
ON utilizador 
FOR EACH ROW WHEN (NEW.PRIMEIRO_NOME = 'Jaime') 
BEGIN 
   raise_application_error(-20101,'É o jaime, não será adicionado');
END;
/*/

/*create or replace trigger data_valores_dia_trig
--before update on valores_dia
after insert on exercício
for each row
begin
    insert into valores_dia (DATA, UTILIZADOR_ID) values (sysdate, 1);
end;
/*/

create or replace trigger notificacao_trig
after insert on exercício
for each row WHEN (NEW.RITMO_CARDÍACO < 50 or NEW.RITMO_CARDÍACO > 90) --aqui
declare teste integer;
begin
    --select id into notif_id_exe from dual;
    --insert into notificações (data, utilizador_id) select (
    teste:= get_idade(:NEW.UTILIZADOR_ID);
    if(:NEW.RITMO_CARDÍACO < 50 - teste or :NEW.RITMO_CARDÍACO > 90 + teste) then
    insert into notificações (ID_NOTIFICAÇÃO, data, ritmo_cardíaco, UTILIZADOR_ID) values ((SELECT COUNT(*) "ID_NOTIFICAÇÃO" FROM notificações ) + 1, to_char(SYSDATE, 'yyyy/mm/dd'), :NEW.RITMO_CARDÍACO, :NEW.UTILIZADOR_ID);
    
    end if;
end;
/

create or replace Function get_idade(get_id integer)
return integer
is
idade integer;
data_temp date;
begin
select data_de_nascimento into data_temp from perfil where utilizador_id = get_id;
idade := (sysdate - data_temp)/365;
return(idade);
end;
/

create or replace NONEDITIONABLE PROCEDURE CREATE_USER(nome_primeiro VARCHAR, nome_ultimo VARCHAR, serivico_tipo VARCHAR, ativado_num integer, peso_valor integer, altura_valor integer, data_de_nascimento_valor date)
is
BEGIN
insert into utilizador (ID, PRIMEIRO_NOME, ÚLTIMO_NOME, DATA_DE_INSCRIÇÃO, TIPO_DE_SERVIÇO, ATIVO, data_de_ativacao) values ((SELECT COUNT(*) "ID" FROM utilizador ) + 1, nome_primeiro, nome_ultimo, SYSDATE ,serivico_tipo, ativado_num, to_char(SYSDATE, 'yyyy/mm/dd'));
insert into perfil(ID_PERFIL, PESO, ALTURA, DATA_DE_NASCIMENTO, UTILIZADOR_ID) values ((SELECT COUNT(*) "ID" FROM perfil) + 1, peso_valor, altura_valor, data_de_nascimento_valor, (SELECT COUNT(*) "ID" FROM utilizador));
insert into objetivos_dia (DATA, NÚMERO_DE_PASSOS_A_DAR, DISTÂNCIA_A_PERCORRER, CALORIAS_A_QUEIMAR, UTILIZADOR_ID) values (to_char(SYSDATE, 'yyyy/mm/dd'), (dbms_random.value(1, 5)) * 1000, dbms_random.value(1, 5), (dbms_random.value(3, 1)) * 1000, (SELECT COUNT(*) "ID" FROM utilizador)); 
END;
/

create or replace NONEDITIONABLE PROCEDURE change_daily_objectives(daily_user_id integer) --aqui3
is
l_exst integer;
begin
select case when exists(select CALORIAS_A_QUEIMAR from objetivos_dia where UTILIZADOR_ID = daily_user_id and data = to_char(SYSDATE, 'yyyy/mm/dd')) 
            then  1
            else 0
            end  into l_exst from dual;
    
    if l_exst = 0 then update objetivos_dia 
                         set DATA = to_char(SYSDATE, 'yyyy/mm/dd') where UTILIZADOR_ID = daily_user_id;
    end if; 

update objetivos_dia
    set
        NÚMERO_DE_PASSOS_A_DAR = (dbms_random.value(1, 5))*1000,
        DISTÂNCIA_A_PERCORRER = dbms_random.value(1, 5),
        CALORIAS_A_QUEIMAR = (dbms_random.value(3, 1))*1000
    where data = to_char(SYSDATE, 'yyyy/mm/dd') and UTILIZADOR_ID = daily_user_id;
end;
/

create or replace Function EXISTS_USER(check_id INTEGER) 
return integer
is
existes integer;
BEGIN
SELECT COUNT(utilizador.ID) into existes FROM utilizador where utilizador.ID = check_id;
dbms_output.put_line(existes);
return(existes);
END ;
/

create or replace NONEDITIONABLE PROCEDURE CHANGE_USER_SERVICE(check_id INTEGER, service_type integer) 
is
tipo_atual varchar2(64);
BEGIN
select utilizador.tipo_de_serviço into tipo_atual from utilizador where utilizador.id = check_id;
if service_type = 0 then
update utilizador  set tipo_de_serviço = 'free' where id = check_id;
end if;
if service_type = 1 then
update utilizador  set tipo_de_serviço = 'premium' where id = check_id;
end if;
END;
/

CREATE OR REPLACE TYPE row_utilizador IS OBJECT
(
    id                 INTEGER,
    primeiro_nome      VARCHAR2(64),
    último_nome        VARCHAR2(64),
    data_de_inscrição  DATE,
    tipo_de_serviço    VARCHAR2(64),
    ativo              INTEGER,
    data_de_ativacao   date,
    data_de_expiracao   date
);
/

create or replace Function GET_USER(get_id INTEGER)
return row_utilizador
is
user_new row_utilizador;
BEGIN
user_new := row_utilizador(0, 'primeiro', 'segundo', to_date('2017/11/02', 'yyyy/mm/dd'), 'free', 0, to_date('2017/11/02', 'yyyy/mm/dd'), to_date('2017/11/02', 'yyyy/mm/dd'));
select id into user_new.id from utilizador where utilizador.id = get_id;
select primeiro_nome into user_new.primeiro_nome from utilizador where utilizador.id = get_id;
select último_nome into user_new.último_nome from utilizador where utilizador.id = get_id;
select data_de_inscrição into user_new.data_de_inscrição from utilizador where utilizador.id = get_id;
select tipo_de_serviço into user_new.tipo_de_serviço from utilizador where utilizador.id = get_id;
select ativo into user_new.ativo from utilizador where utilizador.id = get_id;
select data_de_ativacao into user_new.data_de_ativacao from utilizador where utilizador.id = get_id;
select data_de_expiracao into user_new.data_de_expiracao from utilizador where utilizador.id = get_id;
return(user_new);
END ;
/

CREATE OR REPLACE TYPE row_obj_dia IS OBJECT
(
    datas                   DATE,
    número_de_passos_a_dar  INTEGER,
    distância_a_percorrer   INTEGER,
    calorias_a_queimar      INTEGER,
    utilizador_id           INTEGER
);
/

create or replace Function GET_OBJETIVOS_DIA(get_data date)
return row_obj_dia
is
obj_dia_new row_obj_dia;
BEGIN
obj_dia_new := row_obj_dia(to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0, 0, 0);
select data into obj_dia_new.datas from objetivos_dia where objetivos_dia.data = get_data;
select número_de_passos_a_dar into obj_dia_new.número_de_passos_a_dar from objetivos_dia where objetivos_dia.data = get_data;
select distância_a_percorrer into obj_dia_new.distância_a_percorrer from objetivos_dia where objetivos_dia.data = get_data;
select calorias_a_queimar into obj_dia_new.calorias_a_queimar from objetivos_dia where objetivos_dia.data = get_data;
select utilizador_id into obj_dia_new.utilizador_id from objetivos_dia where objetivos_dia.data = get_data;
return(obj_dia_new);
END ;
/

CREATE OR REPLACE TYPE row_perfile IS OBJECT
(
    id_perfil           INTEGER,
    peso                INTEGER,
    altura              INTEGER,
    data_de_nascimento  DATE,
    utilizador_id       INTEGER
);
/

create or replace Function GET_PERFIL(get_id integer)
return row_perfile
is
perfile_new row_perfile;
BEGIN
perfile_new := row_perfile(0, 0, 0, to_date('2017/11/02', 'yyyy/mm/dd'), 0);
select id_perfil into perfile_new.id_perfil from perfil where perfil.id_perfil = get_id;
select peso into perfile_new.peso from perfil where perfil.id_perfil = get_id;
select altura into perfile_new.altura from perfil where perfil.id_perfil = get_id;
select data_de_nascimento into perfile_new.data_de_nascimento from perfil where perfil.id_perfil = get_id;
select utilizador_id into perfile_new.utilizador_id from perfil where perfil.id_perfil = get_id;
return(perfile_new);
END ;
/

CREATE OR REPLACE TYPE row_valores_dia IS OBJECT
(
    data                  DATE,
    nr_passos             INTEGER,
    distância_percorrida  INTEGER,
    calorias_perdidas     INTEGER,
    utilizador_id         INTEGER
);
/

create or replace Function GET_VALORES_DIA(get_id integer, data_new date)
return row_valores_dia
is
valores_dia_new row_valores_dia;
BEGIN
valores_dia_new := row_valores_dia(to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0, 0, 0);
select data into valores_dia_new.data from valores_dia where valores_dia.utilizador_id = get_id and valores_dia.data = data_new;
select nr_passos into valores_dia_new.nr_passos from valores_dia where valores_dia.utilizador_id = get_id and valores_dia.data = data_new;
select distância_percorrida into valores_dia_new.distância_percorrida from valores_dia where valores_dia.utilizador_id = get_id and valores_dia.data = data_new;
select calorias_perdidas into valores_dia_new.calorias_perdidas from valores_dia where valores_dia.utilizador_id = get_id and valores_dia.data = data_new;
select utilizador_id into valores_dia_new.utilizador_id from valores_dia where valores_dia.utilizador_id = get_id and valores_dia.data = data_new;
return(valores_dia_new);
END ;
/

CREATE OR REPLACE TYPE row_pagamentos IS OBJECT
(
    id_pagamento       integer,
    data_de_pagamento  DATE,
    valor              INTEGER,
    utilizador_id      INTEGER
);
/

create or replace NONEDITIONABLE PROCEDURE send_PAGAMENTO(get_id integer)
is
temp varchar2(64);
BEGIN
select tipo_de_serviço into temp from utilizador where id = get_id;
if temp = 'free' then
insert into pagamentos (ID_pagamento, DATA_DE_PAGAMENTO, VALOR, UTILIZADOR_ID) values ((SELECT COUNT(*) "ID" FROM pagamentos ) + 1, to_char(SYSDATE, 'yyyy/mm/dd'), 1, get_id);
end if;
END ;
/

create or replace NONEDITIONABLE PROCEDURE get_PAGAMENTO(send_id integer)
is
BEGIN
delete from pagamentos where pagamentos.utilizador_id = send_id;
CHANGE_USER_SERVICE(send_id, 1);
END;
/

create or replace NONEDITIONABLE PROCEDURE SEND_STATS_EXERCICIO(nome_new varchar, nr_de_passos_new integer, distancia_percorrida_new integer, calorias_perdidas_new integer, bat_card_new integer, id_new integer)
is
l_exst integer;
temp integer;
BEGIN

select peso into temp from perfil where utilizador_id = id_new;
if temp < calorias_perdidas_new then
temp := 0;
else
temp := calorias_perdidas_new;
end if;

insert into EXERCÍCIO (ID_EXE, NOME, DATA, NR_DE_PASSOS, DISTÂNCIA_PERCORRIDA, CALORIAS_PERDIDAS, RITMO_CARDÍACO, UTILIZADOR_ID) values ((SELECT COUNT(*) "ID" FROM EXERCÍCIO )+1, nome_new, to_char(SYSDATE, 'yyyy/mm/dd'), nr_de_passos_new, distancia_percorrida_new,temp, bat_card_new, id_new);
UPDATE exercício
   SET (Início, Fim) = (SELECT to_char(SYSDATE, 'HH24:MI:SS'), (to_char(SYSDATE+ dbms_random.value(5, 30)*interval '1' minute, 'HH24:MI:SS'))  FROM dual
                        WHERE ID_EXE = (SELECT COUNT(*) "ID" FROM EXERCÍCIO ))
                        
    WHERE EXISTS (
    SELECT 1
      FROM dual
     WHERE ID_EXE = (SELECT COUNT(*) "ID" FROM EXERCÍCIO )); 
     
select case when exists(select calorias_perdidas from valores_dia where utilizador_id = id_new and data = to_char(sysdate,'yyyy/mm/dd')) 
            then  1
            else 0
            end  into l_exst from dual;
    if l_exst = 0 then insert into valores_dia (DATA, NR_PASSOS, DISTÂNCIA_PERCORRIDA, CALORIAS_PERDIDAS, UTILIZADOR_ID) values (to_char(sysdate,'yyyy/mm/dd'), 0, 0, 0, id_new);
    end if; 
    
update valores_dia
set
NR_PASSOS = NR_PASSOS+ nr_de_passos_new,
CALORIAS_PERDIDAS = CALORIAS_PERDIDAS + temp,
DISTÂNCIA_PERCORRIDA = DISTÂNCIA_PERCORRIDA + distancia_percorrida_new
where UTILIZADOR_ID = id_new and DATA = to_char(sysdate,'yyyy/mm/dd');

update perfil
set
peso = peso - temp where utilizador_id = id_new;
END;
/

CREATE Or REPLACE TYPE names_type AS VARRAY(3) OF VARCHAR2(64); 
/

create or replace NONEDITIONABLE PROCEDURE exercicio_done(nr_chosed integer, id_chose integer)
is
names names_type;
BEGIN
names := names_type('caminhada', 'bicicleta', 'corrida');
SEND_STATS_EXERCICIO(names(nr_chosed), nr_chosed * dbms_random.value(1, 10000), (3 - nr_chosed) * dbms_random.value(1, 10),nr_chosed * dbms_random.value(1, 100), dbms_random.value(40 - nr_chosed * 10, 100 + nr_chosed * 10), id_chose);
END;
/

create or replace NONEDITIONABLE PROCEDURE pagar(id_chosed integer)
is
BEGIN
send_Pagamento(id_chosed);
CHANGE_USER_SERVICE(id_chosed, 1);
END;
/

create or replace NONEDITIONABLE PROCEDURE ativar_desativar(id_chosed integer, mode_new integer)
is
BEGIN
update utilizador
set 
ativo = mode_new
where id = id_chosed;

if mode_new = 0 then
update utilizador
set 
data_de_expiracao = to_char(SYSDATE, 'yyyy/mm/dd')
where id = id_chosed;
end if;

if mode_new = 1 then
update utilizador
set 
data_de_ativacao = to_char(SYSDATE, 'yyyy/mm/dd')
where id = id_chosed;
end if;

END;
/

CREATE Or REPLACE TYPE table_valores_dia AS VARRAY(16) OF row_valores_dia; 
/

create or replace Function ver_valores_diarios(starting_date date, finishing_date date, search_id integer)
return table_valores_dia
is
tempe table_valores_dia;
l_exst integer;
temp integer;
counter integer;
counter2 integer;
BEGIN
tempe := table_valores_dia(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
counter2 :=1;
SELECT COUNT(*) into temp from valores_dia;
for counter in 1..(finishing_date - starting_date) loop
        select case when exists(select data from valores_dia where valores_dia.data = starting_date + counter and utilizador_id = search_id) 
                then  1
                else 0
                end  into l_exst from dual;
        if l_exst = 1 then
            tempe(counter2) := row_valores_dia(to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0, 0, 0);
            select data into tempe(counter2).data from valores_dia where valores_dia.data = starting_date + counter * interval '1' day and utilizador_id = search_id;
            select nr_passos into tempe(counter2).nr_passos from valores_dia where valores_dia.data = starting_date + counter * interval '1' day  and utilizador_id = search_id;
            select distância_percorrida into tempe(counter2).distância_percorrida from valores_dia where valores_dia.data = starting_date + counter * interval '1' day  and utilizador_id = search_id;
            select calorias_perdidas into tempe(counter2).calorias_perdidas from valores_dia where valores_dia.data = starting_date + counter * interval '1' day  and utilizador_id = search_id;
            select utilizador_id into tempe(counter2).utilizador_id from valores_dia where valores_dia.data = starting_date + counter * interval '1' day  and utilizador_id = search_id;
            counter2 := counter2 + 1;
        end if;
end loop;
return(tempe);
END;
/

CREATE OR REPLACE TYPE row_notificacoes IS OBJECT
(
    id_notificação  INTEGER,
    data            DATE,
    ritmo_cardíaco  INTEGER,
    utilizador_id   INTEGER
);
/

CREATE Or REPLACE TYPE table_notificacoes AS VARRAY(20) OF row_notificacoes; 
/

create or replace Function ver_notificacoes_semana(id_chosed integer)
return table_notificacoes
is
tempe table_notificacoes;
tempo integer;
l_exst integer;
counter integer;
counter2 integer;
counter3 integer;
BEGIN
    tempe := table_notificacoes(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
    tempo:= 0;
    counter := 0;
    counter2 := 1;
    counter3 := 1;
    for tempo in 1..7 loop
    SELECT COUNT(*) into counter from notificações;
    for counter2 in 1..counter loop
        select case when exists(select id_notificação from notificações where notificações.data = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_notificação = counter2 and utilizador_id = id_chosed) 
                then  1
                else 0
                end  into l_exst from dual;
        if l_exst = 1 then
            tempe(counter3) := row_notificacoes(counter3, to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0);
            select id_notificação into tempe(counter3).id_notificação from notificações where notificações.data = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_notificação = counter2 and utilizador_id = id_chosed;
            select data into tempe(counter3).data from notificações where notificações.data = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_notificação = counter2 and utilizador_id = id_chosed;
            select ritmo_cardíaco into tempe(counter3).ritmo_cardíaco from notificações where notificações.data = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_notificação = counter2 and utilizador_id = id_chosed;
            select utilizador_id into tempe(counter3).utilizador_id from notificações where notificações.data = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_notificação = counter2 and utilizador_id = id_chosed;
            counter3 := counter3 + 1;
        end if;
    end loop;
    end loop;
    return(tempe);
END;
/

CREATE OR REPLACE TYPE row_pagamentos IS OBJECT
(
    id_pagamento        integer,
    data_de_pagamento   DATE,
    valor               INTEGER,
    utilizador_id       INTEGER
);
/

CREATE Or REPLACE TYPE table_pagamentos AS VARRAY(20) OF row_pagamentos; 
/

create or replace Function ver_pagamentos_ate_agora(data_inicial date)
return table_pagamentos
is
tempe table_pagamentos;
tempo integer;
l_exst integer;
counter integer;
counter2 integer;
counter3 integer;
counter4 integer;
BEGIN
    tempe := table_pagamentos(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
    tempo:= 0;
    counter := 0;
    counter2 := 1;
    counter3 := 1;
    counter4 := 1;
    counter4 := (sysdate - data_inicial) + 1;
    SELECT COUNT(*) into counter from pagamentos;
    for tempo in 1..counter4 loop
    for counter2 in 1..counter loop
        select case when exists(select id_pagamento from pagamentos where pagamentos.data_de_pagamento = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_pagamento = counter2) 
                then  1
                else 0
                end  into l_exst from dual;
        if l_exst = 1 then
            tempe(counter3) := row_pagamentos(0, to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0);
            select id_pagamento into tempe(counter3).id_pagamento from pagamentos where pagamentos.data_de_pagamento = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_pagamento = counter2;
            select valor into tempe(counter3).valor from pagamentos where pagamentos.data_de_pagamento = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_pagamento = counter2;
            select data_de_pagamento into tempe(counter3).data_de_pagamento from pagamentos where pagamentos.data_de_pagamento = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_pagamento = counter2;
            select utilizador_id into tempe(counter3).utilizador_id from pagamentos where pagamentos.data_de_pagamento = to_char(SYSDATE - (tempo - 1) * interval '1' day, 'yyyy/mm/dd') and id_pagamento = counter2;
            counter3 := counter3 + 1;
        end if;
    end loop;
    end loop;
    return(tempe);
END;
/

CREATE OR REPLACE TYPE row_view IS OBJECT
(
    id                  integer,
    primeiro_nome       VARCHAR2(64),
    ultimo_nome         VARCHAR2(64),
    data_de_inscricao   DATE,
    tipo_de_servico     VARCHAR2(64),
    ativo               INTeger(38),
    data_de_ativacao    DATE,
    data_de_expiracao   DATE,
    valor_pago          integer(38)
);
/

CREATE Or REPLACE TYPE table_view AS VARRAY(20) OF row_view; 
/

create or replace Function ver_utilizadores_nao_ativos
return table_view
is
tempe table_view;
tempo integer;
l_exst integer;
counter integer;
counter2 integer;
counter3 integer;
price integer(38);
BEGIN
    tempe := table_view(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
    tempo:= 0;
    counter := 0;
    counter2 := 1;
    counter3 := 1;
    price := 0;
    SELECT COUNT(*) into counter from utilizador;
    for counter2 in 1..counter loop
        select case when exists(select ativo from utilizador where utilizador.ativo = 0 and id = counter2) 
                then  1
                else 0
                end  into l_exst from dual;
        if l_exst = 1 then
            tempe(counter3) := row_view(counter3, 'primeiro', 'segundo', to_date('2017/11/02', 'yyyy/mm/dd'), 0, 0, to_date('2017/11/02', 'yyyy/mm/dd'), to_date('2017/11/02', 'yyyy/mm/dd'), 0);
            select id into tempe(counter3).id from utilizador where utilizador.ativo = 0 and id = counter2;
            select primeiro_nome into tempe(counter3).primeiro_nome from utilizador where utilizador.ativo = 0 and id = counter2;
            select último_nome into tempe(counter3).ultimo_nome from utilizador where utilizador.ativo = 0 and id = counter2;
            select data_de_inscrição into tempe(counter3).data_de_inscricao from utilizador where utilizador.ativo = 0 and id = counter2;
            select tipo_de_serviço into tempe(counter3).tipo_de_servico from utilizador where utilizador.ativo = 0 and id = counter2;
            select ativo into tempe(counter3).ativo from utilizador where utilizador.ativo = 0 and id = counter2;
            select data_de_ativacao into tempe(counter3).data_de_ativacao from utilizador where utilizador.ativo = 0 and id = counter2;
            select data_de_expiracao into tempe(counter3).data_de_expiracao from utilizador where utilizador.ativo = 0 and id = counter2;
            
            select sum(valor) into price from pagamentos where utilizador_id = counter2;
            tempe(counter3).valor_pago := price;
            counter3 := counter3 + 1;
        end if;
    end loop;
    return(tempe);
END;
/

create or replace NONEDITIONABLE PROCEDURE comer(comida varchar, id_chose integer)
is
temp integer;
BEGIN
select calorias into temp from alimentação where alimento = comida;
update perfil
set
peso = peso + temp where utilizador_id = id_chose;
END;
/

insert into alimentação (alimento, calorias) values ('hamburguer',100);
insert into alimentação (alimento, calorias) values ('salada',50);
insert into alimentação (alimento, calorias) values ('sumo',10);
insert into alimentação (alimento, calorias) values ('água',5);

/*
call CREATE_USER('tomas', 'limpinho', 'free', 0, 80000, 180,to_char(SYSDATE, 'yyyy/mm/dd'));

select * from utilizador;
select * from perfil;
select * from objetivos_dia;

call exercicio_done(3, 2); --names_type('caminhada', 'bicicleta', 'corrida');

select * from exercício;
select * from valores_dia;

select ver_valores_diarios(to_char(SYSDATE - interval '9' day, 'yyyy/mm/dd'), to_char(SYSDATE + interval '9' day, 'yyyy/mm/dd'), 2) from dual;

select ver_notificacoes_semana(2) from dual;
select * from notificações;

call pagar(1);
select * from utilizador;
select ver_pagamentos_ate_agora(to_char(SYSDATE, 'yyyy/mm/dd')) from dual;
select * from pagamentos;

select ver_utilizadores_nao_ativos from dual;
call ativar_desativar(1, 0);
select * from utilizador;

select * from alimentação;
select sum(calorias) from alimentação; --comer do dia
call comer('água', 2); --nao esta boa
select * from perfil;*/
