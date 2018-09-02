# process a julia file and add comments with the output of the file (STDOUT)
# after the expression the generated that output
using ArgParse
OUTPUT_COMMENTS = "#> "

function removeold(code::String)
	# get rid of old output comments
	# we have to be particularly careful to correct the 
	# end of the file so new output comments dont go on the same
	# line as the last command
	# endsnewline = endswith(code, "\n")
	code=join(filter(x-> !startswith(x, OUTPUT_COMMENTS), split(code, ['\n'])), "\n")
	return !endswith(code, "\n") ? string(code, "\n") : code
end

function getoutput(code::String)
	# evaluate code expression-by-expression and collect STDOUT
	# together with where to put it back.
	# variables from eval contaminate the function
	# so we use the hack __var to avoid variable mixup
	pos = 1
	STDOUT_OLD = stdout
	output = Tuple{Int64,String}[]
	ns = Module()
	begin
		while true
			statement, newpos = Meta.parse(code, pos, raise=false)
			# (statement.head == :error) ? break : (pos = newpos)
			(statement == nothing) ? break : (pos = newpos)
			stdout, stdin = redirect_stdout()
			Core.eval(ns, statement)
			redirect_stdout(STDOUT_OLD)
			close(stdin)
			result = read(stdout, String)
			close(stdout)
			if length(result) > 0
				push!(output, (pos, result))
			end
		end
	end
	return output
end

function insert_output(code::String, output::Array{Tuple{Int64,String},1})
	# insert the output from above back into the code after the 
	# expression which created it
	function tocomment(text::String)
		stripped = strip(text, [' ', '\n', '\t'])
		return length(stripped) == 0 ?
			"\n" :
			string(OUTPUT_COMMENTS, replace(stripped, "\n" => "\n$OUTPUT_COMMENTS"), "\n")
	end
	reverse!(output)
	for (pos, text) in output
		if pos > length(code)
			start = code
			extra = ""
		else
			start = code[1:(pos - 1)]
			extra = code[(pos):end]
		end
		comment = tocomment(text)
		code = string(start, comment, extra)
	end
	return code
end

function convertfile(fname::String)
	if !(endswith(fname, ".jl") || endswith(fname, ".JL"))
		println("## ERROR: the file \"$fname\" does not appear to be a julia file (i.e., it doesn't end with .jl)")
		return
	end
	code = removeold(open(f->read(f, String), fname, "r"))
	output = getoutput(code)
	newcode = insert_output(code, output)
	open(fname, "w") do f
		write(f, newcode)
	end
	println("--------------\nOutput comments added to \"$fname\"\n--------------")
end

function parseargs()
	if length(ARGS) == 0
		println("## ERROR: File name required as command line argument.")
		return
	end
	for fname in ARGS
		convertfile(fname)
	end
end

parseargs()
