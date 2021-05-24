/*Фирма имеет несколько пунктов приема вторсырья. 
Каждый пункт получает деньги для их выдачи сдатчикам вторсырья. 
Сведения о получении денег на пунктах приема записываются в таблицу:
Income_o(point, date, inc)
Первичным ключом является (point, date). 
При этом в столбец date записывается только дата (без времени), т.е. прием денег (inc) на каждом пункте производится не чаще одного раза в день. 
Сведения о выдаче денег сдатчикам вторсырья записываются в таблицу:
Outcome_o(point, date, out)
В этой таблице также первичный ключ (point, date) гарантирует отчетность каждого пункта о выданных деньгах (out) не чаще одного раза в день.
В случае, когда приход и расход денег может фиксироваться несколько раз в день, используется другая схема с таблицами, имеющими первичный ключ code:
Income(code, point, date, inc)
Outcome(code, point, date, out)
Здесь также значения столбца date не содержат времени.
*/

-- Задача № 69 3* - По таблицам Income и Outcome для каждого пункта приема найти остатки денежных средств на конец каждого дня,
--					в который выполнялись операции по приходу и/или расходу на данном пункте.
--					Учесть при этом, что деньги не изымаются, а остатки/задолженность переходят на следующий день.
--					Вывод: пункт приема, день в формате "dd/mm/yyyy", остатки/задолженность на конец этого дня.

-- Вариант 1
with io as (
	select coalesce(i.point, o.point) as point, coalesce(i.date, o.date) as date, coalesce(inc,0) as inc, coalesce(out,0) as out
	from (
			select point, date, SUM(inc) as inc 
			from income 
			group by point, date
			) as i 
		full join (
				select point, date, SUM(out) as out 
				from outcome 
				group by point, date
				) as o on i.point = o.point 
			and i.date  = o.date
			-- Объединнение таблицы расхода и дохода по точкам и датам
)

Select point, convert(char(10), date,103) as day, (
	select sum(inc)- sum(out) 
	from io 
	where io.date <= o.date 
		and point = o.point
	) as result
from io as o

-- Вариант 2
with io as (
	select coalesce(i.point, o.point) as point, coalesce(i.date, o.date) as date, coalesce(inc,0) as inc, coalesce(out,0) as out
	from (
			select point, date, SUM(inc) as inc 
			from income 
			group by point, date
			) as i 
		full join (
				select point, date, SUM(out) as out 
				from outcome 
				group by point, date
				) as o on i.point = o.point 
			and i.date  = o.date
			-- Объединнение таблицы расхода и дохода по точкам и датам
)

Select point, convert(char(10), date,103) as data,  sum(inc) over (
	partition by point 
	order by date  
	range unbounded preceding
	) - sum(out) over (
	partition by point  
	order by date  
	range unbounded preceding
	) as result
from io


	