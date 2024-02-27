#import "conf.typ": conf

#show: rest => conf(rest,
  title: [
    = Билеты к экзамену по Арх. ЭВМ (Первый семестр)
  ],
  pageHeader: [
    Билеты к экзамену по Арх. ЭВМ
  ],
  credits: [
    #align(center)[#text(gray)[
      Created by Sabitov Kirill, Panasyuk Igor, Berezhnoy Akim\
      January 2023
    ]]
  ],
  color: blue,
)

#{
  // All tickets list
  let tickets = (
    "1_phisical_base.typ",
    "2_numbers.typ",
    "3_functional_schemes.typ",
    "4_memory.typ",
    "5_chipsets.typ",
    "6_ram.typ",
    "7_cache.typ",
    "8_virtual_memory.typ",
    "9_isa.typ",
    "11_storage.typ",
    "12_parallel.typ",
  )
  
  for ticket in tickets {
    pagebreak()
    include ("questions/" + ticket)
  }
}
