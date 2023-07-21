module Euterpe

using PortAudio
using SampledSignals
using FFTW

export play, sine, square, sawtooth, play, ADSR, ADSRlevels, ADSRapply

struct ADSR
    a::Float64
    d::Float64
    s::Float64
    r::Float64
    sustainlevel::Float64

    function ADSR(a, d, s, r, sustainlevel)
        if a+d+s+r != 1
            error("ADSR should sum to 1.")
        end
        if sustainlevel > 1
            error("Sustain level should be below 1")
        end

        new(a,d,s,r, sustainlevel)
    end
end

function ADSRlevels(values::ADSR, t::Float64) # t is percentage of duration through note
    if t <= values.a
        return (t/values.a)*1                                              # attack
    elseif t <= (values.a + values.d)
        return 1-((1 - values.sustainlevel) * ((t-values.a)/values.d))     # decay
    elseif  t <= values.a+values.d+values.s
        return values.sustainlevel                                         # sustain
    else
        return values.sustainlevel - ( (t - (1-values.r))r ) * values.sustainlevel # release                           # release
    end
end

function ADSRapply(values::ADSR, sound::Vector{Float64})
    [ADSRlevels(values, i-1/length(sound))*sound[i] for i in 1:length(sound)]
end

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
