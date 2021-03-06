module VegaLite

using JSON, Requires, NodeJS, Rsvg # 6s
import Cairo
import IteratorInterfaceExtensions # 1s
import TableTraits # 0
using FileIO # 17s !!!
using DataValues  # 1s
import MacroTools
using URIParser
using FilePaths
using REPL, Dates
using Random
import JSONSchema

# This import can eventually be removed, it currently just makes sure
# that the iterable tables integration for DataFrames and friends
# is loaded
import IterableTables

export renderer, actionlinks
export @vl_str, @vlplot
export @vg_str
export load, save

export mk, enc

export vlplot, vldata

export config, selection, resolve, projection, facet, spec, rep
export transform, hconcat, vconcat, layer

global vlschema = JSONSchema.Schema(JSON.parsefile(joinpath(@__DIR__, "..", "deps", "lib", "vega-lite-schema.json")))

########################  settings functions  ############################

# Switch for plotting in SVGs or canvas

global RENDERER = :svg

"""
`renderer()`

show current rendering mode (svg or canvas)

`renderer(::Symbol)`

set rendering mode (svg or canvas)
"""
renderer() = RENDERER
function renderer(m::Symbol)
  global RENDERER
  m in [:svg, :canvas] || error("rendering mode should be either :svg or :canvas")
  RENDERER = m
end


# Switch for showing or not the buttons under the plot

global ACTIONSLINKS = true

"""
`actionlinks()::Bool`

show if plots will have (true) or not (false) the action links displayed

`actionlinks(::Bool)`

indicate if actions links should be dislpayed under the plot
"""
actionlinks() = ACTIONSLINKS
actionlinks(b::Bool) = (global ACTIONSLINKS ; ACTIONSLINKS = b)


########################  includes  #####################################

abstract type AbstractVegaSpec end
include("vgspec.jl")
include("vlspec.jl")

# include("dsl_helper_func/dsl_helper_func.jl")
include("dsl_vlplot_macro/dsl_vlplot_macro.jl")
include("dsl_str_macro/dsl_str_macro.jl")

include("rendering/render.jl")
include("rendering/io.jl")
include("rendering/show.jl")
include("rendering/fileio.jl")

include("mime_wrapper.jl")


# function __init__()

#     global mk, enc

#     ### encoding family : enc.x.quantitative, ...

#     function mkfunc1(dim, typ)
#         if typ == :value
#             function (val, args...; kwargs...)
#                 pars = todicttree(args...; value=val, kwargs...)
#                 mkSpec(:vlencoding; [(dim, pars);]...)
#             end
#         else
#             function (field, args...; kwargs...)
#                 pars = todicttree(args...; field=field, typ=typ, kwargs...)
#                 mkSpec(:vlencoding; [(dim, pars);]...)
#             end
#         end
#     end

#     channels = Symbol.(collect(keys(refs["EncodingWithFacet"].props)))
#     chantyps = Symbol.(collect(union(refs["BasicType"].enum, refs["GeoType"].enum)))
#     push!(chantyps, :value)

#     typnt = NamedTuples.make_tuple( chantyps )

#     encs = []
#     for ch in channels
#         push!(encs, typnt( [ mkfunc1(ch, tp) for tp in chantyps ]... ) )
#     end
#     enc = NamedTuples.make_tuple( channels )( encs... )

#     #####  mark family : mk.line(), ...

#     function mkfunc2(typ)
#         function (args...; kwargs...)
#             mkSpec(:vlmark, args...; typ=typ, kwargs...)
#         end
#     end


#     # this fails at precompilation
#     marktyps = Symbol.(collect(refs["Mark"].enum))
#     marknt = NamedTuples.make_tuple( marktyps )

#     # => switch to explicit creation
#     # marktyps = Symbol[:tick, :bar, :square, :point, :line, :rect, :area, :circle, :rule, :text, :geoshape]
#     # marknt = @NT(tick, bar, square, point, line, rect, area, circle, rule, text, geoshape)
#     #
#     mk = marknt([ mkfunc2(typ) for typ in marktyps ]...)

# end




end
