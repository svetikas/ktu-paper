#import "@local/ktu-paper:0.3.1": (
  ktu-paper, setup-code,
  ktu-table-of-contents, ktu-picture-list, ktu-table-list,
  ktu-heading-page-normal,
  ktu-table,
  custom-ref, ref-no
)

#show: ktu-paper.with(
  font: "Times New Roman",
)
#show: setup-code.with()

#show math.equation: it => {
    show regex("\d+\.\d+"): it => {show ".": {","+h(0pt)}
        it}
    it
}

#ktu-heading-page-normal(
    faculty: "Fakulteto pavadinimas",
    title: "Rašto darbo pavadinimas",
    subtitles: "Praktikos ataskaita / referatas ir pan. (įrašyti rašto darbo tipą)",
    authors: (
        ("Vardenis Pavardenis", "Projekto autorius"),
        ("Vardenis Pavardenis", "Vadovas"),
    ),
    place: "Kaunas",
    year: datetime.today().year(),
)
#pagebreak()

#ktu-table-of-contents()
#pagebreak()

#ktu-picture-list()
#pagebreak()

#ktu-table-list()
#pagebreak()

= Sąrašai

Vienas sąrašas:
1. Vienas;
2. Du;
3. Trys.

Kitas sąrašas:
- Vienas;
- Du;
- Trys.

#pagebreak()

= Skyrius

== Poskyris

=== Skyrelis

...

== Matematikos poskyris

Skaitiniams tipams yra naudojamas histogramos. Histogramų binų (stulpelių) skaičius nustatomas formule: $1 + 3.22 dot log_10 n$, kur n -- imties dydis.

Mūsų atveju, $n = 4908$, tada $"binų skaičius" approx 12.88 = 12$.

== Tolydaus tipo atributai

Šias apskaičiuotas charakteristikas pateikiame lentelėje:

#{
show table.cell: set text(size: 8pt)
[#figure(
  ktu-table(
    columns: (25mm, 13mm, 17mm, 20mm, auto, auto, auto, auto, auto, auto, 17mm),
    align: (x, y) => if x == 0 or y == 0 { horizon + left } else { horizon + right },
    table.header([*Atributo pavadinimas*], [*Kiekis (eilučių skaičius)*], [*Trūkstamos reikšmės, %*], [*Kardinalumas*], [*Min reikšmė*], [*Max reikšmė*], [*1-asis kvartilis*], [*Mediana*], [*3-iasis kvartilis*], [*Vidurkis*], [*Standartinis nuokrypis*]),
    [age], [5110], [0,0], [104], [0,08], [82,0], [25,0], [45,0], [61,0], [43,227], [22,613],
    [avg_glucose_level], [5110], [0,0], [3979], [55,12], [271,74], [77,245], [91,885], [114,09], [106,148], [45,284],
    [bmi], [5110], [3,933], [418], [10,3], [97,6], [23,5], [28,1], [33,1], [28,893], [7,854],
  ),
  caption: [
    Skaitinio tipo atributų statistinės charakteristikos
  ],
) <tab-1>]
}

Įdomus pastebėjimas, kad amžiaus minimali reikšmė yra "0,080". Tai yra logiška, kadangi yra vaikų duomenų. Kitas pastebėjimas -- trūksta "bmi" duomenų 3,9% visų įrašų. Atributų kardinalumas yra aukštas, todėl juos tikrai galima laikyti tolydžiais.


Duomenų sklaidą yra patogu pavaizduoti ir stačiakampe diagrama:

#figure(
  image("images/santaka.png", width: 70%),
  caption: [
    Skaitinių atributų stačiakampė diagrama
  ],
)

Matome, kad "avg_glucose_level" ir "bmi" atributai turi gana daug išimčių. Tačiau čia reikia būti atsargiems, kadangi išimtys nustatomos kaip reikšmės už interkvartilinio intervalo. Patikrinkime ar šios vertės nėra įvedimo klaidos.

Anot https://www.who.int/data/gho/indicator-metadata-registry/imr-details/2380, normalus gliukozės lygis nevalgius yra apie 70-100 mg/dL. Lyginant su mmol/L, tikėtina, kad "avg_glucose_level" yra matuojamas mg/dL. Tada matome, kad maksimali vertė 2,72 kartų didesnė už normą.

Kūno masės indekso rodiklis apskaičiuojamas formule: $"BMI" = "svoris" / "ūgis" = "kg" / "m"^2$. Tikrinami maksimalią vertę darykime prielaidą, kad asmens ūgis = 1,6 m, tada svoris = $97 dot 1.6^2$ = 248,32 kg.

== Duomenų problemų taisymas

#lorem(70)

#lorem(70)

#lorem(70)

Kažkas... $[Q_1 - 1.5 dot "IQR"; Q_3 + 1.5 dot "IQR"]$ intervale.

#figure(```python
def main():
  print("Hello, world!")

if __name__ == "__main__":
  main()
```, caption: [
  Python kodas
])


== Image grids

#lorem(120)

Paveikslėlius galima grupuoti į "grid" #custom-ref(<image-grid-2>, <image-grid-3>)

#figure(grid(
  columns: 2,
  gutter: 2mm,
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
), caption: [
  Paveikslėliai "grid'e" 1
]) <image-grid-2>

#figure(grid(
  columns: 3,
  gutter: 2mm,
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
  image("images/santaka.png", width: 100%),
), caption: [
  Paveikslėliai "grid'e" 2
]) <image-grid-3>

#pagebreak()

= Skyrius

#lorem(160) Gauti skaičiai @table-1 tikrai dideli.

#{
show table.cell: set text(size: 8pt)
[#figure(
  table(
    columns: (33mm, 13mm, 17mm, 20mm, 13mm, 13mm, 13mm, 13mm, 13mm, 13mm, 17mm),
    align: (x, y) => if x == 0 or y == 0 { horizon + left } else { horizon + right },

    [*Atributo pavadinimas*], [*Kiekis (eilučių skaičius)*], [*Trūkstamos reikšmės, %*], [*Kardinalumas*], [*Min reikšmė*], [*Max reikšmė*], [*1-asis kvartilis*], [*Mediana*], [*3-iasis kvartilis*], [*Vidurkis*], [*Standartinis nuokrypis*],
    [age], [4908], [0.0], [104], [0.08], [82.0], [25.0], [44.0], [60.0], [42.869], [22.556],
    [hypertension], [4908], [0.0], [2], [0], [1], [0.0], [0.0], [0.0], [0.092], [0.289],
    [heart_disease], [4908], [0.0], [2], [0], [1], [0.0], [0.0], [0.0], [0.05], [0.217],
    [avg_glucose_level], [4908], [0.0], [3851], [55.12], [271.74], [77.0675], [91.68], [113.495], [105.297], [44.426],
    [bmi], [4908], [0.0], [418], [10.3], [97.6], [23.5], [28.1], [33.1], [28.895], [7.854],
    [stroke], [4908], [0.0], [2], [0], [1], [0.0], [0.0], [0.0], [0.043], [0.202],
  ),
  caption: [
    Lentelės pavadinimas
  ],
) <table-1>]
}

Kažkokia formulė apibrėžiama taip:

$
  Z = (X - mu) / sigma
$

čia $X$ -- imtis, $mu$ -- imties vidurkis, $sigma$ -- imties standartinis nuokrypis. Fragmentas pateikiamas #ref-no(<image-1>) paveikslėlyje.

#figure(
  image("images/santaka.png", width: 90%),
  caption: [
    Paveikslėlio pavadinimas
  ],
) <image-1>

#pagebreak()

= Išvados

- Viską bandėme.
- Viskas pavyko.
