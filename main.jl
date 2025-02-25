using LinearAlgebra
using DataFrames
using CSV
using SparseArrays
using PrettyTables
# Cargar datos de líneas y nodos
function carga_datos()
    lin = DataFrame(CSV.File("lines.csv"))
    nod = DataFrame(CSV.File("nodes.csv"))
    return lin, nod
end

# Construir la matriz de admitancias Ybus
function crear_Ybus(lin, num_nod)
    Ybus = zeros(num_nod, num_nod)

    for i in 1:nrow(lin)
        k = lin.FROM[i] # Nodo de inicio
        m = lin.TO[i]   # Nodo final
        xl = lin.X[i]   # Reactancia de la línea
        y_km = 1 / xl   # Admitancia

        Ybus[k, k] += y_km
        Ybus[m, m] += y_km
        Ybus[k, m] -= y_km
        Ybus[m, k] -= y_km
    end
    return Ybus
end

# Eliminar nodo slack (primer nodo) en la matriz Ybus
function reducir_Ybus(Ybus)
    Ybus_red = copy(Ybus)
    Ybus_red[1, :] .= 0  # Primera fila a ceros
    Ybus_red[:, 1] .= 0  # Primera columna a ceros
    return Ybus_red
end

# Calcular la inversa de la matriz reducida de Ybus
function inversa_Ybus(Ybus_red)
    return pinv(Ybus_red)  # Se usa la pseudo-inversa en caso de singularidad
end

# Calcular el Generation Shift Factor (GSF)
function calcular_GSF(Ybus_inv, lin, nod)
    gen_nodes = findall(nod.PGEN .> 0)  # Identificar nodos generadores
    num_lin = nrow(lin)
    GSF = zeros(num_lin, length(gen_nodes))

    for j in 1:length(gen_nodes)
        i = gen_nodes[j]  # Nodo generador

        for l in 1:num_lin
            k = lin.FROM[l] # Extremo 1 de la línea
            m = lin.TO[l]   # Extremo 2 de la línea
            xl = lin.X[l]   # Reactancia de la línea

            Wki = Ybus_inv[k, i]
            Wmi = Ybus_inv[m, i]

            GSF[l, j] = (1 / xl) * (Wki - Wmi)
        end
    end
    return GSF
end

# Calcular el Line Outage Distribution Factor (LODF)
function calcular_LODF(X, lin)
    num_lin = nrow(lin)
    LODF = zeros(num_lin, num_lin)  # Matriz de factores de salida de línea

    for k in 1:num_lin  # Línea que se abre
        x_k = lin[k, :X]  # Reactancia de la línea k
        n_k = lin[k, :FROM]  # Nodo de inicio de la línea k
        m_k = lin[k, :TO]  # Nodo de fin de la línea k

        X_nn = X[n_k, n_k]  # Elemento diagonal nodo n
        X_mm = X[m_k, m_k]  # Elemento diagonal nodo m
        X_nm = X[n_k, m_k]  # Elemento fuera de la diagonal

        den = x_k - (X_nn + X_mm - 2 * X_nm)  # Denominador

        for l in 1:num_lin  # Línea afectada
            if l == k
                LODF[l, k] = 0  # La diagonal debe ser cero
            else
                x_l = lin[l, :X]  # Reactancia de la línea l
                n_l = lin[l, :FROM]  # Nodo de inicio de la línea l
                m_l = lin[l, :TO]  # Nodo de fin de la línea l

                X_in = X[n_l, n_k]  
                X_im = X[n_l, m_k]  
                X_jn = X[m_l, n_k]  
                X_jm = X[m_l, m_k]  

                num = (x_k / x_l) * (X_in - X_jn - X_im + X_jm)  # Numerador

                if den != 0
                    LODF[l, k] = num / den
                else
                    LODF[l, k] = 0  # Manejo de división por cero
                end
            end
        end
    end
    return LODF
end
# Función principal
function main()
    lin, nod = carga_datos()
    num_nod = maximum([maximum(lin.FROM), maximum(lin.TO)]) # Determinar cantidad de nodos
    Ybus = crear_Ybus(lin, num_nod)
    Ybus_red = reducir_Ybus(Ybus)  # Se elimina el nodo slack
    Ybus_inv = inversa_Ybus(Ybus_red)  # Se obtiene la inversa de la Ybus reducida
    GSF = calcular_GSF(Ybus_inv, lin, nod)  # Se calcula el Generation Shift Factor
    LODF = calcular_LODF(Ybus_inv, lin)  # Se calcula el Line Outage Distribution Factor

    println("Matriz Ybus reducida:")
    pretty_table(Ybus_red)

    println("Matriz inversa de Ybus reducida:")
    pretty_table(Ybus_inv)

    println("Generation Shift Factors (GSF):")
    pretty_table(GSF)

    println("Line Outage Distribution Factors (LODF):")
    pretty_table(LODF)
end

# Ejecutar el programa
main()
