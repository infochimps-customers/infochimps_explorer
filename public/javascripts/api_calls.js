function api_call_explorer() {
  api_call_changing_fields_updates_query_string();
  api_call_submit_via_jsonp();
  api_call_update_response_documentation_on_select();
}

function api_call_changing_fields_updates_query_string() {
  $('.request-url').bind('keyup change', function(){
    query = api_call_url_to_query_object($(this).val());
    $('input[type!=submit]').each(function(){
      $(this).val(query[$(this).attr('name')]);
    });
  });
  $('.api-request input[type!=submit]').each(function(input) {
    $(this).unbind();
    $(this).bind('keyup change', function(){
      context = $(this).closest('form');
      query = api_call_url_to_query_object($('.request-url', context).val());
      if($(this).val()){
        query[$(this).attr('name')] = $(this).val();
      } else {
        delete query[$(this).attr('name')];
      }
      $('.request-url', context).val(context.attr('action')+'?'+$.param(query));
    });
    $(this).change();
  });
}

function api_call_url_to_query_object(url){
  url = url.split('?');
  query = {};
  if(url[1]){
    $.each(url[1].split('&'), function(){
      field = this.split('=');
      query[field[0]] = field[1];
    });
  }
  return query;
}

function api_call_update_response_documentation_on_select() {
  $('.api-call .api-request form select').change(function() {
    var field_index = $(this).attr('data-field-index')
    var type_index  = $(this).attr('selectedIndex');
    var selected_field = $(this).val();
    var type_names = [];
    for (var type_name in API_CALL['fields'][field_index]['type'][type_index]) {
      type_names.push(type_name);
    }
    var doc = API_CALL["fields"][field_index]["type"][type_index][type_names[0]]['doc'];

    $(this).closest('dl').find('dd.doc').html(doc);
    return false;
  });
}


function api_call_submit_via_jsonp() {  
  $('.api-request form').submit(function() {
    var api_call  = $(this).closest('.api-call');
    var request   = api_call.find('.api-request');
    var response  = api_call.find('.response');
    var url       = $('.request-url', this).val();
    var base_url  = url.split('?')[0];
    var qs        = url.split('?')[1];
    var url       = base_url + "?force_success=true&" + qs; 
    var target    = $(this);

    response.show(100);  
    $.jsonp({
      beforeSend: function() {
      	response.removeClass('success').removeClass('error');
      	response.html("<p>Making request to " + base_url + '?' + qs + "</p>");
      },
      url: url,
      callback: "george_api_explorer",
      callbackParameter: "callback",
      dataFilter: function(data) { return JSON.stringify(data, null, 2) },
      success: function(data, status) {
      	response.html('<pre>' + data + '</pre>');
      	api_call_render_map($.parseJSON(data), target);
      },
      error: function(options, status) {
      	response.html('<p>ERROR: Unable to communicate with Infochimps API.</p>')
      	response.removeClass('success').addClass('error');
      }
    })
    return false;
  });
}

function api_call_render_map(data, target) {
	// we can get rid of the map_id bits and hardcode a container id. It was set up this way
	// to render multiple maps (one on overview tab and one on explorer tab). But I had trouble
	// rendering it on the explorer tab when overview is also rendered. Removing the explorer
	// rendering in the short-term.
	// console.info()
	// $('form[data-map-id]='+map_id).live(function() {
	// 	var container = $(this)
	// })
	var container = target.find('.response');
	
	if (container.attr('data-show-visualization') != 'true') { return false; }
	
	var map = "map_"+target.closest('api-call').attr('id');

	var title = "<h3 class='sample_visual_title' style='margin-top:25px;'>Sample Visualization</h3>";
	var map_container = "<div id='"+ map +"' style='width:650px;height: 400px;margin:0px auto 25px;'></div>";
	container.prepend(title + map_container)	
	
	var map = new L.Map(map, {dragging: false, touchZoom: false, scrollWheelZoom: false});
	var cloudmadeUrl = 'http://{s}.tile.cloudmade.com/7051e1334e11401f8a86ab9a8014778d/997/256/{z}/{x}/{y}.png',
	    cloudmade = new L.TileLayer(cloudmadeUrl, {maxZoom: 18});
	
	var sample_lng = target.find('input[name=lng]').val();
	var sample_lat = target.find('input[name=lat]').val();
	var sample_zmm = target.find('input[name=zoom]').val();
	
	var centered = new L.LatLng(parseFloat(sample_lat), parseFloat(sample_lng));
	var zoom_equalize = 2;
	map.setView(centered, parseInt(sample_zmm * zoom_equalize)).addLayer(cloudmade);
			
	$.each(data.features, function(i, point){
		var markerLocation = new L.LatLng(point.geometry.coordinates[1], point.geometry.coordinates[0]);
		var marker = new L.Marker(markerLocation);
		map.addLayer(marker);
		var txt = "<h2 class='map' style='margin-bottom:0;'>" + point.properties.name + "</h2>";
		txt += "<p style='margin-top:3px;'>"+ point.properties.address + " " + point.properties.city + ", "+ point.properties.state + " " + point.properties.postal_code +"</p>";
		marker.bindPopup(txt);
	});
}