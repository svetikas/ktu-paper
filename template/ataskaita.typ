#import "@local/ktu-paper:0.5.0": (
  ktu-paper,
  ktu-table-of-contents, ktu-picture-list, ktu-table-list, ktu-code-list,
  ktu-heading-page-normal,
  ktu-table,
  unnumbered-heading,
  custom-ref, ref-no
)

#show: ktu-paper.with(
  font: "Times New Roman", // or Arial
  figureNumberingPerSection: true,
  figureKinds: (
    veryCustomKind: (supplement: "komanda", ref-name: "komanda"),
  ),
  // Code blocks, optional, `code: none` disables styling
  code: (
    font: "Hack",
    spacing: 80%,
    fill: white,
    stroke: 0.5pt + black,
    numbers: true,
    display-name: false,
    display-icon: false,
  ),
)

#show math.equation: it => {
  show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
    it}
  it
}

#ktu-heading-page-normal(
  faculty: highlight[Informatikos fakultetas],
  title: highlight[Laboratorinio darbo ataskaitos pavadinimas],
  subtitles: (
    "Laboratorinio darbo ataskaita",
    highlight[Studijų modulio pavadinimas (kodas)]
  ),
  authors: (
    (highlight[Vardenis Pavardenis], "Ataskaitą parengė"),
    (highlight[Pareigų ir mokslo laipsnio sutrumpinimas Vardenis Pavardenis], "Laboratoriniam darbui vadovavo"),
  ),
  authorNamesFirst: false,
  place: "Kaunas",
  year: datetime.today().year(),
)
#pagebreak()
#set page(numbering: "1")

#ktu-table-of-contents()
#pagebreak()

#ktu-picture-list()
#pagebreak()

#ktu-table-list()
#pagebreak()

#ktu-code-list()
#pagebreak()

#unnumbered-heading[= Įvadas]
#lorem(50)

#pagebreak()
= Skyrius
#lorem(50)

== Poskyrius
#lorem(50)

=== Dalis
#lorem(50)

#pagebreak()
= Komponentai

== Paveikslai
Galima gauti paveikslo numerį #ref-no(<image-label>) arba visą paveikslo nuorodą #custom-ref(<image-label>).

#figure(
  image("images/santaka.png", width: 70%),
  caption: [
    Paveikslo pavadinimas
  ],
) <image-label>


== Paveikslų "grid" išdėstymas
Paveikslus taip pat galima sudėti į "grid" išdėstymą, į jį kreiptis kaip numerį #ref-no(<image-grid-label>) arba visą nuorodą #custom-ref(<image-grid-label>).

#figure(grid(
  columns: 2,
  gutter: 2mm,
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
), caption: [
  Paveikslėliai "grid'e"
]) <image-grid-label>


== Lentelės

Galima gauti lentelės numerį /*#ref-no(<table-label>)*/ arba visą lentelės nuorodą #custom-ref(<table-label>).

#figure(
  ktu-table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (x, y) => { horizon + left },
    table.header([*Stulpelio pavadinimas*], [*Stulpelio pavadinimas*], [*Stulpelio pavadinimas*], [*Stulpelio pavadinimas*]),
    [Eilutė 1], [...], [...], [...],
    [Eilutė 2], [...], [...], [...],
    [Eilutė 3], [...], [...], [...],
    [Eilutė 4], [...], [...], [...],
  ),
  caption: [Lentelės pavadinimas],
) <table-label>


== Formulės
Formules galima išreikšti eilutėje, pavyzdžiui $E = m c^2$ arba atskiroje eilutėje, pavyzdžiui:
$
  E = m c^2
$ <formula-label>

// TODO: fix
Formulės atskiroje eilutėje numeruojamos besąlygiškai, galima gauti formulės numerį #ref-no(<formula-label>) arba visą formulės nuorodą #custom-ref(<formula-label>).

== Kodo fragmentai
Kodo fragmentus galima išreikšti eilutėje, pavyzdžiui `print("Hello, world!")` arba atskiroje eilutėje, pavyzdžiui:
#figure(```python
def main():
  print("Hello, world!")
if __name__ == "__main__":
  main()
```, caption: [
  Python kodas
]) <code-label>

Galima gauti kodo fragmento numerį #ref-no(<code-label>) arba visą kodo fragmento nuorodą #custom-ref(<code-label>).

== Naudotojo apibrėžtos figūros

Naudotojai tai pat gali apibrėžti savo figūras, pavyzdžiui, komandų fragmentus. Pavyzdžiui, galima apibrėžti komandų fragmentą su papildoma informacija ir naudoti jį dokumente. Galima gauti kodo fragmento numerį #ref-no(<custom-figure-label>) arba visą kodo fragmento nuorodą #custom-ref(<custom-figure-label>).

#figure(
  ```sh
  npm install foo
  ```,
  kind: "veryCustomKind",
  supplement: "...",
  caption: [Diegimo komanda],
) <custom-figure-label>

#pagebreak()
= Išvados
#lorem(50)