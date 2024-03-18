-- insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
-- insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');

create or replace function get_rate_to_usd(
	pmoney numeric,
	pcurerncy_id integer, 
	pdate timestamp)
returns numeric as $$
declare 
	nearest_rate_to_usd numeric;
begin
	select into nearest_rate_to_usd rate_to_usd from currency
	where id = pcurerncy_id
	and updated <= pdate
	order by pdate - updated, rate_to_usd desc
	limit 1;
	
	if (nearest_rate_to_usd is null) then
		select into nearest_rate_to_usd rate_to_usd from currency
		where id = pcurerncy_id
		and updated > pdate
		order by updated - pdate, rate_to_usd desc
		limit 1;
	end if;
	
	return nearest_rate_to_usd * pmoney;
end;
$$ language plpgsql;

select distinct
coalesce(usr.name, 'not defined') as name,
coalesce(usr.lastname, 'not defined') as lastname,
currency.name as currency_name,
get_rate_to_usd(balance.money, balance.currency_id, balance.updated) as currency_in_usd
from "user" as usr
full join balance on usr.id = balance.user_id
right join currency on balance.currency_id = currency.id
order by name desc, lastname asc, currency_name asc;
