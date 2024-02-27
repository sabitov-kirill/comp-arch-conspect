#heading[Оперативная память.]
#emph[Оперативная память (процесс чтения и записи, тайминги для чтения, развитие оперативной памяти).]

#import "/commons.typ": imagebox
== Чтение и запись в оперативную память
=== Внутреннее устройство

Для начала вспомним, как выглядит оперативная память.

#columns(2)[
  #imagebox("DRAM.png", height: 120pt, label: [
    DRAM (Dynamic Random Access Memory)
  ])
  Динамическая память имеет:
  - 1 n-mos транзистор
  - 1 конденсатор
  #colbreak()
  
  #imagebox("SRAM.png", height: 120pt, label: [
    SRAM (Static Random Access Memory)
  ])

  Статичнская память имеет:
  - 2 n-mos транзистора
  - 2 инвертора (ещё 2 n-mos и 2 p-mos)
]

=== Чтение
#columns(2)[
  *Процесс чтения из _DRAM_*:
  + Подаём на COL 0.5 от нормального напряжения;
  + Подаём 1 на ROW (открываем n-mos транзистор);
  + Производим замер:
    - если напряжение стало $0.5 - epsilon$, значит хранился 0;
    - если напряжение стало $0.5 + epsilon$, значит хранился 1.
  #colbreak()

  *Процесс чтения из _SRAM_*:
  + Подаём на COL и #overline[COL] нормальное напряжение;
  + Подаём 1 на ROW (открываем n-mos транзисторы);
  + Смотрим напряжение на COL и #overline[COL]:
    - если $V_"COL" < V_accent("COL", macron)$ , значит в ячейке был записан 0;
    - если $V_"COL" > V_accent("COL", macron)$ , значит в ячейке был записан 1.
]

=== Запись
Что если мы хотим записать значение $x in {0, 1}$ в ячейку?
#columns(2)[
 *Процесс записи в _DRAM_*:
  + Подаём на COL x;
  + Подаём 1 на ROW (открываем n-mos транзистор);
  + Ждём тайминг зарядки конденсатора.
  #colbreak()
  
  *Процесс записи в _SRAM_*:
  + Подаём на COL $x$, а на #overline[COL] $not x$;
  + Подаём 1 на ROW (открываем n-mos транзисторы);
  
  Тем самым мы фактически либо заземляем значение на $Q$ и подаём напряжение на $accent(Q, macron)$, если хотим записать 0, либо подаём напряжение на $Q$ и заземляем на $accent(Q, ‾)$, если хотим записать 1.
]
#pagebreak()

== Тайминги для чтения
#emph[Тайминг оперативной памяти] --- временна́я задержка сигнала при работе динамической оперативной памяти. Измеряются в тактах тактового генератора. От них в значительной степени зависит пропускная способность участка «процессор-память» и задержки чтения данных из памяти и, как следствие, быстродействие системы.

#imagebox("DRAM_timings.png", height: 160pt)
- tRAS (Row Active Strobe)
  Минимальное время между открытием и закрытием строки.
- tRCD (RAS to CAS Delay)
  Число тактов между открытием строки и доступом к столбцам в ней. 
- tCL (CAS Latency)
  Время, требуемое на чтение бита из памяти, когда нужная строка уже открыта.
- tRP (Row Precharge)
  Время перезарядки конденсаторов после того, как мы использовали строку.

=== Latency и Throughput
#emph[Latency] (скорость доступа) --- время от подачи запроса до начала получения данных. (tRCD + tCL).

#emph[Throughput] (пропускная способность) --- время между получением двух порций данных. (tRAS + tRP).

== Историческая справка
"Так исторически сложилось, что до какого-то момента скорость доступа получалось увеличивать довольно неплохо, но в какой-то момент улучшение скорости доступа почти полностью остановилось и после этого весь прогресс стремится к скорости передачи данных для какого-то конкретного устройства. Есть не очень много способов, чтобы увеличивать скорость доступа, но есть огромное количество ухищрений и техник, чтобы увеличивать скорость передачи данных."

#align(right)[Роман Мельников ©]

