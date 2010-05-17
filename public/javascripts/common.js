
// input field clearing/resetting helper

	jQuery(document).ready(function() {
	
	    jQuery('.clear-field').each(function() {
	
	    	// cache original text
	    	this.original_value = this.value;
	    	
	    	// clearing event
	    	jQuery(this).bind("focus", function(e) {
	    		if (e.target.value == e.target.original_value) {
	    			e.target.value = "";
	    		}
	    	});
	    	
	    	// resetting event
	    	jQuery(this).bind("blur", function(e) {
	    		if (e.target.value == "") {
	    			e.target.value = e.target.original_value;
	    		}
	    	});
	    
	    });
	 
	 });
	 
	// preload cell hover images
	
	jQuery(document).ready(function() {
	
	    jQuery('<img src="images/icons/plus_icon.gif" alt="" />');
		jQuery('<img src="images/icons/x_icon.gif" alt="" />');
		   	 
	 });	 