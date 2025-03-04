﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	УстановитьПараметрыДинамическогоСпискаВсеФутболисты();
	УстановитьПараметрыДинамическогоСпискаМатчиКоманды();
	
	ЭтоКлубМенеджера =  Объект.Ссылка = Константы.ФутбольныйКлубМенеджера.Получить();
	ТолькоПросмотр = Не ЭтоКлубМенеджера; 
	Элементы.ПодобратьСоставАвтоматически.Видимость = ЭтоКлубМенеджера;
	
	УстановитьИзображениеСхемы();
	УстановитьПодсказкуПотактике();
	
	ЗаполнитьРейтингСтартовогоСостава();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура СхемаПриИзменении(Элемент)
	
	ОбновитьСтартовыйСостав();
	
	УстановитьИзображениеСхемы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТактикаПриИзменении(Элемент)
	
	УстановитьПодсказкуПотактике();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиСтартовыйСостав

&НаКлиенте
Процедура СтартовыйСоставФутболистПриИзменении(Элемент)
	
	ФутболистПриИзмененииНаСервере(Элементы.СтартовыйСостав.ТекущиеДанные.ПолучитьИдентификатор());	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьСоставАвтоматически(Команда)  
	
	ПодобратьСоставАвтоматическиНаСервере();  
	
	Прочитать();
	
	ЗаполнитьРейтингСтартовогоСостава();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаВсеФутболисты()
	
	ЗначениеПараметраКомпоновкиДанных = ВсеФутболисты.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ФутбольныйКлуб"));
	ЗначениеПараметраКомпоновкиДанных.Значение = Объект.Ссылка;
    ЗначениеПараметраКомпоновкиДанных.Использование = Истина;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаМатчиКоманды()
	
	ЗначениеПараметраКомпоновкиДанных = МатчиКоманды.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ФутбольныйКлуб"));
	ЗначениеПараметраКомпоновкиДанных.Значение = Объект.Ссылка;
    ЗначениеПараметраКомпоновкиДанных.Использование = Истина;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтартовыйСостав()
	
	Объект.СтартовыйСостав.Очистить();
	
	ПозицииПоСхеме = ИгровыеМеханики.ПозицииПоСхеме(Объект.Схема);
	
	Для Индекс = 0 По 10 Цикл	
		СтрокаСостава = Объект.СтартовыйСостав.Добавить();		
		СтрокаСостава.Позиция = ПозицииПоСхеме[Индекс];
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьИзображениеСхемы()
	
	Элементы.ИзображениеСхемы.Картинка = Интерфейс.ИзображениеТактическойСхемы(Объект.Схема);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Условное оформление динамического списка
	СписокУсловноеОформление = ВсеФутболисты.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();

	// < 70
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Рейтинг < 70'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 70;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Рейтинг");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
	
	// >= 70
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Рейтинг >= 70'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 70;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Рейтинг");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);
	
	// >= 80
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Рейтинг >= 80'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 80;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Рейтинг");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЖелтоЗеленый);
	
	// >= 90
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Рейтинг >= 90'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 90;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Рейтинг");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Вратарь
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Вратарь'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Позиция");
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

	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Защитник'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Позиция");
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

	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Полузащитник'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Позиция");
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
	
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Нападающий'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Позиция");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Лосось);
	
	// СТАРТОВЫЙ СОСТАВ 
	
	// < 70
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 70;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставРейтинг.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
	
	// >= 70
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 70;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставРейтинг.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Синий);
	
	// >= 80
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 80;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставРейтинг.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЖелтоЗеленый);
	
	// >= 90
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Рейтинг");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборЭлемента.ПравоеЗначение = 90;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставРейтинг.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Вратарь
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ИгровыеПозиции.Вратарь;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставПозиция.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноОранжевый);
	
	// Защитник      
	СписокПозиций = Новый СписокЗначений;
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЛевыйЗащитник); 
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ПравыйЗащитник);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЦентральныйЗащитник);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставПозиция.Имя);
	
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
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставПозиция.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);

	// Нападающий      
	СписокПозиций = Новый СписокЗначений;
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЦентральныйНападающий); 
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ЛевыйИнсайд);
	СписокПозиций.Добавить(Перечисления.ИгровыеПозиции.ПравыйИнсайд);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СтартовыйСостав.Позиция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокПозиций;
	
	ОформляемоеПоле = Элемент.Поля.Элементы.Добавить();
	ОформляемоеПоле.Использование = Истина;
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтартовыйСоставПозиция.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", ШрифтыСтиля.ЖирныйШрифт);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Лосось);
	
