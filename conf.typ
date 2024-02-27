#let conf(doc, color: black, title: "", pageHeader: "", credits: "") = {
  set text(11pt, font: "Linux Libertine", lang: "RU", region: "RU")
  set par(justify: true)

  show heading: i => {
    set text(fill: color)
    i
  }

  align(center, title)
  credits
  outline(title: [Содержание], depth: 2, indent: true)

  set page(
    header: align(right + horizon)[
      Билеты к экзамену по ЭВМ.
    ],
    footer: align(
      center + horizon,
      [#counter(page).display()],
    ),
    margin: (x: 1cm, y: 1cm),
  )

  set heading(numbering: "1.1. ")  

  doc
}