﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Футболист = ДанныеЗаполнения.Футболист;
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	Футболисты.Ссылка КАК Футболист,
		                      |	Футболисты.ФутбольныйКлуб КАК КлубПродавец
		                      |ИЗ
		                      |	Справочник.Футболисты КАК Футболисты
		                      |ГДЕ
		                      |	Футболисты.Ссылка = &Футболист");
		Запрос.УстановитьПараметр("Футболист", Футболист);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		
		КлубПокупатель = Константы.ФутбольныйКлубМенеджера.Получить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	ИнициализацияПараметровЗапроса(Запрос);	  
	
	ТекстыЗапросов = Новый Структура;
	ТекстЗапросаБюджетыФутбольныхКлубов(ТекстыЗапросов);
	ТекстЗапросаТрансферы(ТекстыЗапросов);

	РезультатыЗапроса = РезультатыЗапроса(Запрос, ТекстыЗапросов);
	
	СформироватьДвиженияПоРегиструБюджетыФутбольныхКлубов(РезультатыЗапроса, Движения);
	СформироватьДвиженияПоРегиструТрансферы(РезультатыЗапроса, Движения);
	
	ПроверитьОстатокБюджета(Отказ);
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтатусПереговоров = Перечисления.СтатусПереговоров.Принято Тогда
		ПеревестиИгрокаВКлубПокупатель();
	КонецЕсли;
	
КонецПроцедуры  

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если КлубПродавец = Константы.ФутбольныйКлубМенеджера.Получить() Тогда
		ПроверяемыеРеквизиты.Добавить("СтатусПереговоров");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализацияПараметровЗапроса(Запрос)

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

КонецПроцедуры

Процедура ТекстЗапросаБюджетыФутбольныхКлубов(ТекстыЗапросов)

	ТекстЗапроса = "ВЫБРАТЬ
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	               |	Трансфер.Дата КАК Период,
	               |	Трансфер.Ссылка КАК Регистратор,
	               |	Трансфер.КлубПокупатель КАК ФутбольныйКлуб,
	               |	0 КАК ОбщийБюджет,
	               |	Трансфер.Предложение КАК ТрансферныйБюджет
	               |ИЗ
	               |	Документ.Трансфер КАК Трансфер
	               |ГДЕ
	               |	Трансфер.Ссылка = &Ссылка
	               |	И (Трансфер.СтатусПереговоров В (ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Принято))
	               |			ИЛИ Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.ОтветноеПредложение)
	               |				И Трансфер.ОжидаетсяДействиеИгры)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	               |	Трансфер.Дата,
	               |	Трансфер.Ссылка,
	               |	Трансфер.КлубПродавец,
	               |	0,
	               |	Трансфер.Предложение
	               |ИЗ
	               |	Документ.Трансфер КАК Трансфер
	               |ГДЕ
	               |	Трансфер.Ссылка = &Ссылка
	               |	И Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Принято)";
	ТекстыЗапросов.Вставить("БюджетыФутбольныхКлубов", ТекстЗапроса);

КонецПроцедуры 

Процедура ТекстЗапросаТрансферы(ТекстыЗапросов)

	ТекстЗапроса = "ВЫБРАТЬ
	               |	Трансфер.Дата КАК Период,
	               |	Трансфер.Ссылка КАК Регистратор,
	               |	Трансфер.КлубПродавец КАК КлубПродавец,
	               |	Трансфер.КлубПокупатель КАК КлубПокупатель,
	               |	Трансфер.Футболист КАК Футболист,
	               |	Трансфер.Предложение КАК СуммаТрансфера
	               |ИЗ
	               |	Документ.Трансфер КАК Трансфер
	               |ГДЕ
	               |	Трансфер.Ссылка = &Ссылка
	               |	И Трансфер.СтатусПереговоров = ЗНАЧЕНИЕ(Перечисление.СтатусПереговоров.Принято)";
	ТекстыЗапросов.Вставить("Трансферы", ТекстЗапроса);

КонецПроцедуры 

Функция	РезультатыЗапроса(Запрос, ТекстыЗапросов)

	ТекстИтоговогоЗапроса = "";
	Для Каждого КлючИЗначение Из ТекстыЗапросов Цикл
		ТекстИтоговогоЗапроса = ТекстИтоговогоЗапроса + 
				?(ЗначениеЗаполнено(ТекстИтоговогоЗапроса), "; ", "") + 
				КлючИЗначение.Значение;	
	КонецЦикла; 
	
	Запрос.Текст = ТекстИтоговогоЗапроса;
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатыЗапроса = Новый Структура;
	
	Индекс = 0;
	Для Каждого КлючИЗначение Из ТекстыЗапросов Цикл
		РезультатыЗапроса.Вставить(КлючИЗначение.Ключ, МассивРезультатов[Индекс]);		
		Индекс = Индекс + 1;		
	КонецЦикла;
	
	Возврат РезультатыЗапроса;
	
КонецФункции

Процедура СформироватьДвиженияПоРегиструБюджетыФутбольныхКлубов(РезультатыЗапроса, Движения)

	Выборка = РезультатыЗапроса.БюджетыФутбольныхКлубов.Выбрать();           
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.БюджетыФутбольныхКлубов.Добавить(), Выборка);
	КонецЦикла;                                                       
	
	Движения.БюджетыФутбольныхКлубов.Записать();

КонецПроцедуры

Процедура СформироватьДвиженияПоРегиструТрансферы(РезультатыЗапроса, Движения)

	Выборка = РезультатыЗапроса.Трансферы.Выбрать();           
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.Трансферы.Добавить(), Выборка);
	КонецЦикла;                                                       
	
	Движения.Трансферы.Записать();

КонецПроцедуры

Процедура ПеревестиИгрокаВКлубПокупатель()

	ФутболистОбъект = Футболист.ПолучитьОбъект();
	ФутболистОбъект.ФутбольныйКлуб = КлубПокупатель;
	ФутболистОбъект.Записать();   
		
	ИгровыеМеханики.ОбновитьСтартовыеСоставыКоманд(КлубПродавец);
	
КонецПроцедуры

Процедура ПроверитьОстатокБюджета(Отказ)

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	БюджетыФутбольныхКлубовОстатки.ТрансферныйБюджетОстаток КАК ТрансферныйБюджетОстаток
	                      |ИЗ
	                      |	РегистрНакопления.БюджетыФутбольныхКлубов.Остатки(, ФутбольныйКлуб = &ФутбольныйКлуб) КАК БюджетыФутбольныхКлубовОстатки
	                      |ГДЕ
	                      |	БюджетыФутбольныхКлубовОстатки.ТрансферныйБюджетОстаток < 0");
	Запрос.УстановитьПараметр("ФутбольныйКлуб", КлубПокупатель);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Сумма предложения превысила бюджет на трансферы.'"),,,, Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти	

#КонецЕсли
