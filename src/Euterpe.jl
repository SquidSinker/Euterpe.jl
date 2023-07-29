module Euterpe

using PortAudio
using SampledSignals
using FFTW
using ModelingToolkit
using DifferentialEquations

export play, sine, square, sawtooth, play, ADSR, ADSRlevels, ADSRapply,
        note_to_freq, notes_to_freq, clip_dist, lowpass, highpass, compress

include("notes.jl")
include("effects.jl")
include("envelopes.jl")


function sine(freq, time, samplerate=44100)
    T = (1:time*samplerate)/samplerate
    cospi.(2*T*freq)
end

function square(freq, time, samplerate=44100)
    (sign ∘ sinpi).(2*(1:time*samplerate)*freq/samplerate)
end

function sawtooth(freq, time, samplerate=44100)
    (2*freq) .* mod.((1:time*samplerate)/samplerate, 1/freq) .- 1
end

function play(x::Vector{Float64} ; samplerate=44100)
    PortAudioStream(0, 2; warn_xruns = false, samplerate=samplerate) do stream
        write(stream, x)
    end
end

function sequence(instrument::Function, freq::Vector, time=0.5)
    x = Float64[]
    for f in freq
        x = vcat(x, instrument(f, time))
    end
    return x
end

function chords(instrument::Function, freq::Vector, time=0.5)
    x = instrument(freq[1], time)
    for f in freq[2:end]
        x .+= instrument(f, time)
    end
    normalize(x)
end

function normalize(s::Vector)
    return s ./ (maximum(abs.(s)))
end

function add(oscillators, freq, time, samplerate=44100 )
    s = zeros(length((1:time*samplerate)/samplerate))
    for o in oscillators
        s .+= o[2] .* o[1](freq, time, samplerate)
    end
    return normalize(s)
end

add([(sine, 0.2), (sawtooth, 0.8)], 440, 0.5)

end
