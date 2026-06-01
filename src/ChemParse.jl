module ChemParse

    # Add and multiply chemical formulae as dictionaries
    function add!(x::Dict, y::Dict)
        for k in keys(y)
            if k in keys(x)
                x[k] += y[k]
            else
                x[k] = y[k]
            end
        end
        return x
    end
    function add!(x::Dict, p::Pair)
        if p.first in keys(x)
            x[p.first] += p.second
        else
            x[p.first] = p.second
        end
        return x
    end
    function multiply!(x::Dict, n::Number)
        for k in keys(x)
            x[k] *= n
        end
        return x
    end

    # Input cleaning
    remove_whitespace(fstr::AbstractString) = replace(fstr, r"\s+"=>"")
    remove_charges(fstr::AbstractString) = replace(fstr, r"([A-Z\)\]][a-z]*)[0-9]*[\+\-]+"=>s"\1")
    function format_ree(fstr::AbstractString)
        fstr = replace(fstr, "REE,"=>"La,Ce,Pr,Nd,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu,")
        fstr = replace(fstr, ",REE"=>",La,Ce,Pr,Nd,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu")
        fstr = replace(fstr, "REE"=>"(La,Ce,Pr,Nd,Sm,Eu,Gd,Tb,Dy,Ho,Er,Tm,Yb,Lu)")
        return fstr
    end
    function format_vacancies(fstr::AbstractString)
        fstr = replace(fstr, "[box]"=>"□")
        fstr = replace(fstr, "[]"=>"□")
        fstr = replace(fstr, "◻"=>"□")
    end
    function sanitize(fstr::AbstractString)
        # Remove whitespace, if any
        if contains(fstr, ' ') || contains(fstr, '\t')
            fstr = remove_whitespace(fstr)
        end
        # Deal with vacancies
        fstr = format_vacancies(fstr)
        # Deal with "REE", if used as a group
        if contains(fstr, "REE")
            fstr = format_ree(fstr)
        end
        # Remove charges, if any
        if contains(fstr, '+') || contains(fstr, '-')
            fstr = remove_charges(fstr)
        end
        # Remove variable subscripts, if any
        if contains(fstr, 'x')
            fstr = replace(fstr, "x"=>"0")
        end
        return fstr
    end

    # Parsing
    function parse_formula(fstr::AbstractString; include_vacancies::Bool=false)
        # Require matching parentheses and brackets
        @assert count(isequal('('), fstr) == count(isequal(')'), fstr) "Unmatched parentheses in formula $fstr"
        @assert count(isequal('['), fstr) == count(isequal(']'), fstr) "Unmatched square brackets in formula $fstr"

        # Clean up inputs as much as possible
        fstr = sanitize(fstr)
        if !include_vacancies
            fstr = replace(fstr, "□"=>"◻")
        end
        
        # Parse
        return formula(fstr)
    end

    # Recursive parsing for all other conditions
    function formula(fstr::AbstractString)
        if contains(fstr, '·') || contains(fstr, '⋅')
            # Deal with any bound complexes
            m = match(r"(?<prefix>^.*)[·⋅]+(?<number>[0-9\.]*)(?<suffix>.*$)", fstr)
            number = isempty(m["number"]) ? 1.0 : parse(Float64, m["number"])

            f = multiply!(formula(m["suffix"]), number)
            isempty(m["prefix"]) || add!(f, formula(m["prefix"]))
            return  f

        elseif contains(fstr, '[') && contains(fstr, ']')
            # Separate out groups in square brackets, requiring balanced brackets for matched group
            m = match(r"(?<prefix>[^\[]*)\[(?<group>[^\]\[]*(?:\[^\]\[]*(?:\[[^\]\[]*(?:\[[^\]\[]*\][^\]\[]*)*\][^\]\[]*)*\][^\]\[]*)*)\](?<number>[0-9\.]*)(?<suffix>.*$)", fstr)
            number = isempty(m["number"]) ? 1.0 : parse(Float64, m["number"])

            f = multiply!(formula(m["group"]), number)
            isempty(m["prefix"]) || add!(f, formula(m["prefix"]))
            isempty(m["suffix"]) || add!(f, formula(m["suffix"]))
            return f

        elseif contains(fstr, '(') && contains(fstr, ')')
            # Separate out groups in parentheses, requiring balanced parentheses for matched group
            m = match(r"(?<prefix>^[^(]*)\((?<group>[^)(]*(?:\([^)(]*(?:\([^)(]*(?:\([^)(]*\)[^)(]*)*\)[^)(]*)*\)[^)(]*)*)\)(?<number>[0-9\.]*)(?<suffix>.*$)", fstr)
            number = isempty(m["number"]) ? 1.0 : parse(Float64, m["number"])
            if contains(m["group"], ',') && !contains(m["group"], '(')
                number /= (count(c->c==',', (m["group"])) + 1) 
            end
            
            f = multiply!(formula(m["group"]), number)
            isempty(m["prefix"]) || add!(f, formula(m["prefix"]))
            isempty(m["suffix"]) || add!(f, formula(m["suffix"]))
            return f
        else
            # Parse through each posible element
            f = Dict{Symbol,Float64}()
            for m in eachmatch(r"(?<element>[□A-Z][a-z]?)(?<number>[0-9\.]*)", fstr)
                number = isempty(m["number"]) ? 1.0 : parse(Float64, m["number"])
                add!(f, Symbol(m["element"]) => number)
            end
            return f
        end
    end

    export parse_formula
end # module
