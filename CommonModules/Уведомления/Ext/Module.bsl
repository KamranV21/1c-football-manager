﻿
#Область ПрограммныйИнтерфейс 

Процедура СоздатьУведомление(Текст, Предмет) Экспорт

	Уведомление = РегистрыСведений.Уведомления.СоздатьМенеджерЗаписи();	
	Уведомление.Идентификатор = Новый УникальныйИдентификатор();   
	Уведомление.Текст = Текст;
	Уведомление.Предмет = Предмет;    
	Уведомление.Дата = Константы.ИгроваяДата.Получить();
	Уведомление.Записать();

КонецПроцедуры

Процедура УдалитьУведомление(Идентификатор) Экспорт

	НаборЗаписей = РегистрыСведений.Уведомления.СоздатьНаборЗаписей();	   
	НаборЗаписей.Отбор.Идентификатор.Установить(Идентификатор); 
	НаборЗаписей.Записать();

КонецПроцедуры

Процедура УдалитьВсеУведомления() Экспорт

	НаборЗаписей = РегистрыСведений.Уведомления.СоздатьНаборЗаписей();	   
	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти