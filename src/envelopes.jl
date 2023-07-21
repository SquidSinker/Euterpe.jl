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
        return values.sustainlevel - ( (t - (1-values.r))/values.r ) * values.sustainlevel # release                           # release
    end
end

function ADSRapply(values::ADSR, t::Vector{Float64})
    [ADSRlevels(values, (i-1)/length(t))*t[i] for i in 1:length(t)]
end