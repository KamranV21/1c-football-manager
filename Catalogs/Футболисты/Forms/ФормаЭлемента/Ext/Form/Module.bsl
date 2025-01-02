﻿	   
#Область ОбработчикиСобытийФормы
	   
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВывестиФотографию();
	
	УстановитьУсловноеОформление();
	
	ЗаполнитьПаутинуНавыков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Трансфер(Команда)

	Если Объект.ЗавершилКарьеру Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Футболист уже завершил карьеру.'"));
		Возврат;
	КонецЕсли;
	
	Если Объект.ФутбольныйКлуб = ФутбольнаяКомандаМенеджера() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Это футболист уже в вашей команде.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Основание", Новый Структура("Футболист", Объект.Ссылка));
	
	ОткрытьФорму("Документ.Трансфер.Форма.ФормаДокумента", ПараметрыОткрытия);
	
КонецПроцедуры   

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ВсеНавыки = ИгровыеМеханики.ВсеНавыкиФутболистов();
		
	Для Каждого Навык Из ВсеНавыки Цикл
		
		// < 70
		Элемент = УсловноеОформление.Элементы.Добавить();
				
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект." + Навык);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
		ОтборЭлемента.ПравоеЗначение = 70;
		
		ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Навык);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
		
		// >= 70
		Элемент = УсловноеОформление.Элементы.Добавить();
				
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект." + Навык);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ОтборЭлемента.ПравоеЗначение = 70;
		
		ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Навык);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);
		
		// >= 80
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект." + Навык);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ОтборЭлемента.ПравоеЗначение = 80;
		
		ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Навык);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЖелтоЗеленый);
		
		// >= 90
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект." + Навык);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
		ОтборЭлемента.ПравоеЗначение = 90;
		
		ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
		ОформляемоеПоле.Использование = Истина;
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Навык);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
		
	КонецЦикла;
	
	// Вратарь
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ИгровыеПозиции.Вратарь;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Позиция");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноОранжевый);
	
	// Защитник      
	СписокПозиций = Новый СписокЗначений;
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЛевыйЗащитник); 
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ПравыйЗащитник);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЦентральныйЗащитник);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Позиция");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.СинийСоСтальнымОттенком);
	
	// Полузащитник      
	СписокПозиций = Новый СписокЗначений;
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ОпорныйПолузащитник); 
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.АтакующийПолузащитник);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЛевыйПолузащитник);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ПравыйПолузащитник);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЦентральныйПолузащитник);

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Позиция");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);

	// Нападающий      
	СписокПозиций = Новый СписокЗначений;
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЦентральныйНападающий); 
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЛевыйИнсайд);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ПравыйИнсайд);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Позиция");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Лосось);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПаутинуНавыков()

	СхемаКомпоновкиДанных = Отчеты.ПаутинаНавыков.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;    
	
	НовыйОтбор = Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Футболист");
	НовыйОтбор.ПравоеЗначение = Объект.Ссылка;
	НовыйОтбор.Использование = Истина;
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	ПаутинаНавыков.Очистить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ПаутинаНавыков);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

КонецПроцедуры

&НаСервере
Процедура ВывестиФотографию()

	АдресФотографии = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Фотография"); 

КонецПроцедуры

&НаСервереБезКонтекста
Функция ФутбольнаяКомандаМенеджера()

	Возврат Константы.ФутбольныйКлубМенеджера.Получить();

КонецФункции

#КонецОбласти

