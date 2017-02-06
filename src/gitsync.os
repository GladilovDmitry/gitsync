﻿///////////////////////////////////////////////////////////////////
//
// Выполняет синхронизацию хранилища 1С с Git 
//
///////////////////////////////////////////////////////////////////

#Использовать cmdline
#Использовать logos
#Использовать tempfiles

#Использовать "core"

///////////////////////////////////////////////////////////////////

Перем Лог;	 					// Лог
Перем ДополнительныеПараметры;	// Структура с набором дополнительных параметров

///////////////////////////////////////////////////////////////////

Процедура ВывестиВерсию()
	
	Сообщить("GitSync ver 1.2.2");
	
КонецПроцедуры // ВывестиВерсию()

Функция РазобратьАргументыКоманднойСтроки()
    
	Парсер = ПолучитьПарсерКоманднойСтроки();
    Возврат Парсер.Разобрать(АргументыКоманднойСтроки);

КонецФункции // РазобратьАргументыКоманднойСтроки

Функция ПолучитьПарсерКоманднойСтроки()
    
    Парсер = Новый ПарсерАргументовКоманднойСтроки();    
    МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);
    
    Возврат Парсер;
    
КонецФункции // ПолучитьПарсерКоманднойСтроки

Функция ВыполнениеКоманды()
	
	ВывестиВерсию();
	ПараметрыЗапуска = РазобратьАргументыКоманднойСтроки();
	
	Если ПараметрыЗапуска = Неопределено ИЛИ ПараметрыЗапуска.Количество() = 0 Тогда
		
		Лог.Ошибка("Некорректные аргументы командной строки");
        МенеджерКомандПриложения.ПоказатьСправкуПоКомандам();
        Возврат 1;

	КонецЕсли;

	УстановитьРежимОтладкиПриНеобходимости(ПараметрыЗапуска.ЗначенияПараметров);
	УстановитьРежимУдаленияВременныхФайлов(ПараметрыЗапуска.ЗначенияПараметров);
	УстановитьБазовыйКаталогВременныхФайлов(ПараметрыЗапуска.ЗначенияПараметров);

	КодВозврата = МенеджерКомандПриложения.ВыполнитьКоманду(ПараметрыЗапуска.Команда, ПараметрыЗапуска.ЗначенияПараметров, ДополнительныеПараметры);
	УдалитьВременныеФайлыПриНеобходимости();
	
	Возврат КодВозврата;

КонецФункции // ВыполнениеКоманды()

Процедура УдалитьВременныеФайлыПриНеобходимости()

	Если ДополнительныеПараметры.УдалятьВременныеФайлы Тогда

		ВременныеФайлы.Удалить();

	КонецЕсли;

КонецПроцедуры // УдалитьВременныеФайлыПриНеобходимости

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач ПараметрыЗапуска)

	Если ПараметрыЗапуска["-verbose"] = "on" ИЛИ ПараметрыЗапуска["-debug"] = "on" Тогда

		Лог.УстановитьУровень(УровниЛога.Отладка);

	КонецЕсли;

КонецПроцедуры // УстановитьРежимОтладкиПриНеобходимости

Процедура УстановитьРежимУдаленияВременныхФайлов(Знач ПараметрыЗапуска)

	Если ПараметрыЗапуска["-debug"] = "on" Тогда

		ДополнительныеПараметры.УдалятьВременныеФайлы = Истина;

	КонецЕсли;

КонецПроцедуры // УстановитьРежимУдаленияВременныхФайлов

Процедура УстановитьБазовыйКаталогВременныхФайлов(Знач ПараметрыЗапуска)

	Если ЗначениеЗаполнено(ПараметрыЗапуска["-tempdir"]) Тогда

		БазовыйКаталог  = ПараметрыЗапуска["-tempdir"];
		Если Не (Новый Файл(БазовыйКаталог).Существует()) Тогда

			СоздатьКаталог(БазовыйКаталог);

		КонецЕсли;

		ВременныеФайлы.БазовыйКаталог = БазовыйКаталог;

	КонецЕсли;

КонецПроцедуры // УстановитьБазовыйКаталогВременныхФайлов

Процедура ТочкаВхода()
	
	ДополнительныеПараметры = Новый Структура;
	
	Лог = Логирование.ПолучитьЛог("oscript.app.gitsync");
	ДополнительныеПараметры.Вставить("УдалятьВременныеФайлы", Ложь);
	ДополнительныеПараметры.Вставить("Лог", Лог);
	
	Попытка
		
		ЗавершитьРаботу(ВыполнениеКоманды());

	Исключение
		
		Лог.КритичнаяОшибка(ОписаниеОшибки());
		ЗавершитьРаботу(МенеджерКомандПриложения.РезультатыКоманд().ОшибкаВремениВыполнения);

	КонецПопытки;
	
КонецПроцедуры // ТочкаВхода

///////////////////////////////////////////////////////////////////

ТочкаВхода();
