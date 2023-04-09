use db_mysql;

-- Task 1  -- total amount of money spend on each product, order in descending
drop table shopping_history; 

CREATE TABLE IF NOT EXISTS shopping_history(
product varchar(20) not null,
quantity integer not null,
unit_price integer not null
);

insert into shopping_history 
values ('milk',3,10),
('bread',7,3),
('bread',5,2) ;

select * from shopping_history;

-- total amount of money spend on each product, order in descending
select product,sum(quantity*unit_price) as total_price
from shopping_history
group by 1
order by 1 DESC;

-- task 2 
-- clients talked for atleast 10 Mins

drop table phones;
create table if not exists phones
(name varchar (20) not null unique,
phone_number integer not null unique
);

drop table calls;

create table if not exists calls
( id integer not null,
caller integer not null,
callee integer not null,
duration integer not null,
unique (id)
);

insert into phones 
values ('John',6356),('Addison',4315),('Kate',8003),('Ginny',9831);

select * from phones;

insert into calls 
values (65,8003,9831,7),(100,9831,8003,3),(145,4315,9831,18);

select * from calls;

-- Solution -- task 2 -- clients talked for atleast 10 Mins
select b.name from (
select phones.name ,sum(duration) as total_duration from 
(select caller,duration from calls
union all
select callee,duration from calls
) as a  
left join phones on a.caller=phones.phone_number
group by a.caller
having total_duration >=10
order by 1 ) as b;

-- Task 3 -- credit card transcations 

drop table transactions;

create table if not exists transactions 
( Amount integer not null,
Date date not null );

INSERT INTO transactions (Amount, Date) VALUES 
(1000,'2020-01-06'),(-10, '2020-01-14'),
(-75, '2020-01-20') , (-5, '2020-01-25'), 
(-4, '2020-01-29'),(2000, '2020-03-10'),
 (-75, '2020-03-12'), (-20, '2020-03-15') , 
 (40, '2020-03-15') , (-50, '2020-03-17'),
(200, '2020-10-10'), (-200, '2020-10-10');

select * from transactions;

-- solution -- Task 3 -- credit card transcations 

select (sum(Amount)- 5*(12- ( select count(*) as no_fee from (
select count(*) as no_txn from transactions
where Amount < 0 -- only credit card transactions
group by month (Date)
having no_txn >=3 and sum(amount) <= -100)as a)))as balance
from transactions;