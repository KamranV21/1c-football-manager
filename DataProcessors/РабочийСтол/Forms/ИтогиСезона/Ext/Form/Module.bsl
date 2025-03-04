﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Лига", Лига);
	Параметры.Свойство("Сезон", Сезон);

	ОпределитьРезультатыСезона();	
	
КонецПроцедуры

#КонецОбласти   

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьИгру(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ОпределитьРезультатыСезона()
	
	ИтоговаяТаблица = ИгровыеМеханики.ЗапросТурнирнаяТаблица(Лига, Сезон).Выполнить().Выгрузить();
	ИтоговаяТаблица.Колонки.Добавить("Позиция", Новый ОписаниеТипов("Число"));
	
	Позиция = 1;
	Для Каждого Строка Из ИтоговаяТаблица Цикл
		Строка.Позиция = Позиция;
		Позиция = Позиция + 1;		
	КонецЦикла;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ИтоговаяТаблица.ФутбольныйКлуб КАК ФутбольныйКлуб,
	                      |	ИтоговаяТаблица.Позиция КАК Позиция
	                      |ПОМЕСТИТЬ ВтИтоговаяТаблица
	                      |ИЗ
	                      |	&ИтоговаяТаблица КАК ИтоговаяТаблица
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ВтИтоговаяТаблица.ФутбольныйКлуб КАК ФутбольныйКлуб,
	                      |	ВтИтоговаяТаблица.Позиция КАК Позиция,
	                      |	ЕСТЬNULL(РасстановкаСилНаНачалоСезона.Позиция, 0) КАК ПредполагаемаяПозиция
	                      |ИЗ
	                      |	ВтИтоговаяТаблица КАК ВтИтоговаяТаблица
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РасстановкаСилНаНачалоСезона КАК РасстановкаСилНаНачалоСезона
	                      |		ПО ВтИтоговаяТаблица.ФутбольныйКлуб = РасстановкаСилНаНачалоСезона.ФутбольныйКлуб
	                      |			И (РасстановкаСилНаНачалоСезона.Лига = &Лига)
	                      |			И (РасстановкаСилНаНачалоСезона.Сезон = &Сезон)
	                      |ГДЕ
	                      |	ВтИтоговаяТаблица.ФутбольныйКлуб = &ФутбольныйКлуб");
	Запрос.УстановитьПараметр("ИтоговаяТаблица", ИтоговаяТаблица);
	Запрос.УстановитьПараметр("Лига", Лига); 
	Запрос.УстановитьПараметр("Сезон", Сезон); 
	Запрос.УстановитьПараметр("ФутбольныйКлуб", Константы.ФутбольныйКлубМенеджера.Получить()); 

	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий(); 
	
	Если Выборка.Позиция = 1 Тогда
		
		ТекстЗаголовка = НСтр("ru = 'Чемпионство!'"); 
		ТекстНадписи = НСтр("ru = 'Да! Вы сделали это! Болельщики надолго запомнят блистательную игру команды в этом сезоне под вашим грамотным руководством! Но сможете ли вы сохранить титул в следующем сезоне?'");
		Картинка = БиблиотекаКартинок.ПобедныйСезон;	
		
	Иначе
		
		Если Выборка.Позиция = 2 Тогда
			ТекстЗаголовка = НСтр("ru = 'Серебро чемпионата!'"); 
		ИначеЕсли Выборка.Позиция = 3 Тогда
			ТекстЗаголовка = НСтр("ru = 'Почетная бронза!'");  
		Иначе
			ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Ваша команда заняла %1 место'"), Выборка.Позиция);
		КонецЕсли; 
		
		ВсегоКоманд = Выборка.Количество();
		ТопДесятьПроцентовХудшихКоманд = 100 - Выборка.Позиция * 100 / 16 < 10;
		
		Если Выборка.Позиция > Выборка.ПредполагаемаяПозиция + 2 Тогда
			ТекстНадписи = НСтр("ru = 'Вы превзошли ожидания руководства и болельщиков! В начале сезона никто не предполагал, что мы сможем зайти дак далеко! Получится ли у нас развить успех в следующем сезоне?'");
			Картинка = БиблиотекаКартинок.УдачныйСезон;
		ИначеЕсли Выборка.Позиция - 4 > Выборка.ПредполагаемаяПозиция Или ТопДесятьПроцентовХудшихКоманд Тогда
			ТекстНадписи = НСтр("ru = 'Давненько у нас не было таких неудачных сезонов. В начале сезона казалось, что у нас есть все возможности побороться за более высокие места. Кто знает, возможно в следующем сезоне вы сможете навести в команде порядок?'");
			Картинка = БиблиотекаКартинок.НеудачныйСезон;
		Иначе
			ТекстНадписи = НСтр("ru = 'Задачу на сезон можно считать выполненной. Конечно, фанаты всегда хотят большего, но, объективно, вы справились хорошо, учитывая имеющиеся в вашем расположении ресурсы. Но не пора ли нам выйти на новый уровень в следующем сезоне?'");
			Картинка = БиблиотекаКартинок.НормальныйСезон;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.ДекорацияЗаголовок.Заголовок = ТекстЗаголовка;
	Элементы.ДекорацияТекст.Заголовок = ТекстНадписи;
	Элементы.Картинка.Картинка = Картинка;
		
КонецПроцедуры

#КонецОбласти