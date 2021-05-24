/*
Схема БД состоит из четырех отношений:
Company (ID_comp, name)
Trip(trip_no, ID_comp, plane, town_from, town_to, time_out, time_in)
Passenger(ID_psg, name)
Pass_in_trip(trip_no, date, ID_psg, place)
Таблица Company содержит идентификатор и название компании, осуществляющей перевозку пассажиров. 
Таблица Trip содержит информацию о рейсах: номер рейса, идентификатор компании, тип самолета, город отправления, город прибытия, время отправления и время прибытия. 
Таблица Passenger содержит идентификатор и имя пассажира. 
Таблица Pass_in_trip содержит информацию о полетах: номер рейса, дата вылета (день), идентификатор пассажира и место, на котором он сидел во время полета. 
При этом следует иметь в виду, что
- рейсы выполняются ежедневно, а длительность полета любого рейса менее суток; town_from <> town_to;
- время и дата учитывается относительно одного часового пояса;
- время отправления и прибытия указывается с точностью до минуты;
- среди пассажиров могут быть однофамильцы (одинаковые значения поля name, например, Bruce Willis);
- номер места в салоне – это число с буквой; число определяет номер ряда, буква (a – d) – место в ряду слева направо в алфавитном порядке;
- связи и ограничения показаны на схеме данных.
*/

-- Задача № 66 2* - Для всех дней в интервале с 01/04/2003 по 07/04/2003 определить число рейсов из Rostov.
--					Вывод: дата, количество рейсов 

-- Вариант 1 (Не самый хороший)
select dates.date, count(r_dates.date)
from(
		select date
		from Pass_in_trip
		where trip_no in (
				select trip_no 
				from trip 
				where town_from = 'Rostov'
				)
			and (
				date between '2003-04-01' and '2003-04-07'
				)
		group by date, trip_no
		) as r_dates 
		right join (
				select datetimefromparts(2003, 4, 1, 00, 00, 00, 000) as date
				union all
				select datetimefromparts(2003, 4, 2, 00, 00, 00, 000)
				union all
				select datetimefromparts(2003, 4, 3, 00, 00, 00, 000)
				union all
				select datetimefromparts(2003, 4, 4, 00, 00, 00, 000)
				union all
				select datetimefromparts(2003, 4, 5, 00, 00, 00, 000)
				union all
				select datetimefromparts(2003, 4, 6, 00, 00, 00, 000)
				union all
				select datetimefromparts(2003, 4, 7, 00, 00, 00, 000)
				) as dates on r_dates.date = dates.date
		-- Соездинение таблицы с датами рейсов из Ростова с необходимым диапазоном дат
group by dates.date

-- Вариант 2 (Использую рекурсивные cte)
with dates as (
	select cast ('2003-04-01' as datetime) as date
	union all
	select dateadd(dd, 1, date) 
	from dates
	where date < '2003-04-07'
)

select dates.date, count(r_dates.date)
from dates 
	left join (
				select date
				from Pass_in_trip
				where trip_no in (
						select trip_no 
						from trip 
						where town_from = 'Rostov'
						)
					and (
						date between '2003-04-01' and '2003-04-07'
						)
				group by date, trip_no
			)as r_dates on dates.date = r_dates.date
	-- Соездинение таблицы с датами рейсов из Ростова с необходимым диапазоном дат
group by dates.date

-- Вариант 3 (Использую генерацию числовой последовательности)
with nums as (
	select 3*(a-1)+b as num 
	from (
			select 1 as a 
			union all 
			select 2
			union all 
			select 3
			) as num1 
		cross join (
				select 1 as b 
				union all 
				select 2
				union all 
				select 3
				) as  num2
)
, dates as (
	select datetimefromparts(2003, 4, num, 00, 00, 00, 000) as date 
	from nums
	where datetimefromparts(2003, 4, num, 00, 00, 00, 000) <= '2003-04-07'
)

select dates.date, count(r_dates.date)
from dates 
	left join (
			select date
			from Pass_in_trip
			where trip_no in (
					select trip_no 
					from trip 
					where town_from = 'Rostov'
					)
				and (
					date between '2003-04-01' and '2003-04-07'
					)
			group by date, trip_no
			)as r_dates on dates.date = r_dates.date
	-- Соездинение таблицы с датами рейсов из Ростова с необходимым диапазоном дат
group by dates.date
