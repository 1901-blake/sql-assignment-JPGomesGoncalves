---------------Task 2.1---------------
--Task A
select * from employee;
--Task B
select * from employee where lastname = 'King';
--Task C
select * from employee where firstname = 'Andrew' and reportsto is null;
--------------Task 2.2----------------
--Task A
select * from album order by title desc;
--Task B
select firstname from customer order by city;
--------------Task 2.3----------------
--Task A
insert into genre
values(26,'Kyle');
insert into genre
values(27,'weird songs');
--Task B
insert into employee
values(9,'Banner','Bruce','Ceo',7,'2002-08-14 00:00:00','1111 6 Ave SW','Gotham','CH','United States','T5K 2N1','+1 (780) 428-9482','+1 (780) 428-3457','BruceB@chinookorp.com');
insert into employee
values(10,'Banner','Bruce','Ceo',7,'2002-08-14 00:00:00','1111 6 Ave SW','Gotham','CH','United States','T5K 2N1','+1 (780) 428-9482','+1 (780) 428-3457','BruceB@chinookorp.com');
--Task C
insert into customer
values(60,'Kyle','davison',null,'3 Chatham Street','Gotham','CH','United States','00192','+48 22 828 37 39',null,'KyleDav@apple.hu',3);
insert into customer
values(61,'Kyle','davison',null,'3 Chatham Street','Gotham','CH','United States','00192','+48 22 828 37 39',null,'KyleDav@apple.hu',4);
--------------Task 2.4---------------
--Task A
update customer
set firstname = 'Robert',lastname = 'Walter'
where firstname = 'Aaron' and lastname = 'Mitchell';
--Task B
update artist 
set name = 'CCR'
where name = 'Creedence Clearwater Revival';
-------------Task 2.5---------------
select * from invoice
where billingaddress LIKE 'T%';
-------------Task 2.6---------------
--Task A
SELECT * FROM invoice
WHERE total BETWEEN 15 AND 50;
--Task B
SELECT * FROM employee
where hiredate between '2003-06-01' and '2004-03-01';
-------------Task 2.7---------------
do $$
declare 
id int = 60;
begin
	delete from invoiceline
	using invoice
	where invoiceline.invoiceid = invoice.invoiceid and invoice.customerid = id;


	delete from invoice
	where customerid = id;

	delete from customer
	where customerid = id;
end; $$  LANGUAGE plpgsql;

select * from customer ;


------------Task 3.1---------------
--Task A
create or replace function returncurrenttime()
    returns timestamp with time zone 
	language sql
	as $$
	select now();
$$

select returncurrenttime();
--Task B
create or replace function numberofmediatype()
	returns bigint
	language sql 
	as $$
	select count(*) from mediatype as result;
$$

select numberofmediatype();
------------Task 3.2---------------
--Task A
create or replace function averagtotalinvoice()
	returns numeric
	language sql 
	as $$
	select avg(total) from invoice as result;
$$

select averagtotalinvoice();
--Task B
create or replace function expensivetrack()
	returns numeric
	language sql 
	as $$
	select max(unitprice) from track as result;
$$

select expensivetrack();
------------Task 3.3--------------
create or replace function averagpriceinvoiceline()
	returns numeric
	language sql 
	as $$
	select avg(unitprice) from invoiceline;
$$

select averagpriceinvoiceline();
------------Task 3.4--------------
create or replace function bornafter1968()
	returns timestamp without time zone
	language sql 
	as $$
	select birthdate from employee where birthdate > '1968-02-18 00:00:00';
$$

select bornafter1968();
------------Task 4.1--------------
drop function getfullname(refcursor);

--create or replace function getfullname(refs inout refcursor)
--returns refcursor
--AS $$
--begin


	--select firstname , lastname into fname , lname   from employee;
--    OPEN refs for SELECT firstname FROM employee;
	--select lastname into lname  from employee;
--END;
--$$ LANGUAGE plpgsql;
   
--do $$
--declare
--refs
--begin

--select getfullname('employee_full_name');
--fetch all into "employee_full_name";

--end;
--$$  LANGUAGE plpgsql;

select firstname , lastname from employee;
 
 
drop function getempfullname();
 
create or replace function getempfullname(out refs refcursor)
as $$
begin
	open refs for select firstname, lastname from employee;
end;
$$ language plpgsql;

do $$
declare
refs refcursor;
fname text;
lname text;
begin 
	select getempfullname() into refs;
	loop
		fetch refs into fname, lname;
		exit when not found;
		insert into employeenames (firstName, lastName) values (fname, lname);
	end loop;
end;
$$ language plpgsql;
 
