﻿  
#Область ПрограммныйИнтерфейс

Функция СгенерироватьОтветНаТрансферноеПредложение(Футболист, Предложение) Экспорт

	// На решение влияют три фактора в порядке значимости:
	// 1. Если в результате трансфера в команде будет меньше 15 полевых футболистов или не будет вратаря тогда трансфер невозможен.
	// 2. Игроки с высоким рейтингом продаются дороже рынка. Они важны для команды.
	// 3. Молодые футболисты всегда продаются с наценкой. 
	// 4. Возврастные футболисты могут быть проданы дешевле рынка.
	// 5. Бедные клубы скорее согласяться продать футболиста.
	
	Если Не ТрансферТехническиВозможен(Футболист) Тогда
		Возврат Новый Структура("СтатусПереговоров, ОтветноеПредложение, ТекстОтвета", 
			Перечисления.СтатусПереговоров.Отклонено, 0, НСтр("ru = 'Мы не можем остаться без футболистов. Трансфер невозможен.'"));
	КонецЕсли;
	
	НаценкаНаФутболистаВПроцентах = 0;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Футболисты.Ссылка КАК Футболист,
	                      |	Футболисты.Рейтинг КАК Рейтинг,
	                      |	Футболисты.Возраст КАК Возраст,
	                      |	ЕСТЬNULL(ТрансфернаяСтоимостьСрезПоследних.ТрансфернаяСтоимость, 0) КАК ТрансфернаяСтоимость,
	                      |	ЕСТЬNULL(БюджетыФутбольныхКлубовОстатки.ОбщийБюджетОстаток, 0) КАК БюджетКоманды
	                      |ИЗ
	                      |	Справочник.Футболисты КАК Футболисты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТрансфернаяСтоимость.СрезПоследних(, Футболист = &Футболист) КАК ТрансфернаяСтоимостьСрезПоследних
	                      |		ПО (ТрансфернаяСтоимостьСрезПоследних.Футболист = Футболисты.Ссылка)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетыФутбольныхКлубов.Остатки КАК БюджетыФутбольныхКлубовОстатки
	                      |		ПО Футболисты.ФутбольныйКлуб = БюджетыФутбольныхКлубовОстатки.ФутбольныйКлуб
	                      |ГДЕ
	                      |	Футболисты.Ссылка = &Футболист");
	Запрос.УстановитьПараметр("Футболист", Футболист);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	РейтингФутболиста = Выборка.Рейтинг;
   	Возраст = Выборка.Возраст;
   	БюджетКлуба = Выборка.БюджетКоманды;
   	ТрансфернаяСтоимость = Выборка.ТрансфернаяСтоимость;

	// 1. Рейтинг футболиста (маскимум 50% наценки).
	Если РейтингФутболиста >= 95 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 50;     
	ИначеЕсли РейтингФутболиста >= 90 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 40;
	ИначеЕсли РейтингФутболиста >= 85 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 35;   
	ИначеЕсли РейтингФутболиста >= 80 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 30; 
	ИначеЕсли РейтингФутболиста >= 75 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 15;
	ИначеЕсли РейтингФутболиста >= 70 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + 10;
	КонецЕсли;
	
	// 2. Молодой футболист (по 10% наценки за год "молодости").
	ВозрастЗрелостиФутболиста = 24;
	ПерспективныеГоды = ВозрастЗрелостиФутболиста - Возраст;
	Если ПерспективныеГоды > 0 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + ПерспективныеГоды * 10;
	КонецЕсли;

	// 3. Пожилой футболист (по 5% скидки за год "старости").
	ВозрастСтаростиФутболиста = 29;
	Если Возраст > ВозрастСтаростиФутболиста Тогда 
		ПерспективныеГоды = Возраст - ВозрастСтаростиФутболиста;
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах - ПерспективныеГоды * 10;
	КонецЕсли;
	
	// 4. Бюджет клуба-владельца (скидка от 50% до наценки в 10%).
	ПроцентОтБюджета = ?(БюджетКлуба > 0, Предложение * 100 / БюджетКлуба, 100);
	
	Если ПроцентОтБюджета > 50 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах - 30;
	ИначеЕсли ПроцентОтБюджета > 25 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах - 15;   
	ИначеЕсли ПроцентОтБюджета > 10 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах - 5;   
	КонецЕсли;
	
	// Расчет вероятности.
	ОтветноеПредложение = ТрансфернаяСтоимость + ТрансфернаяСтоимость / 100 * НаценкаНаФутболистаВПроцентах;  
	
	ВероятностьПринятия = ?(ОтветноеПредложение = 0, 100, Предложение * 100 / ОтветноеПредложение);
		
	Если ВероятностьПринятия >= 95 Тогда
		СтатусПереговоров = Перечисления.СтатусПереговоров.Принято;
	ИначеЕсли ВероятностьПринятия >= 85 Тогда
		СлучайноеЧисло = ИгровыеМеханики.СлучайноеЧисло(0, 100);
		Если СлучайноеЧисло > ВероятностьПринятия Тогда
			СтатусПереговоров = Перечисления.СтатусПереговоров.Принято;
		Иначе
			СтатусПереговоров = Перечисления.СтатусПереговоров.ОтветноеПредложение;
		КонецЕсли;
	ИначеЕсли ВероятностьПринятия < 10 Тогда
		СтатусПереговоров = Перечисления.СтатусПереговоров.Отклонено;     
	Иначе
		СтатусПереговоров = Перечисления.СтатусПереговоров.ОтветноеПредложение;
	КонецЕсли;  
	
	ТекстОтвета = ТекстОтветаПереговоров(СтатусПереговоров, ОтветноеПредложение);
	
	Возврат Новый Структура("СтатусПереговоров, ОтветноеПредложение, ТекстОтвета", СтатусПереговоров, ОтветноеПредложение, ТекстОтвета);
	
