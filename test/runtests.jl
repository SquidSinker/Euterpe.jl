using Euterpe
using Test

@testset "Euterpe.jl" begin
    notes = ["A4, C2, Db6"]
    frequencies = notes_to_freq(notes)
    @test frequencies[1] == 440
    @test length(frequencies) == 3

    adsr = ADSR(0.2, 0.1, 0.4, 0.3)
    sound = sine(440, 1)
    adsrsound = ADSRapply(adsr, sound)
    @test length(adsrsound) == length(sound)
end
