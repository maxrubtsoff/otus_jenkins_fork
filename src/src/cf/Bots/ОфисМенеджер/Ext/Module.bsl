﻿
Процедура ОбработкаСообщенияСистемыВзаимодействия(Сообщение, ДополнительныеПараметры)
	
	ВыдатьПодсказку = Ложь;
	
	ТекстСообщения = СокрЛП(Сообщение.Текст);
	Если СтрДлина(ТекстСообщения) < 2 Тогда
		
		ВыдатьПодсказку = Истина;
		
	Иначе
		
		Строки = СтрРазделить(ТекстСообщения, " ", Ложь);
		Стр = СтрСоединить(Строки, "* ") + "*";
		
		СписокПолнотекстовогоПоиска = ПолнотекстовыйПоиск.СоздатьСписок(Стр, 10);
		СписокПолнотекстовогоПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
		СписокПолнотекстовогоПоиска.ПолучатьОписание = Ложь;
		СписокПолнотекстовогоПоиска.ПолучатьПредставление = Истина;
			
		// Ищем контрагенты и товары
		МассивОтбор = Новый Массив;
		МассивОтбор.Добавить(Метаданные.Справочники.Контрагенты);
		МассивОтбор.Добавить(Метаданные.Справочники.Товары);
		СписокПолнотекстовогоПоиска.ОбластьПоиска = МассивОтбор;
			
		СписокПолнотекстовогоПоиска.ПерваяЧасть();
		
		Товары = Новый Массив;
		Контрагенты = Новый Массив;
		
		Для А = 0 По СписокПолнотекстовогоПоиска.Количество() - 1 Цикл
			
			ЭлементСпискаПолнотекстовогоПоиска = СписокПолнотекстовогоПоиска.Получить(А);
				
			Представление = СтрНайтиИВыделитьОформлением(ЭлементСпискаПолнотекстовогоПоиска.Представление, Строки);
			Если Представление = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ТипЗнчЭлементаСпискаПолнотекстовогоПоиска = ТипЗнч(ЭлементСпискаПолнотекстовогоПоиска.Значение);
			Если ТипЗнчЭлементаСпискаПолнотекстовогоПоиска = Тип("СправочникСсылка.Товары") Тогда
				
				Товары.Добавить(Новый Структура("Значение,Представление", ЭлементСпискаПолнотекстовогоПоиска.Значение, Представление));
				Если Товары.Количество() = 3 Тогда
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ТипЗнчЭлементаСпискаПолнотекстовогоПоиска = Тип("СправочникСсылка.Контрагенты") Тогда
				
				Контрагенты.Добавить(Новый Структура("Значение,Представление", ЭлементСпискаПолнотекстовогоПоиска.Значение, Представление));
				Если Контрагенты.Количество() = 3 Тогда
					Прервать;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Товары.Количество() = 0 И Контрагенты.Количество() = 0 Тогда
			
			ВыдатьПодсказку = Истина;
			
		Иначе
			
			Строки = Новый Массив;
			
			Если Товары.Количество() > 0 Тогда
				СсылкиТоваров = ПолучитьЗначения(Товары);
				ЦеныТоваров = ПолучитьЦеныТоваров(СсылкиТоваров);
				ОстаткиТоваров = ПолучитьОстаткиТоваров(СсылкиТоваров);
			
				Для Каждого НайденныйТовар Из Товары Цикл
					
					Строки.Добавить(НайденныйТовар.Представление);
					Строки.Добавить(Символы.ПС);
					
					// Цены
					Цены = ЦеныТоваров.НайтиСтроки(Новый Структура("Товар", НайденныйТовар.Значение));
					Если Цены.Количество() > 0 Тогда
						Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Цены:'", "ru"), Новый Шрифт(,, Истина)));
						Строки.Добавить(Символы.ПС);
						
						Для Каждого Цена Из Цены Цикл
							Строки.Добавить(Цена.ВидЦенНаименование + ": " + Цена.Цена + Символы.ПС);
						КонецЦикла;
					
						Строки.Добавить(Символы.ПС);
					КонецЕсли;
					
					// Остатки
					Остатки = ОстаткиТоваров.НайтиСтроки(Новый Структура("Товар", НайденныйТовар.Значение));
					Если Остатки.Количество() > 0 Тогда
						Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Остатки:'", "ru"), Новый Шрифт(,, Истина)));
						Строки.Добавить(Символы.ПС);
						
						Для Каждого Остаток Из Остатки Цикл
							Строки.Добавить(Остаток.СкладНаименование + ": " + Остаток.Количество + Символы.ПС);
						КонецЦикла;
						
						Строки.Добавить(Символы.ПС);
					КонецЕсли;
					
					Строки.Добавить(Символы.ПС);
					
				КонецЦикла;
			КонецЕсли;
			
			Если Контрагенты.Количество() > 0 Тогда
				СсылкиКонтрагентов = ПолучитьЗначения(Контрагенты);
				ВзаиморасчетыКонтрагентов = ПолучитьВзаиморасчеты(СсылкиКонтрагентов);
				ЗаказыКонтрагентов = ПолучитьЗаказы(СсылкиКонтрагентов);
				
				Для Каждого НайденныйКонтрагент Из Контрагенты Цикл
					
					Строки.Добавить(НайденныйКонтрагент.Представление);
					Строки.Добавить(Символы.ПС);
					
					// Взаиморасчеты
					Взаиморасчеты = ВзаиморасчетыКонтрагентов.НайтиСтроки(Новый Структура("Контрагент", НайденныйКонтрагент.Значение));
					Если Взаиморасчеты.Количество() > 0 Тогда
						Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Взаиморасчеты:'", "ru"), Новый Шрифт(,, Истина)));
						Строки.Добавить(Символы.ПС);
						
						Для Каждого Расчет Из Взаиморасчеты Цикл
							Строки.Добавить(Расчет.ВалютаНаименование + ": " + Расчет.Сумма + Символы.ПС);
						КонецЦикла;
						
						Строки.Добавить(Символы.ПС);
					КонецЕсли;
					
					// Неотработанные заказы
					
					Заказы = ЗаказыКонтрагентов.НайтиСтроки(Новый Структура("Контрагент", НайденныйКонтрагент.Значение));
					Если Заказы.Количество() > 0 Тогда
						Строки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Незакрытые заказы:'", "ru"), Новый Шрифт(,, Истина)));
						Строки.Добавить(Символы.ПС);
						
						Для Каждого Заказ Из Заказы Цикл
							Строки.Добавить(Новый ФорматированнаяСтрока(Заказ.СсылкаПредставление,,,, ПолучитьНавигационнуюСсылку(Заказ.Ссылка)));
							Строки.Добавить(" (" + НСтр("ru = 'Сумма: '", "ru") + Формат(Заказ.Сумма, "ЧДЦ=2") + ")");
							Строки.Добавить(Символы.ПС);
						КонецЦикла;
						
						Строки.Добавить(Символы.ПС);
					КонецЕсли;
					
					Строки.Добавить(Символы.ПС);
					
				КонецЦикла;
			КонецЕсли;
			
			Ответ = СистемаВзаимодействия.СоздатьСообщение(Сообщение.Обсуждение);
			Ответ.Текст = Новый ФорматированнаяСтрока(Строки);
			Ответ.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВыдатьПодсказку Тогда
		
		БотСервер.ВывестиПодсказку(Сообщение.Обсуждение, СистемаВзаимодействия.ИдентификаторТекущегоПользователя());
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЗначения(ЗначенияИПредставления)
	
	Результат = Новый Массив(ЗначенияИПредставления.Количество());
	
	Для А = 0 По ЗначенияИПредставления.ВГраница() Цикл
		Результат[А] = ЗначенияИПредставления[А].Значение;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьЦеныТоваров(Товары)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЦеныТоваровСрезПоследних.Товар КАК Товар,
	|	ЦеныТоваровСрезПоследних.Товар.Наименование КАК ТоварНаименование,
	|	ЦеныТоваровСрезПоследних.ВидЦен КАК ВидЦен,
	|	ЦеныТоваровСрезПоследних.ВидЦен.Наименование КАК ВидЦенНаименование,
	|	ЦеныТоваровСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныТоваров.СрезПоследних(, Товар В (&Товары)) КАК ЦеныТоваровСрезПоследних
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварНаименование,
	|	Товар,
	|	ВидЦенНаименование,
	|	ВидЦен";
	Запрос.УстановитьПараметр("Товары", Товары);
	Цены = Запрос.Выполнить().Выгрузить();
	Цены.Индексы.Добавить("Товар");
	Возврат Цены;
	
