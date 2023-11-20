# DSNMF
Implementation of deep semi non-negative matrix factorization for leadfield matrix analysis in EEG



>INPUT:\
{\
$M^{m \times n}$ - macierz leadfield,\
$L$ - liczba warstw,\
$E_{1 \times L}$ - wektor liczby epok dla każdej warstwy,\
$E_{u}$ - liczba epok uczenia głębokiego,\
$\epsilon$ - akceptowalny błąd przybliżenia\
}
>
>OUTPUT: &nbsp;
$P_{1 \times L+1}$ - wektor z uzyskanymi macierzami
>
>1. ROZKŁAD MACIERZY
>  * $temp \gets M$
>  * __For__ ($i$ from 0 to $L$)
>    * zainicjuj macierze $Z^{m \times m}$ i $H^{m \times n}$ losowymi wartościami
>    * __For__ ($j$ from 0 to $E_L$)
>      * $M_{pred} \gets Z * H$
>      * $l \gets \sum_{j}^{m} \sum_{i}^{n} (M_{i,j} - M_{pred(i,j)})^2$
>      * oblicz gradient w funkcji mnożenia macierzy
>      * wykonaj krok optymalizatora
>      * $H \gets H^{+}$
>    * $P_{L} \gets Z$
>    * $temp \gets H$
>  * $P_{L+1} \gets H$
>
>2. GŁĘBOKIE UCZENIE
>  * __For__ ($i$ from 0 to $E_u$)
>    * $M_{pred} \gets \Pi^{L+1}_{j=0} (P_{j})$
>    * $l \gets \sum_{j}^{m} \sum_{i}^{n} (M_{i,j} - M_{pred(i,j)})^2$
>    * oblicz gradient w funkcji mnożenia macierzy
>    * wykonaj krok optymalizatora
>    * $P_{L+1} \gets P_{L+1}^{+}$
>    * __If__ ($l < \epsilon$)
>      * przerwij działanie programu

>INPUT:\
>{\
>$H^{m \times n}$ – macierz cech latentnych,\
>$M^{m \times n}$ – macierz przejść,\
>$c$ – liczba docelowych klastrów\
>}\
>OUTPUT: &nbsp;
$M_C$ - fragmentaryczne macierze przejść odtworzone według klastrów, zapisywane jako .csv
>1. CLUSTERING
>  * $h \gets vec(H)$
>  * $h \gets h / ||h||$
>  * For (each element in $h$)
>    * $h_{i} \gets (1, h_{i})$
>  * $c_{labels} \gets$ k-średnich na $h$ dla $c$ docelowych klastrów, wektor etykiet $(1, m*n)$
>  * $c_{labels} \gets vec^{-1}_{m \times n}(c_{labels})$
>  * __For__ (each cluster label $c$ in $c_{labels}$)
>    * $M_C \gets \Theta^{m \times n}$
>    * __For__ (each row $i$ in $c_{labels}$)
>      * __For__ (each column $j$ in $c_{labels}$)
>        * __If__ ($C_{labels(i,j)} = c$)
>          * $M_{C(i,j)} \gets M_{i,j}$
>    * Save $M_C$ in .csv file