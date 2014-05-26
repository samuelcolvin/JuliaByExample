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
	code=join(filter(x-> !beginswith(x, OUTPUT_COMMENTS), split(code, ['\n'])), "\n")
	return !endswith(code, "\n") ? string(code, "\n") : code
end

function getoutput(code::String)
	# evaluate code expression-by-expression and collect STDOUT
	# together with where to put it back.
	# variables from eval contaminate the function
	# so we use the hack __var to avoid variable mixup
	__pos = 1
	const STDOUT_OLD = STDOUT
	__output = (Int, String)[]
	begin
		while true
			statement, newpos = parse(code, __pos, raise=false)
			statement.head == :error ? break: (__pos = newpos)
			__io, _ = redirect_stdout()
			print("x")
			eval(statement)
			redirect_stdout(STDOUT_OLD)
			result = readavailable(__io)
			close(__io)
			if length(result) > 1
				push!(__output, (__pos, result[2:end]))
			end
		end
	end
	return __output
end

function insert_output(code::String, output::Array{(Int64,String), 1})
	# insert the output from above back into the code after the 
	# expression which created it
	function tocomment(text::String)
		stripped = strip(text, [' ', '\n', '\t'])
		return length(stripped) == 0 ?
			"\n" :
			string(OUTPUT_COMMENTS, replace(stripped, "\n", "\n$OUTPUT_COMMENTS"), "\n")
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

function convertfile(__fname::String)
	if !(endswith(__fname, ".jl") || endswith(__fname, ".JL"))
		println("## ERROR: the file \"$__fname\" does not appear to be a julia file (eg. doesn't end with .jl)")
		return
	end
	const __code = removeold(open(readall, __fname, "r"))
	output = getoutput(__code)
	newcode = insert_output(__code, output)
	open(__fname, "w") do f
		write(f, newcode)
	end
	println("--------------\nOutput comments added to \"$__fname\"\n--------------")
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