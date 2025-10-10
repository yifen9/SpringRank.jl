module MetricsPrediction

using Tables, Statistics

function _scores_from_edges(r::AbstractVector, edges)
    t = Float64[]
    s = Float64[]
    for row in Tables.rows(edges)
        i = Int(getproperty(row, :src))
        j = Int(getproperty(row, :dst))
        w = hasproperty(row, :w) ? Float64(getproperty(row, :w)) : 1.0
        push!(t, w > 0 ? 1.0 : 0.0)
        push!(s, r[i] - r[j])
    end
    return t, s
end


function predict_direction(r::AbstractVector, edges; threshold::Real = 0.0)
    t, s = _scores_from_edges(r, edges)
    correct = 0
    for k in eachindex(t)
        yhat = s[k] > threshold ? 1.0 : 0.0
        correct += yhat == t[k]
    end
    acc = correct / length(t)
    return (acc = acc, y_true = t, y_score = s)
end

function auc_from_scores(y_true::AbstractVector{<:Real}, y_score::AbstractVector{<:Real})
    n = length(y_true)
    p = count(>(0.0), y_true)
    nneg = n - p
    if p == 0 || nneg == 0
        return NaN
    end
    ord = sortperm(y_score, rev = false, alg = QuickSort)
    ranks = similar(y_score, Float64, n)
    i = 1
    while i <= n
        j = i
        v = y_score[ord[i]]
        while j <= n && y_score[ord[j]] == v
            j += 1
        end
        avg = (i + j - 1) / 2
        for k = i:(j-1)
            ranks[ord[k]] = avg
        end
        i = j
    end
    sumpos = 0.0
    for k = 1:n
        if y_true[k] > 0
            sumpos += ranks[k]
        end
    end
    u = sumpos - p*(p+1)/2
    return u / (p*nneg)
end


function evaluate_prediction(r, edges_test)
    res = predict_direction(r, edges_test)
    auc = auc_from_scores(res.y_true, res.y_score)
    return (acc = res.acc, auc = auc)
end

function predict_proba(r::AbstractVector, edges; β::Real = 1.0)
    t, s = _scores_from_edges(r, edges)
    p = 1.0 ./ (1.0 .+ exp.(-β .* s))
    return (proba = p, y_true = t, y_score = s)
end


export predict_direction, evaluate_prediction, auc_from_scores, predict_proba

end
