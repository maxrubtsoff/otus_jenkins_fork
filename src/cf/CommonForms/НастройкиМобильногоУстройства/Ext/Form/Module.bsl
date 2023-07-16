﻿// Процедура записывает настройки в БД. При необходимости, обновляет повторно используемые значения
//
&НаСервере
Процедура ЗаписатьКонстанты()
    
    Набор = РеквизитФормыВЗначение("НаборКонстант");
    Набор.Записать();
    ЗначениеВРеквизитФормы(Набор, "НаборКонстант");
    Модифицированность = Ложь;

КонецПроцедуры

// Процедура перестраивает форму по выбранному типу провайдера
//
&НаКлиенте
Процедура УстановитьИмяПровайдера()
	
	СпособВыбора = НаборКонстант.ВыборПровайдераГеопозиционирования;
	Если СпособВыбора = ПредопределенноеЗначение("Перечисление.ИспользоватьПровайдерГеопозиционирования.ВыбиратьИзСписка") Тогда
		Элементы.НаборКонстантИмяПровайдера.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.НаборКонстантИмяПровайдера.ТолькоПросмотр = Истина;
#Если МобильныйКлиент Тогда 
		Провайдер = Неопределено;
		Если СпособВыбора = ПредопределенноеЗначение("Перечисление.ИспользоватьПровайдерГеопозиционирования.СамыйЭкономичныйПровайдер") Тогда
			Провайдер = СредстваГеопозиционирования.ПолучитьСамогоЭнергоЭкономичногоПровайдера();
		ИначеЕсли СпособВыбора = ПредопределенноеЗначение("Перечисление.ИспользоватьПровайдерГеопозиционирования.СамыйТочныйПровайдер") Тогда
			Провайдер = СредстваГеопозиционирования.ПолучитьСамогоТочногоПровайдера();
		КонецЕсли;
		Если Провайдер = Неопределено Тогда
			НаборКонстант.ИмяПровайдера = "";
		Иначе
			НаборКонстант.ИмяПровайдера = Провайдер.Имя;
		КонецЕсли;
		ЗаписатьКонстанты();
#КонецЕсли
	КонецЕсли;

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
// 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Набор = Константы.СоздатьНабор();
    Набор.Прочитать();
    ЗначениеВРеквизитФормы(Набор, "НаборКонстант");
	
	Элементы.НаборКонстантИмяПровайдера.ТолькоПросмотр = НаборКонстант.ВыборПровайдераГеопозиционирования <> Перечисления.ИспользоватьПровайдерГеопозиционирования.ВыбиратьИзСписка;
	
	ПереключитьСтраницу = Ложь;
	Если Параметры.Свойство("Геопозиционирование",ПереключитьСтраницу) И ПереключитьСтраницу Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Геопозиционирование;
	КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьИмяПровайдера();
	
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантТолькоБесплатныеПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСотовуюСетьПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСетьПередачиДанныхПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИспользоватьСпутникиПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантВыборПровайдераГеопозиционированияПриИзменении(Элемент)
	
	ЗаписатьКонстанты();
	УстановитьИмяПровайдера();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИмяПровайдераПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантИмяПровайдераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
#Если МобильныйКлиент Тогда 
	ДанныеВыбора = Новый СписокЗначений();
	Массив = СредстваГеопозиционирования.ПолучитьПровайдеров();
	Для каждого Провайдер из Массив цикл
		Если НаборКонстант.ТолькоБесплатные и Провайдер.Платный Тогда
			Продолжить;
		КонецЕсли;
		Если не НаборКонстант.ИспользоватьСотовуюСеть и Провайдер.ИспользуетСотовуюСеть Тогда
			Продолжить;
		КонецЕсли;
		Если не НаборКонстант.ИспользоватьСетьПередачиДанных и Провайдер.ИспользуетСетьПередачиДанных Тогда
			Продолжить;
		КонецЕсли;
		Если не НаборКонстант.ИспользоватьСпутники и Провайдер.ИспользуетСпутники Тогда
			Продолжить;
		КонецЕсли;
		ДанныеВыбора.Добавить(Провайдер.Имя);
	КонецЦикла;
#КонецЕсли
	
КонецПроцедуры


&НаКлиенте
Процедура НаборКонстантВоспроизводитьТекстУведомленияПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантОтметкаНаФотоснимкеДатаПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

&НаКлиенте
Процедура НаборКонстантОтметкаНаФотоснимкеТекстПриИзменении(Элемент)
    
    ЗаписатьКонстанты();
    
КонецПроцедуры

