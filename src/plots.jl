using .Plots

function preprocess(name, plot::Plots.Plot, data)
    push!(data, name=>plot)
    return data
end

function preprocess(name, plots::AbstractArray{<:Plots.Plot}, data)
    for (i, plot)=enumerate(plots)
        preprocess(name*"/$i", plot, data)
    end
    return data
end

function log_plot(lg::CLogger, name::AbstractString, obj::Plots.Plot; step=nothing)
    mktempdir(;prefix="jlcom_") do dirname
        fname = joinpath(dirname, name, "plot.png")
        savefig(obj, fname)
        log_image(lg, name, fname; step=step, copy_to_tmp=false)
    end
end

process(lg::CLogger, name::AbstractString, obj::Plots.Plot, step::Int) = log_plot(lg, name, obj; step=step)