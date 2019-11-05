
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fco. Javier Tello
-- Create date: 2019.11.05
-- =============================================

CREATE PROCEDURE proc_get_datetable
	@startingDate as date, 
	@finishingDate as date, 

	@increment as int = NULL, 
	@interval as varchar(10) = NULL
AS
BEGIN
	
	SET NOCOUNT ON;

	if(isnull(@increment, 0)<1)
		set @increment = 1

	set @interval = lower(rtrim(ltrim(isnull(@interval, ''))));

	set @interval = (
		case 
			when @interval in ('day', 'dia', 'día', 'd') then 'd'
			when @interval in ('month', 'mes', 'm') then 'm'
			when @interval in ('week', 'w', 'semana', 's') then 'w'
			when @interval in ('year', 'y', 'año', 'a', 'ano', 'anyo', 'ano', 'anio') then 'y'
			else 'd'
		end);

	declare @t as table (id int identity(1,1), [date] date);

	declare @loopDate as date;
	set @loopDate = @startingDate;

	if(@interval in ('d', 'm', 'w', 'y'))
		while @loopDate <= @finishingDate
		begin
			insert into @t values (@loopDate);
			if(@interval = 'd')
				set @loopDate = dateadd(day, @increment, @loopDate);
			if(@interval = 'm')
				set @loopDate = dateadd(month, @increment, @loopDate);
			if(@interval = 'w')
				set @loopDate = dateadd(week, @increment, @loopDate);
			if(@interval = 'y')
				set @loopDate = dateadd(year, @increment, @loopDate);

		end

	select [date] from @t order by [date]

END
GO
