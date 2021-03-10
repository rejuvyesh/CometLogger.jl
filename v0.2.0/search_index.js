var documenterSearchIndex = {"docs":
[{"location":"#CometLogger.jl","page":"Home","title":"CometLogger.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Log data to comet.ml from Julia","category":"page"},{"location":"","page":"Home","title":"Home","text":"CometLogger is a Julia package that allows you to log data to Comet through the standard Julia Logging system.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"To install this Julia package run the following command in the julia REPL:","category":"page"},{"location":"","page":"Home","title":"Home","text":"] add CometLogger","category":"page"},{"location":"#Basic-Usage","page":"Home","title":"Basic Usage","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = CometLogger","category":"page"},{"location":"","page":"Home","title":"Home","text":"The main type in the package is CLogger. It behaves like any other standard logger in Julia like ConsoleLogger. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nMake sure you obtain your API key from Comet and store it at $HOME/.comet.config as:[comet]\napi_key = YOUR_API_KEY","category":"page"},{"location":"","page":"Home","title":"Home","text":"You can pass in the same arguments to CLogger as specied for comet_ml.Experiment in their  Python API. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"Once you have created a CLogger, you can use it as you would use any other logger in Julia:","category":"page"},{"location":"","page":"Home","title":"Home","text":"You can set it to be your global logger with the function global_logger\nYou can set it to be the current logger in a scope with the function with_logger\nYou can combine it with other Loggers using LoggingExtras.jl, so that messages are logged to TensorBoard and to other backends at the same time.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Every CLogger has an internal counter to store the current step, which is initially set to 1. All the data logged with the same @log call will be logged with the same step, and then it will increment the internal counter by 1.","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you want to increase the counter by a different amount, or prevent it from increasing, you can log the additional message log_step_increment=N. The default behaviour corresponds to N=1. If you set N=0 the internal counter will not be modified.","category":"page"},{"location":"","page":"Home","title":"Home","text":"See the example below:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using TensorBoardLogger, Logging, Random\n\nlg=CLogger(min_level=Logging.Info)\n\nstruct sample_struct first_field; other_field; end\n\nwith_logger(lg) do\n    for i=1:100\n        data_struct = sample_struct(i^2, i^1.5-0.3*i)\n\n\n        @info \"test\" i=i j=i^2 dd=rand(10).+0.1*i \n        @info \"test_2\" i=i j=2^i log_step_increment=0\n        @info \"\" my_weird_struct=data_struct   log_step_increment=0\n        @debug \"debug_msg\" this_wont_show_up=i\n    end\nend","category":"page"},{"location":"#Third-party-packages","page":"Home","title":"Third-party packages","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"We also support logging custom types from a the following third-party libraries:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Plots.jl: the Plots.Plot type will be rendered to PNG at the resolution specified by the object and logged as an image","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nMake sure to load Plots and ImageIO if you wish to log Plots.jl plots.","category":"page"},{"location":"#Explicit-Interface","page":"Home","title":"Explicit Interface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In addition to the standard logging interface, it is possible to log data to Comet using the functions documented below. All the functions accept take as first argument a CLogger object and as the second argument a String as the tag under which the data will be logged.","category":"page"},{"location":"#Scalar","page":"Home","title":"Scalar","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"log_metric","category":"page"},{"location":"#CometLogger.log_metric","page":"Home","title":"CometLogger.log_metric","text":"function log_metric(lg::CLogger, name::AbstractString, value::Real; step::Int=nothing, epoch::Int=nothing)\n\nLogs general scalar metrics.        \n\n\n\n\n\n","category":"function"},{"location":"#Text","page":"Home","title":"Text","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"log_text","category":"page"},{"location":"#CometLogger.log_text","page":"Home","title":"CometLogger.log_text","text":"function log_text(lg::CLogger, name::AbstractString, value::AbstractString; step::Int=nothing, metadata::Dict{String,Any}=nothing)\n\nLogs the text. \n\n\n\n\n\n","category":"function"},{"location":"#Images","page":"Home","title":"Images","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"log_image","category":"page"},{"location":"#CometLogger.log_image","page":"Home","title":"CometLogger.log_image","text":"function log_image(lg::CLogger, name::AbstractString, obj::AbstractString; step=nothing, kwargs...)\n\nLogs the image from a filepath.\n\n\n\n\n\n","category":"function"},{"location":"#Index","page":"Home","title":"Index","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [CometLogger]","category":"page"},{"location":"#CometLogger.log_curve-Tuple{CLogger,AbstractString,AbstractArray{T,1} where T,AbstractArray{T,1} where T}","page":"Home","title":"CometLogger.log_curve","text":"\n\n\n\n","category":"method"},{"location":"#CometLogger.log_image-Tuple{CLogger,AbstractString,AbstractString}","page":"Home","title":"CometLogger.log_image","text":"function log_image(lg::CLogger, name::AbstractString, obj::AbstractString; step=nothing, kwargs...)\n\nLogs the image from a filepath.\n\n\n\n\n\n","category":"method"},{"location":"#CometLogger.log_metric-Tuple{CLogger,AbstractString,Real}","page":"Home","title":"CometLogger.log_metric","text":"function log_metric(lg::CLogger, name::AbstractString, value::Real; step::Int=nothing, epoch::Int=nothing)\n\nLogs general scalar metrics.        \n\n\n\n\n\n","category":"method"},{"location":"#CometLogger.log_text-Tuple{CLogger,AbstractString,Any}","page":"Home","title":"CometLogger.log_text","text":"function log_text(lg::CLogger, name::AbstractString, value::AbstractString; step::Int=nothing, metadata::Dict{String,Any}=nothing)\n\nLogs the text. \n\n\n\n\n\n","category":"method"},{"location":"#CometLogger.logable_propertynames-Tuple{Any}","page":"Home","title":"CometLogger.logable_propertynames","text":"logable_propertynames(val::Any)\n\nReturns a tuple with the name of the fields of the structure val that should be logged to Comet.ml. This function should be overridden when you want Comet.ml to ignore some fields in a structure when logging it. The default behaviour is to return the  same result as propertynames. See also: Base.propertynames\n\n\n\n\n\n","category":"method"}]
}
