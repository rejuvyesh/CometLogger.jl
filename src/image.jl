using .ImageIO

"""
    function log_image(lg::CLogger, name::AbstractString, obj::AbstractArray{<:Colorant}; step=nothing, kwargs...)

Logs the image from an RGB array.
"""
function log_image(lg::CLogger, name::AbstractString, obj::AbstractArray{<:Colorant}; step=nothing, kwargs...)
    mktempdir(;prefix="jlcom_") do dirname
        fname = joinpath(dirname, name, "image.png")
        FileIO.save(fname, obj)
        log_image(lg, name, fname, step=step, kwargs...)
    end
end

process(lg::CLogger, name::AbstractString, obj::AbstractArray{<:Colorant}, step::Int) = log_image(lg, name, obj; step=step, copy_to_tmp=false)