nostops = function (token) {
  if (nostops.stopWords.indexOf(token) === -1) return token
}

nostops.stopWords = new lunr.SortedSet
nostops.stopWords.length = 2
nostops.stopWords.elements = [""]

lunr.Pipeline.registerFunction(nostops, 'nostops')


var lunrcode = function (config) {
  var idx = new lunr.Index

  idx.pipeline.add(
    lunr.trimmer,
    nostops,
    lunr.stemmer
  )

  if (config) config.call(idx, idx)

  return idx
}

var index = lunrcode(function () {
	this.field('name', {boost: 50});
	this.field('help', {boost: 10});
	this.field('methods', {boost: 2});
	this.field('module');
	this.ref('id');
})
var indexed = false;

function do_index(){
	$.each(modules, function(i, mod){
	 	$.each(mod.items, function(ii, item){
	 		  index.add({
			    id: item.id,
			    name: item.name,
			    help: item.help,
			    methods: item.methods,
			    module: mod.modname
			  })
	 	})
	});
	indexed = true;
	if (query != null){
		search();
	}
	$('.spinner').fadeOut();
}

function empty(){
	$('#results').empty();
}

function search(){
	results = index.search(query);
	$('#results-summary').text(results.length + ' results found');
	empty();
	$.each(results, function(i, result){
		console.log(result.ref);
		var div = $('#item-' + result.ref);
		div.clone().appendTo('#results');
	})
	set_scroll_click($('#results'));
	$('#results-area').fadeIn();
}
var query = null;
$("#search").submit(function(event) {
	query = $('#search-query').val();
 	if (!indexed){
		$('.spinner').show();
 		setTimeout(do_index, 25);
 	}
 	else {
 		search();
 	}
	event.preventDefault();
});

$('#clear-btn').click(function(event){
	$('#search-query').val('');
	$('#results-area').fadeOut();
	empty();
	event.preventDefault();
})