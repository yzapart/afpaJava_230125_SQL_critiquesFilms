-- =========================== TP1
-- -------------  US1
-- r1
select * from films;
-- r2
select id_films, titre, duree from films;
-- r3
select * from films where date_sortie < date'01-01-2019';
-- r4
select * from films where date_sortie between date'2018-01-01' and date'2019-06-30';
-- r5
select * from films where titre like '%with%';
-- r6
select * from films where titre like 'The%';
-- r7
select * from films order by id_film;

-- =========================== TP2
-- ------------- US2
-- r1
create table genres (id_genre serial primary key, intitule varchar(20));
insert into genres (intitule) values('Drame');
insert into genres (intitule) values('Action');
insert into genres (intitule) values('Comédie');
insert into genres (intitule) values('Documentaire');
insert into genres (intitule) values('Animé');
select * from genres;

-- r2
select count(*) from genres;
-- r3
select max(date_sortie) from films;
-- r4
select min(date_sortie) from films;
-- r5
select * from films where date_sortie = date '2020-10-15';
-- r6
select round(avg(duree),2) from films;
-- r7 8 9
alter table add id_genre int;
update films set id_genre = floor(random()* (select count(*) from genres));
select titre, intitule from films, genres where films.id_genre = genres.id_genre;
-- r10
select round(avg(duree)) from films where id_genre = 1;

-- =========================== TP3
-- ------------- US3
create table inscrits (
	id_inscrit serial primary key, 
	mail varchar(50), 
	pseudo varchar(20), 
	nom varchar(20), 
	prenom varchar(20),
	mdp varchar(20)
	);

create table critiques (
	id_critique serial primary key, 
	id_inscrit int references inscrits(id_inscrit),
	titre varchar(50), 
	contenu text,
	date_validite date
	);

\copy inscrits(mail, pseudo, nom, prenom, mdp) from 'C:\Users\59013-42-16\Desktop\afpa_SQL_230125\liste_inscrits.csv' with (format csv, header false);

-- r1
select * from inscrits order by pseudo asc;
-- r2
select id_genre, count(*) from films group by id_genre;
-- r3
\copy critiques(id_inscrit, titre, contenu, date_validite) from 'C:\Users\59013-42-16\Desktop\afpa_SQL_230125\liste_critiques.csv' delimiter '$' csv;
select id_inscrit,count(*) as "nb de critiques" from critiques group by id_inscrit;
-- r4
select intitule, count(*) as "nb de films" from films, genres where films.id_genre = genres.id_genre group by intitule;
-- r5
select * from films order by date_sortie asc;

-- ------------- US4
alter table critiques add column id_film int references films(id_film);
update critiques set id_film = floor( random() * (select count(*) from films) + 1);
select id_critique, id_inscrit, titre, left(contenu, 20) as contenu, date_validite, id_film from critiques;

-- r1
select films.titre as "Titre film", date_sortie, critiques.titre as "Titre critique", left(contenu, 40) as "Contenu critique" from films,critiques where critiques.id_film = films.id_film;

-- r2
select films.id_film, films.titre as "Titre film", date_sortie, critiques.titre as "Titre critique", left(contenu, 40) as "Contenu critique" from films 
full join critiques 
on films.id_film = critiques.id_film 
order by films.id_film;

-- r3
select titre, duree, date_sortie from films where duree > (select avg(duree) from films);

-- r4
select inscrits.nom, inscrits.prenom, count(*) as "nb critiques" from critiques,inscrits where inscrits.id_inscrit = critiques.id_inscrit group by inscrits.id_inscrit;

-- r5
select nom, prenom, count(contenu) as "nb critiques" from critiques
full join inscrits
on inscrits.id_inscrit = critiques.id_inscrit group by inscrits.id_inscrit;


-- ------------------ creation table "appartient"
create table appartient (
	id_film int references films(id_film), 
	id_genre int references genres(id_genre),
	primary key (id_film, id_genre)
	);

insert into appartient(id_film, id_genre) select id_film,id_genre from films;