== Про модификации модулей памяти

=== Многопортовая ячейка памяти
Отличием _многопортовой ячейки памяти_ от _однопортовой_ является то, что у каждой ячейки есть 2 набора проводов. Это позволяет одновременно производить операции с двумя ячейками памяти (правда с оговоркой: они должны быть не из одной строки).

#columns(2)[
  #imagebox("two-port_DRAM.png", label: [Двухпортовая DRAM], height: 117pt)
  #colbreak()
  #imagebox("two-port_SRAM.png", label: [Двухпортовая SRAM], height: 117pt)
]
=== Многобанковая ячейка памяти

В _многобанковых ячейках памяти_, RAM разделена на отдельные независимые банки. При обращении в разные банки, тк они являются независимыми и при считывании ячейки (открыть строчку, задать столбец, закрыть строку, перезарядить конденсатор) на другие банки не оказывается никакое влияние, мы можем производить чтение не дожидаясь перезарядки конденсаторов. Таким образом, такой подход выходит выгоднее, когда у нас последовательные запросы обращаются в разные участки памяти(банки).

=== Синхронная и асинхронная память
#emph[Ассинхронная память] --- когда контроллер и модуль памяти взаимодействуют не согласованно(может быть, даже работают с разной частотой).  

#emph[Синхронная память] --- контроллер и модуль памяти синхронизированы, частота одинаковая.

Раньше память была асинхронна, но сейчас (со второй половины 90-х) инженеры научились нормально собирать всё и согласовывать ячейки с контроллером.

== Исторически сложившиеся стандарты оперативной памяти
\
+ *FPM DRAM* (начало 90-х)
 - Не закрываем строку и не перезаряжаем конденсаторы, если запросы идут последовательно в одну и ту же строку, но в разные столбцы. Например, выполняется последовательный кусок кода, или происходит итерация по массиву;
 - Ассинхронна.
+ *EDO DRAM* (первая половина 90-х)
 - Заведём дополнительный буфер, в котором мы храним адрес cтолбца, к которому мы сейчас обращаемся. Таким образом мы можем передавать адрес столбца для следующего запроса параллельно с тем, как мы получаем данные от предыдущего запроса.
 - Асинхронна.
+ *BEDO DRAM* (всё ещё первая половина 90-х)
 - Будем вместе с запроешенной ячейкой отдавать данные сразу из 4-х следующих ячеек. Это опять же даёт нам ускорение, так как подавляющее большинтсво данных лежат в памяти последовательно и читаются последовательно.
 - Адрес должен быть кратен 4.
 - Всё ещё асинхронна.
+ *SDRAM* (вторая половина 90-х)
 - Наконец-то контроллер и модуль памяти стали синхронизированы. За счёт этого получилось значительно увеличить частоту.
 - Шина взаимодействия была расширена до 64 бит.
 - Начали появляться банки памяти(2-4 шт).
+ *DDR* (Double Data Rate — удвоенная скорость передачи данных, 1998 год)
  - Внутренняя шина была расширена в 2 раза.
  - Передача данных происходит и на фронте, и на спаде сигнала синхронизации. Благодаря этому частота "выросла" в 2 раза.
+ *DDR2* (2003 год)
  - Внутренная шина расширена ещё в 2 раза. 
  - Число банков увеличено до 8.
  - Частота внешней шины увеличена в 2 раза.
+ *DDR3* (2007 год)
  - Расширили внутреннюю шину ещё в 2 раза.
  - Увеличили частоту внешней шины ещё в 2 раза.
  - Снизили напряжение питания до 1.5 V.
+ *DDR4* (2014 год)
  - #strike[Расширили внутреннюю шину ещё в 2 раза.]
  - Уменьшили напряжение питания до 1.2 V.
  - Появились группы банков.
  - Увеличили число банков до 16.
+ *DDR5* (2020 год)
  - Уменьшили напряжение питяния до 1.1 V.
  - Увеличили чисто банков до 32.
  - Количество данных, отдаваемых подряд (burth length) увеличили вдвое.
  - У DIMM два независимых канала по 32 бита.




















  