КонецФункции 

Функция РассчитатьТрансфернуюСтоимостьФутболиста(ДанныеФутболиста) Экспорт

	// 1. Игроки с высоким рейтингом получают больщую трансферную стоимость. С определенного момента цена единицы рейтинга начинает возрастать.
	// 2. Молодые футболисты оцениваются дороже. 
	// 3. Возврастные футболисты оцениваются дешевле.
	
	ТрансфернаяСтоимость = 0;
	НаценкаНаФутболистаВПроцентах = 0;
		
	РейтингФутболиста = ДанныеФутболиста.Рейтинг;
   	Возраст = ДанныеФутболиста.Возраст;

	// 1. Рейтинг футболиста.                   
	РейтингУсредненнойОценки = 75;
	СредняяСтоимостьУсредненнойЕдиницыРейтинга = 80000;
	
	ТрансфернаяСтоимость = Мин(РейтингФутболиста, РейтингУсредненнойОценки) * СредняяСтоимостьУсредненнойЕдиницыРейтинга;
	
	РейтингиУвеличеннойСтоимости = РейтингФутболиста - РейтингУсредненнойОценки;
	ШагУдорожания = 100000; 
	СтоимостьУвеличеннойЕдиницы = СредняяСтоимостьУсредненнойЕдиницыРейтинга;
	Для Счетчик = 1 По РейтингиУвеличеннойСтоимости Цикл
		СтоимостьУвеличеннойЕдиницы = СтоимостьУвеличеннойЕдиницы + ШагУдорожания;	
		ТрансфернаяСтоимость = ТрансфернаяСтоимость + СтоимостьУвеличеннойЕдиницы;
	КонецЦикла;             
	
	Если РейтингФутболиста >= 95 Тогда
		ТрансфернаяСтоимость = ТрансфернаяСтоимость + 35000000;
	ИначеЕсли РейтингФутболиста >= 90 Тогда
		ТрансфернаяСтоимость = ТрансфернаяСтоимость + 15000000;
	ИначеЕсли РейтингФутболиста >= 85 Тогда
		ТрансфернаяСтоимость = ТрансфернаяСтоимость + 10000000;
	ИначеЕсли РейтингФутболиста >= 80 Тогда
		ТрансфернаяСтоимость = ТрансфернаяСтоимость + 5000000;
	КонецЕсли;
		
	// 2. Молодой футболист.
	ВозрастЗрелостиФутболиста = 24;
	ПерспективныеГоды = ВозрастЗрелостиФутболиста - Возраст;
	Если ПерспективныеГоды > 0 Тогда
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах + ПерспективныеГоды * 10;
	КонецЕсли;
	
	// 3. Пожилой футболист (по 5% скидки за год "старости").
	ВозрастСтаростиФутболиста = 29;
	Если Возраст > ВозрастСтаростиФутболиста Тогда 
		ПерспективныеГоды = Возраст - ВозрастСтаростиФутболиста;
		НаценкаНаФутболистаВПроцентах = НаценкаНаФутболистаВПроцентах - ПерспективныеГоды * 10;
	КонецЕсли; 
	
	ТрансфернаяСтоимость = ТрансфернаяСтоимость + ТрансфернаяСтоимость / 100 * НаценкаНаФутболистаВПроцентах;
	
	Возврат ТрансфернаяСтоимость;
	