create table employeenames(ID serial primary key, firstname text, lastname text);

drop table employeenames;

select * from employeenames;
------------Task 4.2--------------
--Task A
create or replace function change_employee_location(in id int,in var_address text,in var_city text,in var_state text,in var_postalcode text)
returns void as $$
begin
	update employee
	set address = var_address, city = var_city, state = var_state, postalcode = var_postalcode
	where employeeid = id;
end;
$$ language plpgsql;

select change_employee_location(2, 'Classifed', 'Classifed', 'Classifed', 'Classifed');

select * from employee;
--Task B
create or replace function get_employee_manger (in id int, out maneger refcursor)
as $$
begin

	select concat(firstname," ",lastname) from employee into maneger
	where employeeid in (select reportsto from employee where employeeid = id); 

end;
$$ language plpgsql;

select get_employee_manger(2);
------------Task 4.3--------------
create or replace function getnameNcompany (in id int, out var_customer refcursor)
as $$
begin
	select concat('customer: ', firstname, ' ', lastname, ', company: ', company) into var_customer
	from customer where customerid = id;
end;
$$ language plpgsql;

select * from customer;

select getnameNcompany(5);
------------Task 5.0--------------

-- Task A
begin;
	delete from invoiceline where invoiceid = 60;
	delete from invoice where invoiceid = 60;
commit;

select * from customer;

-- Task B
create or replace function insert_customer(in id integer,in fname text,in lname text,in company text,in address text, 
										   in city text,in state text,in country text,in postalcode text,in phone text, 
										   in fax text,in email text,in supportrepid int) 
returns void 
as $$
	begin
		insert into customer values(id, fname, lname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid);
	end;
$$ language plpgsql;

select insert_customer(60, 'John', 'Wick', 'classified', 'classified', 'classified', 'classified', 'US', 'classified', '000-000-000', '000-000-000', 'classified', 3);

select * from customer;

------------Task 6.1--------------
--Task A
drop function afterinserttrigger;

create or replace function afterinserttrigger()
returns trigger AS $$
begin
	 if(TG_OP = 'INSERT') then
	 	update employee
	 	set employeeid = 9
	 	where employeeid = new.employeeid;
	 end if;
	return new;
END;
$$ LANGUAGE plpgsql;

drop trigger last_name_changes on employee;

CREATE TRIGGER last_name_changes
  after insert ON employee
  for each row
  EXECUTE PROCEDURE afterinserttrigger();
 
insert into employee (employeeid,lastname,firstname )
values(9,'what','benny');

delete from employee
where firstname = 'benny';

select * from employee;

--Task B
drop function afterinserttriggeralbum();

create or replace function afterinserttriggeralbum()
returns trigger AS $$
begin
	 if(TG_OP = 'UPDATE') then
	 	insert into album
	 	values(0,'inserted by album trigger',2);
	 end if;
	return new;
END;
$$ LANGUAGE plpgsql;

drop trigger albumtrigger on album;

CREATE TRIGGER albumtrigger
  after update ON album
  EXECUTE PROCEDURE afterinserttriggeralbum();

 select * from album;

update album
set title = 'hip hip horray'
where albumid = 1;

--Task C
create or replace function afterdeletetriggeralbum()
returns trigger AS $$
begin

	 	update customer
	 	set customerid = 4, firstname = 'Goodbye',lastname = 'by trigger'
	    where customerid = 4;
	return new;
END;
$$ LANGUAGE plpgsql;

drop trigger albumtrigger on album;

CREATE TRIGGER customertrigger
  after delete ON customer
  EXECUTE PROCEDURE afterdeletetriggeralbum();

 select * from customer where customerid = 4;

	delete from invoiceline
	using invoice
	where invoiceline.invoiceid = invoice.invoiceid and invoice.customerid = 3;

	delete from invoice
	where customerid = 3;

delete from customer where customerid = 3;
------------Task 7.1--------------
select customer.firstname, customer.lastname,invoice.invoiceid
from customer
inner join invoice on 
customer.customerid = invoice.customerid;
------------Task 7.2--------------
select customer.firstname, customer.lastname,invoice.invoiceid,invoice.total
from customer
full outer join invoice on 
customer.customerid = invoice.customerid;
------------Task 7.3--------------
select artist."name",album.title
from artist
RIGHT join album on 
artist.artistid = album.artistid;
------------Task 7.4--------------
select artist."name",album.title
from artist
cross join album
order by artist."name";
------------Task 7.5--------------
select E1.reportsto as employee1, E2.reportsto as employee2
from employee E1, employee E2
where E1.reportsto = E2.reportsto;