/*
Фирма имеет несколько пунктов приема вторсырья. 
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

-- Задача № 64 2* - Используя таблицы Income и Outcome, для каждого пункта приема определить дни, когда был приход, но не было расхода и наоборот.
--					Вывод: пункт, дата, тип операции (inc/out), денежная сумма за день. 

Select COALESCE(i.point, o.point) as point, COALESCE(i.date, o.date) as date, 
case when MAX(inc) IS NULL then 'out' else 'inc' end operation, COALESCE(SUM(inc), SUM(out)) as money
from Income as i 
	full join outcome as o on i.date = o.date and i.point = o.point
	-- Полное соединение двух таблиц для выбора дней без одновременного прихода и расхода
where i.point is null or o.point is null
group by COALESCE(i.point, o.point), COALESCE(i.date, o.date)