КонецФункции

Функция СимулироватьТрансфернуюАктивность() Экспорт
	
	ОткрытьЗакрытьТрансферныеОкнаВЛигах();
	
	СимулироватьОтветыОтNPC();		
	СимулироватьПредложенияОтNPC();
	
КонецФункции

Функция ТрансферТехническиВозможен(Футболист) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СУММА(ВЫБОР
	                      |			КОГДА Футболисты.Позиция = ЗНАЧЕНИЕ(Перечисление.ИгровыеПозиции.Вратарь)
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК КоличествоВратарей,
	                      |	СУММА(ВЫБОР
	                      |			КОГДА Футболисты.Позиция <> ЗНАЧЕНИЕ(Перечисление.ИгровыеПозиции.Вратарь)
	                      |				ТОГДА 1
	                      |			ИНАЧЕ 0
	                      |		КОНЕЦ) КАК КоличествоПолевыхИгроков
	                      |ИЗ
	                      |	Справочник.Футболисты КАК Футболисты
	                      |ГДЕ
	                      |	Футболисты.ФутбольныйКлуб = &ФутбольныйКлуб
	                      |	И Футболисты.Ссылка <> &Футболист");
	Запрос.УстановитьПараметр("Футболист", Футболист);
	Запрос.УстановитьПараметр("ФутбольныйКлуб", Футболист.ФутбольныйКлуб);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.КоличествоВратарей >= 1 И Выборка.КоличествоПолевыхИгроков >= 15; 

КонецФункции 

Функция ТекстОтветаПереговоров(СтатусПереговоров, ОтветноеПредложение) Экспорт
	
	ТекстОтвета = "";
	
	ВариантОтвета = ИгровыеМеханики.СлучайноеЧисло(1, 2);
	
	Если СтатусПереговоров = Перечисления.СтатусПереговоров.ОтветноеПредложение Тогда
		Если ВариантОтвета = 1 Тогда
			ТекстОтвета = СтрШаблон(НСтр("ru = '""Интересное предложение, но мы оцениваем качества данного футболиста выше. Мы ожидаем от вас предложения в районе %1.""'"), ОтветноеПредложение);
		ИначеЕсли ВариантОтвета = 2 Тогда
			ТекстОтвета = СтрШаблон(НСтр("ru = 'Этот футболист очень важен для нас. Мы не рассматриваем предложения ниже, чем %1.'"), ОтветноеПредложение);
		КонецЕсли;	
	ИначеЕсли СтатусПереговоров = Перечисления.СтатусПереговоров.Принято Тогда
		Если ВариантОтвета = 1 Тогда
			ТекстОтвета = НСтр("ru = 'По рукам. С вами прятно вести переговоры. Футболист переходит в вашу команду.'");
		ИначеЕсли ВариантОтвета = 2 Тогда
			ТекстОтвета = НСтр("ru = 'Это были непростые переговоры, но мы рады, что в конце концов нам удалось прийти к соглашению. Футболист переходит в вашу команду.'");
		КонецЕсли;	
	ИначеЕсли СтатусПереговоров = Перечисления.СтатусПереговоров.Отклонено Тогда
		Если ВариантОтвета = 1 Тогда
			ТекстОтвета = НСтр("ru = 'Это шутка? Мы не видим смысла дальше продолжать эти переговоры.'");
		ИначеЕсли ВариантОтвета = 2 Тогда
			ТекстОтвета = НСтр("ru = 'Это предложение не соответствует рыночной стоимости. К сожалению, переговоры с вами придется завершить.'");
		КонецЕсли;	
	КонецЕсли;
	
	Возврат ТекстОтвета;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СимулироватьПредложенияОтNPC()
	
	ИгроваяДата = Константы.ИгроваяДата.Получить();
	ФутбольныйКлубМенеджера = Константы.ФутбольныйКлубМенеджера.Получить();
	ТекущийСезон = Константы.ТекущийСезон.Получить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Футболисты.ФутбольныйКлуб КАК ФутбольныйКлуб,
	                      |	Футболисты.Ссылка КАК Футболист,
	                      |	ЕСТЬNULL(ТрансфернаяСтоимостьСрезПоследних.ТрансфернаяСтоимость, 0) КАК ТрансфернаяСтоимость,
	                      |	Футболисты.Позиция КАК Позиция
	                      |ПОМЕСТИТЬ ВтФутболистыКТрансферу
	                      |ИЗ
	                      |	Справочник.Футболисты КАК Футболисты
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТрансфернаяСтоимость.СрезПоследних КАК ТрансфернаяСтоимостьСрезПоследних
	                      |		ПО (ТрансфернаяСтоимостьСрезПоследних.Футболист = Футболисты.Ссылка)
	                      |ГДЕ
	                      |	НЕ Футболисты.Ссылка В
	                      |				(ВЫБРАТЬ
	                      |					ТрансферыОбороты.Футболист КАК Футболист
	                      |				ИЗ
	                      |					РегистрНакопления.Трансферы.Обороты(ДОБАВИТЬКДАТЕ(&ТекущаяИгроваяДата, МЕСЯЦ, -12), &ТекущаяИгроваяДата, , ) КАК ТрансферыОбороты)
	                      |	И НЕ Футболисты.ЗавершилКарьеру
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	тСтартовыйСостав.Ссылка КАК КлубПокупатель,
	                      |	тСтартовыйСостав.Позиция КАК Позиция,
	                      |	тСтартовыйСостав.Футболист.Рейтинг КАК Рейтинг,
	                      |	ЕСТЬNULL(БюджетыФутбольныхКлубовОстатки.ТрансферныйБюджетОстаток, 0) КАК ТрансферныйБюджет,
	                      |	ВтФутболистыКТрансферу.ФутбольныйКлуб КАК КлубПродавец,
	                      |	ВтФутболистыКТрансферу.Футболист КАК Футболист,
	                      |	ВЫБОР
	                      |		КОГДА ЕСТЬNULL(Трансфер.ОтветноеПредложение, ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ОтветноеПредложение)
	                      |			ТОГДА ЕСТЬNULL(Трансфер.ОтветноеПредложение, 0)
	                      |		ИНАЧЕ ЕСТЬNULL(ВтФутболистыКТрансферу.ТрансфернаяСтоимость, 0)
	                      |	КОНЕЦ КАК ТрансфернаяСтоимость,
	                      |	Трансфер.Ссылка КАК Трансфер
	                      |ИЗ
	                      |	Справочник.ФутбольныеКлубы.СтартовыйСостав КАК тСтартовыйСостав
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.БюджетыФутбольныхКлубов.Остатки КАК БюджетыФутбольныхКлубовОстатки
	                      |		ПО тСтартовыйСостав.Ссылка = БюджетыФутбольныхКлубовОстатки.ФутбольныйКлуб
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВтФутболистыКТрансферу КАК ВтФутболистыКТрансферу
	                      |		ПО тСтартовыйСостав.Ссылка <> ВтФутболистыКТрансферу.ФутбольныйКлуб
	                      |			И тСтартовыйСостав.Позиция = ВтФутболистыКТрансферу.Позиция
	                      |			И (ЕСТЬNULL(БюджетыФутбольныхКлубовОстатки.ТрансферныйБюджетОстаток, 0) >= ВтФутболистыКТрансферу.ТрансфернаяСтоимость)
	                      |			И тСтартовыйСостав.Футболист.Рейтинг < ВтФутболистыКТрансферу.Футболист.Рейтинг
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Трансфер КАК Трансфер
	                      |		ПО тСтартовыйСостав.Ссылка = Трансфер.КлубПокупатель
	                      |			И (ВтФутболистыКТрансферу.ФутбольныйКлуб = Трансфер.КлубПродавец)
	                      |			И (ВтФутболистыКТрансферу.Футболист = Трансфер.Футболист)
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставЛиги.СрезПоследних(, Сезон = &Сезон) КАК СоставЛигиСрезПоследних
	                      |		ПО тСтартовыйСостав.Ссылка = СоставЛигиСрезПоследних.ФутбольныйКлуб
	                      |ГДЕ
	                      |	тСтартовыйСостав.Ссылка <> &ФутбольныйКлубМенеджера
	                      |	И ЕСТЬNULL(Трансфер.СтатусПереговоров, ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка)) В (ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ОтветноеПредложение))
	                      |	И НЕ тСтартовыйСостав.Ссылка В
	                      |				(ВЫБРАТЬ
	                      |					Т.КлубПокупатель КАК КлубПокупатель
	                      |				ИЗ
	                      |					РегистрНакопления.Трансферы.Обороты(ДОБАВИТЬКДАТЕ(&ТекущаяИгроваяДата, МЕСЯЦ, -12), &ТекущаяИгроваяДата, , ) КАК Т
	                      |				СГРУППИРОВАТЬ ПО
	                      |					Т.КлубПокупатель
	                      |				ИМЕЮЩИЕ
	                      |					КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Т.Футболист) >= 5)
	                      |	И ЕСТЬNULL(БюджетыФутбольныхКлубовОстатки.ТрансферныйБюджетОстаток, 0) >= ВЫБОР
	                      |			КОГДА ЕСТЬNULL(Трансфер.ОтветноеПредложение, ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка)) = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ОтветноеПредложение)
	                      |				ТОГДА ЕСТЬNULL(Трансфер.ОтветноеПредложение, 0)
	                      |			ИНАЧЕ ЕСТЬNULL(ВтФутболистыКТрансферу.ТрансфернаяСтоимость, 0)
	                      |		КОНЕЦ
	                      |	И ВЫБОР
	                      |			КОГДА НЕ Трансфер.Ссылка ЕСТЬ NULL
	                      |					И Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Отклонено)
	                      |				ТОГДА РАЗНОСТЬДАТ(Трансфер.Дата, &ТекущаяИгроваяДата, ДЕНЬ) > 60
	                      |			КОГДА НЕ Трансфер.Ссылка ЕСТЬ NULL
	                      |				ТОГДА НЕ Трансфер.ОжидаетсяДействиеИгры
	                      |			ИНАЧЕ ИСТИНА
	                      |		КОНЕЦ
	                      |	И СоставЛигиСрезПоследних.Лига.ТрансферноеОкноОткрыто
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	КлубПокупатель,
	                      |	Рейтинг,
	                      |	ВтФутболистыКТрансферу.Футболист.Рейтинг УБЫВ
	                      |ИТОГИ
	                      |	МАКСИМУМ(ТрансферныйБюджет)
	                      |ПО
	                      |	КлубПокупатель,
	                      |	Позиция");
	Запрос.УстановитьПараметр("ТекущаяИгроваяДата", ИгроваяДата);
	Запрос.УстановитьПараметр("ФутбольныйКлубМенеджера", ФутбольныйКлубМенеджера);
	Запрос.УстановитьПараметр("Сезон", ТекущийСезон);
	
	ВыборкаКлубПокупатель = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКлубПокупатель.Следующий() Цикл
		
		// Распределяем вероятность отправки предложения, чтобы не было так, что все клубы отправляют
		// свои предложения в один и тот же день.
		СлучайноеЧисло = ИгровыеМеханики.СлучайноеЧисло(0, 1);
		Если СлучайноеЧисло = 1 Тогда
			Продолжить;
		КонецЕсли;
		
		КлубПокупатель = ВыборкаКлубПокупатель.КлубПокупатель;
		ТрансферныйБюджет = ВыборкаКлубПокупатель.ТрансферныйБюджет; 
		
		ВыборкаПозиции = ВыборкаКлубПокупатель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПозиции.Следующий() Цикл
			
			Если ТрансферныйБюджет = 0 Тогда
				Прервать;
			КонецЕсли;
			
			Выборка = ВыборкаПозиции.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				Если Не ЗначениеЗаполнено(Выборка.Футболист) Тогда
					Прервать;
				КонецЕсли;
				
				Если ТрансферныйБюджет < Выборка.ТрансфернаяСтоимость Тогда
					Продолжить;
				КонецЕсли;
				
				Трансфер = ?(ЗначениеЗаполнено(Выборка.Трансфер), Выборка.Трансфер.ПолучитьОбъект(), Документы.Трансфер.СоздатьДокумент());   
				Трансфер.Дата = ИгроваяДата;  
				Трансфер.КлубПокупатель = КлубПокупатель; 
				Трансфер.КлубПродавец = Выборка.КлубПродавец;
				Трансфер.Футболист = Выборка.Футболист; 
				ПроцентОтклонения = ИгровыеМеханики.СлучайноеЧисло(0, 10) - 5;
				Трансфер.Предложение = Мин(ТрансферныйБюджет, Окр(Выборка.ТрансфернаяСтоимость + Выборка.ТрансфернаяСтоимость / 100 * ПроцентОтклонения, 2));  
				Трансфер.ОжидаетсяДействиеИгры = Истина;
				Трансфер.ОтветноеПредложение = 0;
				
				СтрокаИстории = Трансфер.ИсторияПереговоров.Добавить();
				СтрокаИстории.ТекстПредложения = Трансфер.Предложение;  
				
				Трансфер.Записать(РежимЗаписиДокумента.Проведение);  
								
				Если Трансфер.КлубПродавец = ФутбольныйКлубМенеджера Тогда
					ТекстУведомления = СтрШаблон(НСтр("ru = 'Получено предложение по %1 от %2'"), Выборка.Футболист, КлубПокупатель);
					Уведомления.СоздатьУведомление(ТекстУведомления, Трансфер.Ссылка);
				КонецЕсли;
				
				ТрансферныйБюджет = 0; // По одному предложению за раз.
				Прервать;
				
			КонецЦикла;
			
		КонецЦикла;

	КонецЦикла; 
	
	ОтменитьНеудавшиесяТрансферы();
	
