﻿
#Область ПрограмныйИнтерфейс

Функция ИзображениеТактическойСхемы(Схема) Экспорт

	Если Схема = Перечисления.ИгровыеСхемы.Схема343 Тогда
		Возврат БиблиотекаКартинок.Схема343;
	ИначеЕсли Схема = Перечисления.ИгровыеСхемы.Схема352 Тогда
		Возврат БиблиотекаКартинок.Схема352;
	ИначеЕсли Схема = Перечисления.ИгровыеСхемы.Схема4231 Тогда  
		Возврат БиблиотекаКартинок.Схема4231;
	ИначеЕсли Схема = Перечисления.ИгровыеСхемы.Схема433 Тогда
		Возврат БиблиотекаКартинок.Схема433;
	ИначеЕсли Схема = Перечисления.ИгровыеСхемы.Схема442 Тогда     
		Возврат БиблиотекаКартинок.Схема442;
	ИначеЕсли Схема = Перечисления.ИгровыеСхемы.Схема442Ромб Тогда
		Возврат БиблиотекаКартинок.Схема442Ромб;
	Иначе
		Возврат Новый Картинка;
	КонецЕсли;

КонецФункции 

#КонецОбласти