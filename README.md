# DSNMF
Implementation of deep semi non-negative matrix factorization for leadfield matrix analysis in EEG

README will be updated as soon as I can upload my Engineering thesis.

```
INPUT:\
{\
$M^{m \times n}$ - macierz leadfield,\
$L$ - liczba warstw,\
$E_{1 \times L}$ - wektor liczby epok dla każdej warstwy,\
$E_{u}$ - liczba epok uczenia głębokiego,\
$\epsilon$ - akceptowalny błąd przybliżenia\
}

OUTPUT: &nbsp;
$P_{1 \times L+1}$ - wektor z uzyskanymi macierzami
1. ROZKŁAD MACIERZY
  * $temp \gets M$
  * __For__ ($i$ from 0 to $L$)
    * zainicjuj macierze $Z^{m \times m}$ i $H^{m \times n}$ losowymi wartościami
    * __For__ ($j$ from 0 to $E_L$)
      * $M_{pred} \gets Z * H$
      * $l \gets \sum_{j}^{m} \sum_{i}^{n} (M_{i,j} - M_{pred(i,j)})^2$
      * oblicz gradient w funkcji mnożenia macierzy
      * wykonaj krok optymalizatora
      * $H \gets H^{+}$
    * __EndFor__
    * $P_{L} \gets Z$
    * $temp \gets H$
  * __EndFor__
  * $P_{L+1} \gets H$

2. GŁĘBOKIE UCZENIE
  * __For__ ($i$ from 0 to $E_u$)
    * $M_{pred} \gets \Pi^{L+1}_{j=0} (P_{j})$
    * $l \gets \sum_{j}^{m} \sum_{i}^{n} (M_{i,j} - M_{pred(i,j)})^2$
    * oblicz gradient w funkcji mnożenia macierzy
    * wykonaj krok optymalizatora
    * $P_{L+1} \gets P_{L+1}^{+}$
    * __If__ ($l < \epsilon$)
      * przerwij działanie programu
    * __EndIf__
  * __EndFor__
```