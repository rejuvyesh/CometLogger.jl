# CometLogger.jl

*Log data to [comet.ml](https://www.comet.ml/site/) from Julia*

**CometLogger** is a [Julia](https://julialang.org) package that allows
you to log data to Comet through the standard Julia Logging system.

## Installation

To install this Julia package run the following command in the julia REPL:
```
] add CometLogger
```

## Basic Usage
```@meta
CurrentModule = CometLogger
```

The main type in the package is `CLogger`. It behaves like any other standard
logger in Julia like `ConsoleLogger`. 

!!! note
    Make sure you obtain your API key from
    Comet and store it at `$HOME/.comet.config` as:

    ```
    [comet]
    api_key = YOUR_API_KEY
    ```

You can pass in the same arguments to `CLogger` as specied for `comet_ml.Experiment` in their 
Python API. 

Once you have created a `CLogger`, you can use it as you would use any other
logger in Julia:
- You can set it to be your global logger with the function [`global_logger`](https://docs.julialang.org/en/v1/stdlib/Logging/index.html#Base.CoreLogging.global_logger)
- You can set it to be the current logger in a scope with the function [`with_logger`](https://docs.julialang.org/en/v1/stdlib/Logging/index.html#Base.CoreLogging.with_logger)
- You can combine it with other Loggers using [LoggingExtras.jl](https://github.com/oxinabox/LoggingExtras.jl), so that messages are logged to TensorBoard and to other backends at the same time.

Every `CLogger` has an internal counter to store the current `step`, which is initially set to `1`.
All the data logged with the same `@log` call will be logged with the same step, and then
it will increment the internal counter by 1.

If you want to increase the counter by a different amount, or prevent it from increasing, you can log the additional message
`log_step_increment=N`. The default behaviour corresponds to `N=1`. If you set `N=0` the internal counter will not be modified.

See the example below:
```julia
using TensorBoardLogger, Logging, Random

lg=CLogger(min_level=Logging.Info)

struct sample_struct first_field; other_field; end

with_logger(lg) do
    for i=1:100
        data_struct = sample_struct(i^2, i^1.5-0.3*i)


        @info "test" i=i j=i^2 dd=rand(10).+0.1*i 
        @info "test_2" i=i j=2^i log_step_increment=0
        @info "" my_weird_struct=data_struct   log_step_increment=0
        @debug "debug_msg" this_wont_show_up=i
    end
end
```


## Explicit Interface


In addition to the standard logging interface, it is possible to log
data to Comet using the functions documented below.
All the functions accept take as first argument a `CLogger` object
and as the second argument a `String` as the tag under which the
data will be logged.

## Scalar
```@docs
log_metric
```

## Text
```@docs
log_text
```

## Images
```@docs
log_image
```


# Index

```@index
```

```@autodocs
Modules = [CometLogger]
```
