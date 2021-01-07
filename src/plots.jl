import .Plots: Plots
import .ImageIO: ImageIO

function preprocess(name, plot::Plots.Plot, data)
    pb = PipeBuffer()
    show(pb, MIME("image/png"), plot)
    arr = ImageIO.load(pb)
    push!(data, name=>arr)
    return data
end

function preprocess(name, plots::AbstractArray{<:Plots.Plot}, data)
    for (i, plot)=enumerate(plots)
        preprocess(name*"/$i", plot, data)
    end
    return data
end