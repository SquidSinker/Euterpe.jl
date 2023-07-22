module Euterpe

using PortAudio
using SampledSignals
using FFTW

export play, sine, square, sawtooth, play, ADSR, ADSRlevels, ADSRapply, note_to_freq, notes_to_freq, clip_dist, lowpass, highpass

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


end
