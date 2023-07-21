const freq = Dict("C" => 16.35, "Db" => 17.32, "D" => 18.35, "Eb" => 19.45, "E" => 20.60, "F" => 21.83, "Gb" => 23.12, "G" => 24.50, "Ab" => 25.96, "A" => 27.50, "Bb" => 29.14, "B" => 30.87)

function note_to_freq(note::String, octave::Integer)
    return freq[note] * 2^octave
end

function note_to_freq(notein::String)
    if length(notein) == 2
        note = string(notein[1])
    else
        note = notein[1:2]
    end
    oct = parse(Int, notein[end])
    note_to_freq(note, oct)
end

function notes_to_freq(notesin::Vector{String})
    return note_to_freq.(notesin)
end