КонецПроцедуры

Процедура СимулироватьОтветыОтNPC()
	
	ФутбольныйКлубМенеджера = Константы.ФутбольныйКлубМенеджера.Получить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	СправочникФутбольныеКлубы.Ссылка КАК ФутбольныйКлуб,
	                      |	ОКР(СУММА(тСтартовыйСостав.Футболист.Рейтинг) / 11, 0) КАК Рейтинг
	                      |ПОМЕСТИТЬ ВтРейтингиКлубов
	                      |ИЗ
	                      |	Справочник.ФутбольныеКлубы КАК СправочникФутбольныеКлубы
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФутбольныеКлубы.СтартовыйСостав КАК тСтартовыйСостав
	                      |		ПО (тСтартовыйСостав.Ссылка = СправочникФутбольныеКлубы.Ссылка)
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	СправочникФутбольныеКлубы.Ссылка
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Трансфер.Ссылка КАК Трансфер,
	                      |	Трансфер.Футболист КАК Футболист,
	                      |	Трансфер.Предложение КАК Предложение,
	                      |	Трансфер.КлубПродавец КАК КлубПродавец,
	                      |	Трансфер.СтатусПереговоров КАК СтатусПереговоров,
	                      |	Трансфер.Дата КАК Дата,
	                      |	РАЗНОСТЬДАТ(Трансфер.Дата, &ТекущаяДата, ДЕНЬ) КАК ПрошлоДней,
	                      |	Трансфер.КлубПродавец <> Трансфер.Футболист.ФутбольныйКлуб КАК КлубУжеПродалИгрока
	                      |ИЗ
	                      |	Документ.Трансфер КАК Трансфер
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ВтРейтингиКлубов КАК ВтРейтингиКлубов
	                      |		ПО Трансфер.КлубПокупатель = ВтРейтингиКлубов.ФутбольныйКлуб
	                      |ГДЕ
	                      |	Трансфер.ОжидаетсяДействиеИгры
	                      |	И Трансфер.Проведен
	                      |	И РАЗНОСТЬДАТ(Трансфер.Дата, &ТекущаяДата, ДЕНЬ) > 2
	                      |	И Трансфер.КлубПродавец <> &ФутбольныйКлубМенеджера
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Футболист,
	                      |	Предложение УБЫВ,
	                      |	ВтРейтингиКлубов.Рейтинг УБЫВ
	                      |ИТОГИ
	                      |	МАКСИМУМ(ПрошлоДней)
	                      |ПО
	                      |	Футболист");
	Запрос.УстановитьПараметр("ТекущаяДата", Константы.ИгроваяДата.Получить());
	Запрос.УстановитьПараметр("ФутбольныйКлубМенеджера", ФутбольныйКлубМенеджера);
	ВыборкаФутболист = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаФутболист.Следующий() Цикл
		
		Если ВыборкаФутболист.ПрошлоДней < 3 Тогда
			ВероятностьОтвета = ИгровыеМеханики.СлучайноеЧисло(0, 1);	
			Если ВероятностьОтвета = 0 Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Выборка = ВыборкаФутболист.Выбрать();
				
		ФутболистУжеПродан = Ложь;
		
		Пока Выборка.Следующий() Цикл
						
			Если ФутболистУжеПродан Или Выборка.КлубУжеПродалИгрока Тогда
				
				ТрансферОбъект = Выборка.Трансфер.ПолучитьОбъект();				
				ТрансферОбъект.СтатусПереговоров = Перечисления.СтатусПереговоров.Отклонено;
				ТрансферОбъект.ОтветноеПредложение = 0;
				ТрансферОбъект.ОжидаетсяДействиеИгры = Ложь;
				
				СтрокаИстории = ТрансферОбъект.ИсторияПереговоров[ТрансферОбъект.ИсторияПереговоров.Количество() - 1];
				СтрокаИстории.ТекстОтвета = НСтр("ru = 'Мы уже договорились с другой командой о трансфере этого игрока.'");  
				
				ТрансферОбъект.Записать(РежимЗаписиДокумента.Проведение);   
								
			Иначе
								
				ТрансферОбъект = Выборка.Трансфер.ПолучитьОбъект();
				
				Результат = СгенерироватьОтветНаТрансферноеПредложение(Выборка.Футболист, Выборка.Предложение);
				
				ТрансферОбъект.СтатусПереговоров = Результат.СтатусПереговоров;
				ТрансферОбъект.ОтветноеПредложение = Результат.ОтветноеПредложение;
				ТрансферОбъект.ОжидаетсяДействиеИгры = Ложь;
				
				СтрокаИстории = ТрансферОбъект.ИсторияПереговоров[ТрансферОбъект.ИсторияПереговоров.Количество() - 1];
				СтрокаИстории.ТекстОтвета = Результат.ТекстОтвета;  
				
				ТрансферОбъект.Записать(РежимЗаписиДокумента.Проведение);   
				
				Если ТрансферОбъект.СтатусПереговоров = Перечисления.СтатусПереговоров.Принято Тогда
					ФутболистУжеПродан = Истина;     
					Если ТрансферОбъект.КлубПокупатель <> ФутбольныйКлубМенеджера Тогда
						ИгровыеМеханики.ОбновитьСтартовыеСоставыКоманд(ТрансферОбъект.КлубПокупатель);
					КонецЕсли;
				КонецЕсли;
			
			КонецЕсли;
			
			Если ТрансферОбъект.КлубПокупатель = ФутбольныйКлубМенеджера Тогда
				
				ТекстУведомления = СтрШаблон(НСтр("ru = 'Ответ от %1 по игроку %2: %3'"), 
				ТрансферОбъект.КлубПродавец, ТрансферОбъект.Футболист, ТрансферОбъект.СтатусПереговоров);   
				
				Уведомления.СоздатьУведомление(ТекстУведомления, ТрансферОбъект.Ссылка);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтменитьНеудавшиесяТрансферы()

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Трансфер.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Документ.Трансфер КАК Трансфер
	                      |ГДЕ
	                      |	(Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ОтветноеПредложение)
	                      |			ИЛИ Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка))
	                      |	И РАЗНОСТЬДАТ(Трансфер.Дата, &ТекущаяДата, ДЕНЬ) > 10");
	Запрос.УстановитьПараметр("ТекущаяДата", Константы.ИгроваяДата.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТрансферОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТрансферОбъект.СтатусПереговоров = Перечисления.СтатусПереговоров.Отклонено;
		ТрансферОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ОткрытьЗакрытьТрансферныеОкнаВЛигах()
	
	ИгроваяДата = Константы.ИгроваяДата.Получить();
	ЛигаМенеджера = Константы.ЛигаМенеджера.Получить();
	ТекущийСезон = Константы.ТекущийСезон.Получить();

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЛигиТрансферныеОкна.Ссылка КАК Лига,
	                      |	МАКСИМУМ(ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, -&ГодСезона) МЕЖДУ ЛигиТрансферныеОкна.ДатаНачала И ЛигиТрансферныеОкна.ДатаОкончания) КАК ТрансферноеОкноОткрыто
	                      |ПОМЕСТИТЬ ВтЛигиСоСменойОкна
	                      |ИЗ
	                      |	Справочник.Лиги.ТрансферныеОкна КАК ЛигиТрансферныеОкна
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ЛигиТрансферныеОкна.Ссылка
	                      |
	                      |ИМЕЮЩИЕ
	                      |	ЛигиТрансферныеОкна.Ссылка.ТрансферноеОкноОткрыто <> МАКСИМУМ(ДОБАВИТЬКДАТЕ(&ТекущаяДата, ГОД, -&ГодСезона) МЕЖДУ ЛигиТрансферныеОкна.ДатаНачала И ЛигиТрансферныеОкна.ДатаОкончания)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВтЛигиСоСменойОкна.Лига КАК Лига,
	                      |	ВтЛигиСоСменойОкна.ТрансферноеОкноОткрыто КАК ТрансферноеОкноОткрыто
	                      |ИЗ
	                      |	ВтЛигиСоСменойОкна КАК ВтЛигиСоСменойОкна
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	Трансфер.Ссылка КАК Ссылка
	                      |ИЗ
	                      |	Документ.Трансфер КАК Трансфер
	                      |ГДЕ
	                      |	НЕ Трансфер.СтатусПереговоров В (ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Принято), ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Отклонено))
	                      |	И Трансфер.КлубПокупатель В
	                      |			(ВЫБРАТЬ
	                      |				СоставЛигиСрезПоследних.ФутбольныйКлуб КАК ФутбольныйКлуб
	                      |			ИЗ
	                      |				РегистрСведений.СоставЛиги.СрезПоследних(, Сезон = &Сезон) КАК СоставЛигиСрезПоследних
	                      |			ГДЕ
	                      |				СоставЛигиСрезПоследних.Лига В
	                      |					(ВЫБРАТЬ
	                      |						Т.Лига КАК Лига
	                      |					ИЗ
	                      |						ВтЛигиСоСменойОкна КАК Т
	                      |					ГДЕ
	                      |						НЕ Т.ТрансферноеОкноОткрыто))");	
	Запрос.УстановитьПараметр("ТекущаяДата", ИгроваяДата);
	Запрос.УстановитьПараметр("ГодСезона", Год(ТекущийСезон.ДатаНачала) - 1);
	Запрос.УстановитьПараметр("Сезон", ТекущийСезон);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
		
	// Поменять статус окна в лигах.
	Выборка = МассивРезультатов[МассивРезультатов.Количество() - 2].Выбрать();
	Пока Выборка.Следующий() Цикл     
		ЛигаОбъект = Выборка.Лига.ПолучитьОбъект();
		ЛигаОбъект.ТрансферноеОкноОткрыто = Выборка.ТрансферноеОкноОткрыто;
		ЛигаОбъект.Записать();        
		Если Выборка.Лига = ЛигаМенеджера Тогда 
			Если Выборка.ТрансферноеОкноОткрыто Тогда
				ТекстУведомления = НСтр("ru = 'В лиге %1 открылось трансферное окно.'");
			Иначе
				ТекстУведомления = НСтр("ru = 'В лиге %1 закрылось трансферное окно.'");
			КонецЕсли;
			Уведомления.СоздатьУведомление(СтрШаблон(ТекстУведомления, ЛигаМенеджера), ЛигаМенеджера);
		КонецЕсли;
	КонецЦикла;
	
	// Отменить сорвавшиеся трансферы.
	Выборка = МассивРезультатов[МассивРезультатов.Количество() - 1].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Трансфер = Выборка.Ссылка.ПолучитьОбъект();	
		Трансфер.СтатусПереговоров = Перечисления.СтатусПереговоров.Отклонено; 
		Трансфер.ИсторияПереговоров[Трансфер.ИсторияПереговоров.Количество() - 1].ТекстОтвета = НСтр("ru = 'Трансферное окно закрыто. Сделка сорвана.'");
		Трансфер.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
  
