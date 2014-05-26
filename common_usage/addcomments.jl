using ArgParse

function getoutput(code::String)
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
	function tocomment(text::String)
		stripped = strip(text, [' ', '\n', '\t'])
		return length(stripped) == 0 ?
			"\n" :
			string("#> ", replace(stripped, "\n", "\n#> "), "\n")
	end
	reverse!(output)
	for (pos, text) in output
		if pos >= length(code)
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
	if !endswith(__fname, ".jl")
		error("file name \"$__fname\" does not appear to be a julia file!")
	end
	const __code = open(readall, __fname, "r")
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