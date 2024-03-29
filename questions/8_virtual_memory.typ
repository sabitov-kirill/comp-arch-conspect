#heading[Виртуальная память.]
#emph[Виртуальная память (Зачем нужна? Что такое страница, Page Table, TLB? Зачем нужны многоуровневые таблицы страниц?).]

#import "/commons.typ": imagebox
=== Основной смысл использования виртуальной памяти
+ Виртуальная память разделяет адресное пространство процессов, которые работают в операционной системе
+ Помимо того, что адресные пространства процессов при работе виртуальной памяти разделены, эти же адресные пространства представляют собой один большой непрерывный блок, что в значительной степени упрощает жизнь.
+ Виртуальная память позволяет создать иллюзию того, что все процессы могут использовать больше оперативной памяти, чем ее есть на самом деле физически у текущего устройства.

=== Изолирование процессов в памяти
+ У каждого процесса создается представление, что он один находится в памяти. Таким образом процессу не надо задумываться о том, что какой-либо участок памяти может быть использован кем-то другом.
+ Наблюдается хороший фактор безопасности. При наличии виртуальной памяти по умолчанию процесс не может обратиться к памяти другого процесса. Но существует возможность контролировать данное ограничение, разрешая доступ тем или иным процессам.

=== Реализация механизма виртуальной памяти
#imagebox("virtualPage.png", height: 150pt)
Механизм виртуальной памяти реализуется в блоке управления памяти (MMU -- memory management unit). Информация о том, как транслировать адресное пространство процессов в реальное адресное пространство физической памяти (отображение) хранится в специальных структурах данных, каждую из которых называют page table (page directory / таблица директорий). 

#emph[Основная идея реализации]:
+ Вся память разбивается на блоки фиксированного размера. Каждый такой кусочек будет иметь название #emph[страница]. Характерный размер страниц в современных компьютерах - 4 Кб.
+ После чего создаётся специальная структура. Для каждого процесса создаётся так называемый page table.
+ Page table внутри себя хранит информацию об отображении между страницами виртуальной памяти и страницами физической памяти. У каждого процесса будет свой page table, соответственно отображение у каждого процесса будет свое.
#columns(2)[
  #imagebox("vpp.png", height: 125pt)
  #colbreak()
  #imagebox("brzqm.png", height: 125pt)  
]

Важно понимать, что виртуальный адрес (на примере 32 бит) в первых 20 бит хранит в себе информацию о virtual page number. В остальных же 12 бит хранится смещение (offset). Таким образом, по первым 20 битам можно понять необходимый virtual address. После чего с помощью полученного виртуального адреса, используя page table, можно получить physical page number. Далее, используя offset можно дополнить полный физический адрес. Offset не меняется при трансляции виртуального адреса в физический.

#emph[Основная проблема одноуровневой реализации]:

Как уже было сказано, типичный размер страницы - 4 Кб. Также offset - 12 бит и 20 бит на выбор директории. Если каждый directory entry по 4 байта, то вся таблица весит около 4 Мб. Посколько у каждого процесса своя таблица, а процессов может быть сотни тысяч, таким образом, может получится так, что место, которое нужно, чтобы хранить таблицы страниц для процессов, уже займёт всю оперативную память.

=== Многоуровневые таблицы страниц
Заметим, что процессы практически никогда не используют все свое адресное пространство. В реальности процессам нужно десятки, в худшем случае сотни мегабайт. Таким образом, в среднем процессам нужно не очень много памяти, но при этом одноуровневый подход явно пытается похранить отображения для всего адресного пространства, не смотря на то, что большая часть этого маппинга никак не используется. Для того, чтобы хранить отображения только того, что действительно используется, используют многоуровневые таблицы страниц.
#imagebox("vLevels.png", height: 150pt)
#emph[Основная идея]:

Page Table сможет ссылаться не только на страницы физической памяти, но и на другие page table. Таким образом, адрес будет разбит не на две части, как было до этого, а на несколько частей (в зависимости от реализации, обычно используется разбиение 4 уровня, то есть на 5 частей). Внутри этого адреса будут храниться смещения (offset) внутри других page table.

Основной плюс такого подхода заключается в том, что в случае, если процесс использует не очень много памяти, то для такого процесса можно обойтись сравнительно малым количеством page table с второго по четвёртый уровень (в показанной выше реализации). Соответственно, при неиспользовании какого-либо участка адресного пространства, то соответствующие ему page table на некоторых уровнях можно не хранить.

+ Тривильно использование 4 уровней.
+ Адрес Level 4 Directory хранится в специальном регистре (CR3)
+ Если какой-либо directory entry пустой, то можно не хранить директории более низкого уровня.

Таким образом, в общем случае многоуровневая структура представляет собой разреженное дерево, где корнем является page table 4 уровня. Для хранения такой структуры требуется значительно меньше памяти.

=== Transaction Look-aside Buffer (TLB)
Не трудно заметить, что в случае, если, например, в многоуровневой таблице используются 4 уровня, то на один запрос к памяти нужно сделать 5 запросов к физической памяти (получить page table 4,3,2,1 и потом по физическому адресу страницы получить адрес к которому идёт обращение).

#emph[TLB] - специализированный кэш центрального процессора, используемый для ускорения трансляции адреса виртуальной памяти в адрес физической памяти.

TLB используется всеми современными процессорами с поддержкой страничной организации памяти. Каждая запись содержит соответствие адреса страницы виртуальной памяти адресу физической памяти. Если адрес отсутствует в TLB, процессор обходит таблицы страниц и сохраняет полученный адрес в TLB, что занимает в 10 — 60 раз больше времени, чем получение адреса из записи, уже закэшированной TLB. Вероятность промаха TLB невысока и составляет в среднем от 0,01% до 1%.

#imagebox("TLB.png", height: 250pt)

В современных процессорах может быть реализовано несколько уровней TLB с разной скоростью работы и размером. Самый верхний уровень TLB будет содержать небольшое количество записей, но будет работать с очень высокой скоростью, вплоть до нескольких тактов. Последующие уровни становятся медленнее, но вместе с тем и больше.

Поскольку TLB существует в единственном экземпляре, то при переключение на другой процесс нужно очищать TLB. В зависимости от реализации существуют разные решения данной проблемы. Одно из них - хранить идентификатор данных ядра операционной системе, поскольку наиболее часто переключение происходит именно между ей и текущим процессом.


