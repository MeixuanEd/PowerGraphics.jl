using CSV
using YAML
using Colors
using DataFrames

"""
    palette_csv2yaml(palette_csv_path::AbstractString, palette_yaml_path::AbstractString)

This function makes a yaml of generator categorization based on a csv input.

# Arguments
- `palette_csv_path::AbstractString`: the csv filepath
- `palette_yaml_path::AbstractString`: the yaml save path

# Example
palette_csv2yaml("deps/NREL-palette.csv", "report_templates/color-palette.yaml")

"""
function palette_csv2yaml(
    palette_csv_path::AbstractString,
    palette_yaml_path::AbstractString,
)
    palette = DataFrame(CSV.read(palette_csv_path))

    if !("Over generation" in palette.Technology)
        push!(
            palette,
            Dict(
                Symbol("Technology") => "Over generation",
                Symbol("R:") => 12,
                Symbol("G:") => 244,
                Symbol("B:") => 252,
                Symbol("HEX") => "0CF4FC",
            ),
        )
    end

    palette_yaml = Dict()
    for row in eachrow(palette)
        RGB = "rgba($(row[Symbol("R:")]), $(row[Symbol("G:")]), $(row[Symbol("B:")]), 1)"
        #color = Colors.RGBA(row[Symbol("R:")]/255, row[Symbol("B:")]/255, row[Symbol("G:")]/255, 1)
        palette_yaml[row.Technology] = Dict("RGB" => RGB, "order" => getfield(row, :row))
    end

    YAML.write_file(palette_yaml_path, palette_yaml)
end
