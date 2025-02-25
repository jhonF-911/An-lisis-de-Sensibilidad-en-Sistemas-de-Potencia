# Análisis de Sensibilidad en Sistemas de Potencia

## Marco Teórico

### Generation Shift Factor (GSF)
El Generation Shift Factor (GSF) es una medida de cómo un cambio en la generación en un nodo afecta el flujo de potencia en una línea. La fórmula es:
```math
GSF_{l,j} = \frac{1}{x_l} (W_{ki} - W_{mi})
```
donde:
- $x_l$: Reactancia de la línea
- $W_{ki}$, $W_{mi}$: Elementos de la inversa de la matriz Ybus reducida

### Line Outage Distribution Factor (LODF)
El Line Outage Distribution Factor (LODF) mide el impacto de la apertura de una línea en el flujo de potencia de otras líneas. La fórmula es:
```math
LODF_{l,k} = \frac{x_k}{x_l} \frac{X_{in} - X_{jn} - X_{im} + X_{jm}}{x_k - (X_{nn} + X_{mm} - 2X_{nm})}
```
donde:
- $x_k$, $x_l$: Reactancias de las líneas
- $X_{in}$, $X_{jn}$, $X_{im}$, $X_{jm}$: Elementos de la inversa de la matriz Ybus reducida
- $X_{nn}$, $X_{mm}$, $X_{nm}$: Elementos de la inversa de la matriz Ybus reducida

## Funciones Implementadas

### 1. `carga_datos()`
Carga los datos de las líneas y nodos desde archivos CSV.

**Librerías utilizadas:**
- `DataFrames`: Manipulación de datos tabulares
- `CSV`: Lectura de archivos CSV

**Entradas (Inputs):**
- Ninguna

**Salidas (Outputs):**
- `lin`: DataFrame con información de las líneas
- `nod`: DataFrame con información de los nodos

### 2. `crear_Ybus(lin, num_nod)`
Construye la matriz de admitancia nodal Ybus.

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales

**Entradas (Inputs):**
- `lin`: DataFrame con información de las líneas
- `num_nod`: Número de nodos

**Salidas (Outputs):**
- `Ybus`: Matriz de admitancia nodal

### 3. `reducir_Ybus(Ybus)`
Elimina el nodo slack de la matriz Ybus.

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales

**Entradas (Inputs):**
- `Ybus`: Matriz de admitancia nodal

**Salidas (Outputs):**
- `Ybus_red`: Matriz de admitancia nodal reducida

### 4. `inversa_Ybus(Ybus_red)`
Calcula la inversa de la matriz Ybus reducida.

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales

**Entradas (Inputs):**
- `Ybus_red`: Matriz de admitancia nodal reducida

**Salidas (Outputs):**
- `Ybus_inv`: Inversa de la matriz Ybus reducida

### 5. `calcular_GSF(Ybus_inv, lin, nod)`
Calcula el Generation Shift Factor (GSF).

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales

**Entradas (Inputs):**
- `Ybus_inv`: Inversa de la matriz Ybus reducida
- `lin`: DataFrame con información de las líneas
- `nod`: DataFrame con información de los nodos

**Salidas (Outputs):**
- `GSF`: Matriz de Generation Shift Factors

### 6. `calcular_LODF(X, lin)`
Calcula el Line Outage Distribution Factor (LODF).

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales

**Entradas (Inputs):**
- `X`: Inversa de la matriz Ybus reducida
- `lin`: DataFrame con información de las líneas

**Salidas (Outputs):**
- `LODF`: Matriz de Line Outage Distribution Factors

### 7. `main()`
Función principal que ejecuta el flujo completo del análisis.

**Librerías utilizadas:**
- `LinearAlgebra`: Operaciones matriciales
- `DataFrames`: Manipulación de datos tabulares
- `CSV`: Lectura de archivos CSV
- `PrettyTables`: Formateo de tablas para impresión

**Entradas (Inputs):**
- Ninguna

**Salidas (Outputs):**
- Impresiones de las matrices Ybus reducida, su inversa, GSF y LODF

## Resultados
![\[Aquí puedes incluir gráficos o resultados relevantes\]](Resultado.png)

## Licencia
Hecho por: Jhon Edward Bedoya Olarte
j.bedoya3@utp.edu.co

<p xmlns:cc="http://creativecommons.org/ns#">Esta obra está licenciada bajo <a href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1">CC BY 4.0</a></p>