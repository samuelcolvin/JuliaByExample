using JSON

#####################
# Work in progress!
#####################

# set of tools for listing packages based on their popularity (by github stars)
# and exporting all info we get hold of about the items in the package to JSON
# before generating a big "glossary" html file

type PkgInfo
	name::String
	url::String
	stars::Int
end

# using Requests
function findstars()

	function tourl(ssh::String)
		url = replace(ssh, r"^git", "https")
		replace(url, r".git$", "")
	end

	function geturls()
		pkgs = PkgInfo[]
		metadir = Pkg.dir("METADATA")
		plist = readdir(metadir)
		for p in plist
			urlfname = joinpath(metadir, p, "url")
			if isfile(urlfname)
				ssh = strip(open(readall, urlfname, "r"), ['\n', ' ', '\t'])
				url = tourl(ssh)
				push!(pkgs, PkgInfo(p, url, 0))
			end
	    end
	    return pkgs
	end

	function getstars(pkg::PkgInfo, attempt=0)
		if attempt > 10
			println("max attempts reached")
			return
		end
		m = nothing
		response = nothing
		try
			response = get(pkg.url)
			m = match(r"stargazers\">.*\n *(\d+)", response.data)
		catch
			println(pkg.url, ", error on get request!, trying again")
			return getstars(pkg, attempt + 1)
		end
		if response.headers["status_code"] == "301" && haskey(response.headers, "Location")
			newurl = response.headers["Location"]
			println("redirection to $newurl")
			pkg.url = newurl
			return getstars(pkg, attempt + 1)
		end
		if m == nothing
			println("\n url: $(pkg.url)")
			@show response
			println("no Stars found!")
			return
		end
		pkg.stars = int(m.captures[1])
		println(pkg.stars, " stars")
	end

	#> old and very naive way of getting list of packages:
	# url = "http://julia.readthedocs.org/en/latest/packages/packagelist/"
	# println("Getting package list from $url...")
	# html = get(url).data
	# pkgs = PkgInfo[]
	# offset = 1
	# i = 0
	# while true
	# 	m = match(r"<h2>[\n ]*<a +class=\"reference +external\" +href=\"(.*?)\">(.*?)</a>", html, offset)
	# 	m == nothing ? break : ()
	# 	offset = m.offset + 1
	# 	push!(pkgs, PkgInfo(m.captures[2], m.captures[1], 0))
	# end
	pkgs = geturls()
	println("looking up $(length(pkgs)) packages...")
	for (i, pkg) in enumerate(pkgs)
		print("$i looking up $(pkg.name)... ")
		getstars(pkg)
		# i > 20 ? break : ()
	end
	sort!(pkgs, by=i -> i.stars, rev=true)
	println("\nPackage Stars:")
	for pkg in pkgs
		println(rpad("$(pkg.name):", 30), pkg.stars)
	end
	pkgs
end

function listpopular()
	jsonfile = "pkgs.json"
	if isfile(jsonfile)
		pkgs = JSON.parsefile(jsonfile)
	else
		println("finding popular packages")
		pkgs = findstars()
		f=open(jsonfile, "w")
		JSON.print(f, pkgs, 2)
		close(f)
	end
end
# listpopular()

type ItemInfo
	name::String
	summary::String
	help::String
	methods::Array{String, 1}
end

function moduleinfo(m::Module, existingmethods::Set)
	# we want to ignore methods already defined in other modules
	# but still show them if they've only be been previously seen
	# in this module
	function checkexists(s::String)
		h = hash(s)
		in(h, existingmethods) ? (return false) : ()
		push!(existingmethods_new, h)
		return true
	end
	existingmethods_new = copy(existingmethods)
	info = ItemInfo[]
	for v in sort(names(m))
		s = string(v)
		if isdefined(m,v)
			i = eval(m,v)
			sumstr = summary(i)
			helpstr = ""
			sio = IOBuffer()
			help(sio, s)
			helpstr = takebuf_string(sio)
			close(sio)
			mlist = String[]
			if isa(i, Function)
				try
					mlist = map(string, methods(eval(m,v)))
					mlist = filter(checkexists, mlist)
				catch
				end
			end
			push!(info, ItemInfo(s, sumstr, helpstr, mlist))
		end
	end
	existingmethods = existingmethods_new
	return info
end

function getinfo(infofile)
	pkgs = [
		"Base", 
		"Gadfly", 
		"DataFrames", 
		"PyCall", 
		"GeneticAlgorithms", 
		"Optim", 
		"JuMP", 
		"Morsel", 
		"GLM", 
		"Winston"
	]
	for pkg in pkgs
		pkg == "Base" ? continue: ()
		if Pkg.installed(pkg) == nothing
			println("Adding packages $pkg ...")
			Pkg.add(pkg)
		end
	end
	allinfo = Any[]
	methods = Set()
	for mod in pkgs
		println("processing $mod ...")
		eval(parse("using $mod"))
		modinfo = ["name"=>string(mod), "items"=> moduleinfo(eval(parse(mod)), methods)]
		push!(allinfo, modinfo) 
	end
	f=open(infofile, "w")
	JSON.print(f, allinfo, 2)
	close(f)
end
# getinfo("allinfo.json")

using Mustache
using HttpCommon
function create_page()
	infofile = "allinfo.json"
	if !isfile(infofile)
		getinfo(infofile)
	end
	info = JSON.parsefile(infofile)
	template = open(readall, "glossary.template.html", "r")
	i = 1
	for mod in info
		mod["modname"] = pop!(mod, "name")
		for item in mod["items"]
			if length(item["methods"]) == 0
				delete!(item, "methods")
			else
				mesc = map(escapeHTML, item["methods"])
				mstr = join(mesc, "</p>\n<p>")
				item["methods"] = "<p>$mstr</p>"
			end
			item["id"] = i
			i += 1
		end
	end
	context = ["modules"=>info]
	page = render(template, context)
	open("glossary.html","w") do f
		print(f, page)
	end
	open("gmodules.js", "w") do f
		print(f, "modules = ")
		JSON.print(f, info)
	end
end
create_page()