КонецПроцедуры

&НаСервере
Процедура ФутболистПриИзмененииНаСервере(Идентификатор)

	ТекущиеДанные = Объект.СтартовыйСостав.НайтиПоИдентификатору(Идентификатор);
	ТекущиеДанные.Рейтинг = ТекущиеДанные.Футболист.Рейтинг;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРейтингСтартовогоСостава()

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	тСтартовыйСостав.Футболист.Рейтинг КАК Рейтинг
	                      |ИЗ
	                      |	Справочник.ФутбольныеКлубы.СтартовыйСостав КАК тСтартовыйСостав
	                      |ГДЕ
	                      |	тСтартовыйСостав.Ссылка = &Ссылка
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	тСтартовыйСостав.НомерСтроки");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка); 
	
	Выборка = Запрос.Выполнить().Выбрать(); 
	Индекс = 0;
	Пока Выборка.Следующий() Цикл
		Объект.СтартовыйСостав[Индекс].Рейтинг = Выборка.Рейтинг;
		Индекс = Индекс + 1;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуПотактике()
	
	ТекстПодсказки = "";
	
	Если Объект.Тактика = Перечисления.ИгровыеТактики.ВсеВАтаке Тогда
		ТекстПодсказки = НСтр("ru = 'Команда всеми силами идет вперед, стараясь создать как можно больше опсаных моментов. Повышается вероятность забить гол, однако также резко возрастает вероятность нарваться на контратаку.'");
	ИначеЕсли Объект.Тактика = Перечисления.ИгровыеТактики.Атака Тогда
		ТекстПодсказки = НСтр("ru = 'Команда пытается играть в созидательный, атакующий футбол. Линия защиты поднимается чуть выше, чтобы помочь в розыгрыше атак.'");
	ИначеЕсли Объект.Тактика = Перечисления.ИгровыеТактики.Сбалансированный Тогда
		ТекстПодсказки = НСтр("ru = 'Комнда играет сбалансировано, каждая линия команды четко отвечает за свои обязанности и не выходит за их рамки.'");
	ИначеЕсли Объект.Тактика = Перечисления.ИгровыеТактики.Защита Тогда
		ТекстПодсказки = НСтр("ru = 'Команда понимает, что контроль мяча это не ее конек, и потому отдает мяч противнику в надежде поймать его на контратаке.'");
	ИначеЕсли Объект.Тактика = Перечисления.ИгровыеТактики.ВсеВЗащите Тогда
		ТекстПодсказки = НСтр("ru = 'Команда всеми силами пытается оставить свои ворота на замке. Если повезет, то можно убежать в контратаку, но все же защита в приоритете.'");
	КонецЕсли;
	
	Элементы.ПодсказкаПоТактике.Заголовок = ТекстПодсказки;

КонецПроцедуры

&НаСервере
Процедура ПодобратьСоставАвтоматическиНаСервере()
	
	Значение = РеквизитФормыВЗначение("Объект");
	Значение.Записать(); 
	ЗначениеВРеквизитФормы(Значение, "Объект");
	
	ИгровыеМеханики.ОбновитьСтартовыеСоставыКоманд(Объект.Ссылка);	
	
КонецПроцедуры

#КонецОбласти