КонецФункции

Функция ПолучитьОстаткиТоваров(Товары)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТоварныеЗапасыОстатки.Товар.Наименование КАК ТоварНаименование,
	|	ТоварныеЗапасыОстатки.Товар КАК Товар,
	|	ЕСТЬNULL(ТоварныеЗапасыОстатки.Склад.Наименование, """") КАК СкладНаименование,
	|	ТоварныеЗапасыОстатки.Склад КАК Склад,
	|	ТоварныеЗапасыОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварныеЗапасы.Остатки(, Товар В (&Товары)) КАК ТоварныеЗапасыОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТоварНаименование,
	|	Товар,
	|	СкладНаименование,
	|	Склад";
	Запрос.УстановитьПараметр("Товары", Товары);
	Остатки = Запрос.Выполнить().Выгрузить();
	Остатки.Индексы.Добавить("Товар");
	Возврат Остатки;
	
КонецФункции 

Функция ПолучитьВзаиморасчеты(Контрагенты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВзаиморасчетыОстатки.Контрагент КАК Контрагент,
	|	ВзаиморасчетыОстатки.Контрагент.Наименование КАК КонтрагентНаименование,
	|	ВзаиморасчетыОстатки.Валюта КАК Валюта,
	|	ЕСТЬNULL(ВзаиморасчетыОстатки.Валюта.Наименование, """") КАК ВалютаНаименование,
	|	ВзаиморасчетыОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.Взаиморасчеты.Остатки(, Контрагент В (&Контрагенты)) КАК ВзаиморасчетыОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентНаименование,
	|	Контрагент,
	|	ВалютаНаименование,
	|	Валюта";
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	Взаиморасчеты = Запрос.Выполнить().Выгрузить();
	Взаиморасчеты.Индексы.Добавить("Контрагент");
	Возврат Взаиморасчеты;
	
КонецФункции

Функция ПолучитьЗаказы(Контрагенты)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Заказы.Покупатель КАК Контрагент,
	|	ЕСТЬNULL(Заказы.Покупатель.Наименование, """") КАК КонтрагентНаименование,
	|	Заказы.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Заказы.Ссылка) КАК СсылкаПредставление,
	|	Заказы.Сумма КАК Сумма,
	|	Заказы.Дата КАК Дата
	|ИЗ
	|	Документ.Заказ КАК Заказы
	|ГДЕ
	|	Заказы.Ссылка В
	|			(ВЫБРАТЬ ПЕРВЫЕ 3
	|				Заказ.Ссылка КАК Ссылка
	|			ИЗ
	|				Документ.Заказ КАК Заказ
	|			ГДЕ
	|				Заказ.ПометкаУдаления = ЛОЖЬ
	|				И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказов.Закрыт)
	|				И Заказ.СостояниеЗаказа <> ЗНАЧЕНИЕ(Перечисление.СостоянияЗаказов.Выполнен)
	|				И Заказ.Покупатель = Заказы.Покупатель)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КонтрагентНаименование,
	|	Контрагент,
	|	Дата УБЫВ";
	Запрос.УстановитьПараметр("Контрагенты", Контрагенты);
	Взаиморасчеты = Запрос.Выполнить().Выгрузить();
	Взаиморасчеты.Индексы.Добавить("Контрагент");
	Возврат Взаиморасчеты;
	
КонецФункции
