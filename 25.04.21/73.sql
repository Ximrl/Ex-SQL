/*
Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:
Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)
Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля, построенного по данному проекту, либо названию класса дается имя проекта, которое не совпадает ни с одним из кораблей в БД. 
Корабль, давший название классу, называется головным.
Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, в которой построен корабль, число главных орудий, калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах). 
В отношении Ships записаны название корабля, имя его класса и год спуска на воду. 
В отношение Battles включены название и дата битвы, в которой участвовали корабли, 
В отношении Outcomes – результат участия данного корабля в битве (потоплен-sunk, поврежден - damaged или невредим - OK).
Замечания. 	1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 
			2) Потопленный корабль в последующих битвах участия не принимает.
*/

-- Задача № 73 2* - Для каждой страны определить сражения, в которых не участвовали корабли данной страны.
--					Вывод: страна, сражение

-- Общетабличные выражение (CTE)
with combo as (
	select distinct country, name as battle
	from battles 
		cross join classes
		-- Определение всех возможных комбинаций
)
, all_battles as (
	select country, battle
	from classes 
		join ships on classes.class = ships.class 
		join outcomes on ships.name = outcomes.ship 
	union 
	select country, battle
	from classes 
		join outcomes on classes.class = outcomes.ship
)

-- Вариант 1
select country, battle
from combo
where not exists (
		select country, battle 
		from all_battles 
		where combo.country = all_battles.country 
			and combo.battle = all_battles.battle
		)

-- Вариант 2
select country, battle
from combo
except
select country, battle
from all_battles

-- Вариант 3
select combo.country, combo.battle
from combo 
	left join all_battles on combo.country = all_battles.country 
		and combo.battle = all_battles.battle
where all_battles.battle is null
