function compress(sound::Vector, threshold::Float64, ratio::Float64)
    compressed = []
    for i in sound
        if abs(i) > threshold
            push!(compressed, i/ratio)
        else
            push!(compressed, i)
        end
    end
    return compressed
end

function clip_dist(sound::Vector, threshold::Float64)
    dist = []
    for i in sound
        if abs(i) > threshold
            push!(dist, threshold)
        else
            push!(dist, i)
        end
    end
    return dist
end

function lowpass(sound::Vector, amount::Float64)
    # most effective at amount = 0.5
    if amount > 1 || amount < 0
        error("amount must be between 0 and 1")
    end
    filtered = [sound[1]]
    for i in 2:length(sound)
        push!(filtered, amount * sound[i] + (1-amount) * sound[i-1])
    end
    return
end
