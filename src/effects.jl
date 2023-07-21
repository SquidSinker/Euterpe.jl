function compress(sound::Vector, threshold::Float64, ratio::Float64)
    compressed = []
    for i in sound
        if i > threshold
            push!(compressed, i/ratio)
        end
    end
end