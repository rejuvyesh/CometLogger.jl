using PyCall

try
    pyimport("comet_ml")
catch e
    try
        run(`$(PyCall.pyprogramname) -m pip install setuptools comet_ml`)
    catch ee
        if !(typeof(ee) <: PyCall.PyError)
            rethrow(ee)
        end
        @warn("""
    Python dependencies not installed.
    Either
    - Rebuild `PyCall` to use Conda by running the following in Julia REPL
        - `ENV[PYTHON]=""; using Pkg; Pkg.build("PyCall"); Pkg.build("CometLogger")
    - Or install the dependencies by running `pip`
        - `pip install comet_ml`
        """
              )              
    end
end