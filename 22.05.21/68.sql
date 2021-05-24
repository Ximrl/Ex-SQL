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

-- Задача № 68 2* - Найти количество маршрутов, которые обслуживаются наибольшим числом рейсов.
--					Замечания.
--					1) A - B и B - A считать ОДНИМ И ТЕМ ЖЕ маршрутом маршрутами.
--					2) Использовать только таблицу Trip

-- Вариант 1
with uniq_trips as (
	select town_from, town_to, count(*) as c_trip
	from trip
	group by town_from, town_to
)
, concat_trips as (
	select b1.town_from, b1.town_to, (b1.c_trip + coalesce(b2.c_trip, 0)) as g_trips
	from uniq_trips t1 
		left join uniq_trips t2 on t1.town_from = t2.town_to 
		-- Объединяем две таблицы сами на себя, учитывая одиночные рейсы и условия прямых-обратных рейсов
			and t1.town_to = t2.town_from 
			and t1.town_from > t2.town_from
)

select count(*)
from concat_trips
where g_trips = (select max(g_trips) from concat_trips)

-- Вариант 2 (Считаю более оптимальным)
with counter as (
	select count(*) as c
	from trip
	group by case when town_from > town_to then town_from else town_to end,
case when town_from > town_to then town_to else town_from end)

select count(*) 
from counter
where c = (select max(c) from counter)