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