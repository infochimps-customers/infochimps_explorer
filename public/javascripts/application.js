// define jquery expanable method
(function($) {
	$.fn.expandable = function(opts) {
	  opts = opts||{};
	  handle=opts.handle||'h1,h2,h3,h4,h5,h6'
	  
	  $(this).each(function(i, el){
      $(el).children(handle).addClass('expandable-handle').click(function(e){
        e.preventDefault();
        e.stopImmediatePropagation();
        $(this).parent().toggleClass('collapsed');
      });
      $(el).addClass('collapsed').addClass('expandable');
	  });
  }
})(jQuery);


function initialize_icss_editor(){
  // initialize expandable objects, textile editor fields, and section tabs
  $('.collapsed').expandable();
  $('textarea.textile:not(.reduced)').markItUp(textileMarkUpSet);
  $('textarea.textile.reduced').markItUp(reducedTextileMarkUpSet);
  $("ul.tabs").tabs("section.pane");
  initialize_sortables();
  
  // update on type change to add additional fields required for array, map, and fixed types
  $('select[name$="type\\]"], select[name$="items\\]"], select[name$="values\\]"], select[name*=response]').change(function(){
    // remove current additional fields
    if($(this).attr('name').match(/\[(type|response|items|values)\]\[type\]$/)) {
      $(this).attr('name', $(this).attr('name').replace(/\[type\]$/,''));
      $(this).next('div').remove();
    }
    // add text/fields needed for selected type
    if($(this).val() == "array"){
      $(this).after($('<div></div>').append('<span> of </span><br />').append($(this).clone(true).attr('name', $(this).attr('name')+'[items]').children('option').removeAttr('selected').end()));
      $(this).attr('name', $(this).attr('name')+'[type]');
    } else if($(this).val() == "map"){
      $(this).after($('<div></div>').append('<span> with </span><br />').append($(this).clone(true).attr('name', $(this).attr('name')+'[values]').children('option').removeAttr('selected').end()));
      $(this).attr('name', $(this).attr('name')+'[type]');
    } else if($(this).val() == "fixed"){
      $(this).after($('<div></div>').append('<span> with size </span><br />').append($('<input type="text" />').attr('name', $(this).attr('name')+'[size]')));
      $(this).attr('name', $(this).attr('name')+'[type]');
    }
  });
  
  // editting type, message, or field name field updates section title
  $('input[type=text][name$="name\\]"]', $('section.type, section.message')).keyup(function(e){
    $(this).closest('section').children('h1,h2,h3,h4,h5,h6').first().html($(this).val());
  });
  
  // new button creates form section
  $('div.new').live('click', function(e){
    destroy_sortables();
    template = $(this).closest('section').find('section:first section:first').clone(true);
    
    // collect data needed to update labels
    section_index = $(this).closest('section').siblings('section').andSelf().length+'';
    label_for_match = template.find('label:first').attr('for').match(/^(.+)([0-9]+)/);
  
    // remove all subsections except the first
    template.find('section section section:first').siblings('section').remove();
    
    // reset all headers and fields to default initial values
    template.find('h3,h5').html('Untitled');
    template.find('input[type=hidden]:not([name$="type\\]"])').not('input[name$="type\\]"]').remove();
    template.find('input[type=text], textarea').val('');
    template.find('input[type=text][name$="name\\]"]').val('Untitled');
    template.find('select').each(function(i, el){ $(el).children('option').removeAttr('selected').first().attr('selected', 'selected'); });
    
    //update labels to correspond to new fields
    template.find('label').each(function(i, label){
      field_id = $(label).attr('for').replace(label_for_match[0], label_for_match[1]+section_index);
      $(label).attr('for', field_id);
      $('input, textarea, select', label).attr('id', field_id);
    });
    
    //reinitialize textile editor fields
    $('textarea', template).markItUpRemove();
    $('textarea.textile:not(.reduced)', template).markItUp(textileMarkUpSet);
    $('textarea.textile.reduced', template).markItUp(reducedTextileMarkUpSet);
    
    //expand section before adding
    template.removeClass('collapsed');
    //append new section
    $(this).closest('section').children('section:first').append(template);
    //scroll window to top of new section
    $(window).scrollTop(template.offset().top);
    //select first field in new section
    template.find('input[type=text]:first').focus().select();
    initialize_sortables();
  });
    
  function destroy_sortables(){
    $('section#types, section#messages, section.fields').each(function(i, list){ $(list).sortable('destroy'); });
  }

  function initialize_sortables(){
    destroy_sortables();

    // fields, messages, and types are reorderable
    sortable_options = { items: 'section.type', handle: '.expandable-handle', containment: 'parent', distance: 20, axis: 'y', helper: 'original', tolerance: 'pointer', forcePlaceholderSize: true };
    $('section#types').sortable(sortable_options);
    sortable_options.items = 'section.message';
    $('section#messages').sortable(sortable_options);
    sortable_options.items = 'section.field';
    $('section.fields').sortable(sortable_options);
  }
}