module CometLogger

using PyCall

const comet = PyNULL()

function __init__()
    copy!(comet, pyimport("comet_ml"))
end

using Base.CoreLogging: CoreLogging, AbstractLogger, LogLevel, Info, handle_message, shouldlog, min_enabled_level, catch_exceptions


# CometLogger
mutable struct CLogger <: AbstractLogger
    cexp::PyObject
    step_increment::Int
    global_step::Int
    min_level::LogLevel
end

function CLogger(; min_level=Info, step_increment=1, start_step=0, project_name=nothing, workspace=nothing, kwargs...)
    cexp = comet.Experiment(project_name=project_name, workspace=workspace, kwargs...)
    CLogger(cexp, step_increment, start_step, min_level)
end

increment_step!(lg::CLogger, Δ_Step) = lg.global_step += Δ_Step

add_tag!(lg::CLogger, tag::String) = lg.cexp.add_tag(tag)

function log_metric(lg::CLogger, name::AbstractString, value::Real; step=nothing, epoch=nothing)
    lg.cexp.log_metric(name, value, step=step, epoch=epoch)
end

function log_parameter(lg::CLogger, name::AbstractString, value; step=nothing)
    lg.cexp.log_parameter(name, value, step=step)
end

function log_text(lg::CLogger, name::AbstractString, value; step=noting, epoch=nothing)
    lg.cexp.log_text(name, value, step=step, epoch=epoch)
end

function log_curve(lg::CLogger, name::AbstractString, x::AbstractVector, y::AbstractVector; overwrite=false, step=nothing)
    @assert length(x) == length(y)
    lg.cexp.log_curve(name, x, y, overwrite=overwrite, step=step)
end

function log_image(lg::CLogger, name::AbstractString, obj; step=nothing)
    # TODO
end

# AbstractLogger interface
# Kind of mimicking TensorBoardLogger.jl

CoreLogging.catch_exceptions(lg::CLogger) = false

CoreLogging.min_enabled_level(lg::CLogger) = lg.min_level

# For now, log everything that is above the lg.min_level
CoreLogging.shouldlog(lg::CLogger, level, _module, group, id) = true

function preprocess(name, val::T, data) where {T}
    if isstructtype(T)
        fn = logable_propertynames(val)
        for f=fn
            prop = getfield(val, f)
            preprocess(name*"/$f", prop, data)
        end
    else
        # If we do not know how to serialize a type, then
        # it will be simply logged as text        
        push!(data, name=>val)
    end
    data
end

"""
    logable_propertynames(val::Any)

Returns a tuple with the name of the fields of the structure `val` that
should be logged to Comet.ml. This function should be overridden when
you want Comet.ml to ignore some fields in a structure when logging
it. The default behaviour is to return the  same result as `propertynames`.
See also: [`Base.propertynames`](@ref)
"""
logable_propertynames(val::Any) = propertynames(val)


## Default unpacking of key-value dictionaries
function preprocess(name, dict::AbstractDict, data)
    for (key, val) in dict
        # convert any key into a string, via interpolating it
        preprocess("$name/$key", val, data)
    end
    return data
end

#preprocess(name, val::PngImage, data) = push!(data, name=>val)

# Split complex numbers into real/complex pairs
preprocess(name, val::Complex, data) = push!(data, name*"/re"=>real(val), name*"/im"=>imag(val))

function preprocess(name, (x, y)::Tuple{AbstractVector,AbstractMatrix}, data)
    # Assuming dims x T
    for i in 1:size(y, 1)
        push!(data, name*"/$i"=>(x, y[i, :]))
    end
end

#function process(lg::CLogger, name::AbstractString, obj::PngImage, step::Int)
    # TODO
#end

process(lg::CLogger, name::AbstractString, obj::Real, step::Int) = log_metric(lg, name, obj; step=step)
process(lg::CLogger, name::AbstractString, obj::Tuple{AbstractVector,AbstractVector}, step::Int) = log_curve(lg, name, obj...; step=step)



function CoreLogging.handle_message(lg::CLogger, level, message, _module, group,
    id, file, line; kwargs...)
    
    i_step = lg.step_increment # :log_step_increment default value

    if !isempty(kwargs)
        data = Vector{Pair{String,Any}}()
        # ∀ (k-v) pairs, decompose values into objects that can be serialized
        for (key,val) in pairs(kwargs)
            # special key describing step increment
            if key == :log_step_increment
                i_step = val
                continue
            end
            preprocess(message*"/$key", val, data)
        end
    end
    iter = increment_step!(lg, i_step)
    for (name, val) in data
        process(lg, name, val, iter)
    end
end

Base.show(io::IO, tbl::CLogger) = begin
	str  = "CLogger(\"$(tbl.cexp.project_name)\", min_level=$(tbl.min_level), "*
		   "current_step=$(tbl.global_step))"
    Base.print(io, str)
end

end
