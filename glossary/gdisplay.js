function set_scroll_click(parent){
	parent.find('.item-outer').click(function(){
	  if ($(this).css('overflow-y') == 'hidden'){
	    $(this).css({'overflow-y': 'scroll'});
	  }
	  else {
	    $(this).scrollTop(0)
	    $(this).css({'overflow-y': 'hidden'});
	  }
	});
}

set_scroll_click($(document))