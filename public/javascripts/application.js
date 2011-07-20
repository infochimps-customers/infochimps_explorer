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

$(function(){
  $('.collapsed').expandable();
  $('textarea.textile:not(.reduced)').markItUp(textileMarkUpSet);
  $('textarea.textile.reduced').markItUp(reducedTextileMarkUpSet);
  $("ul.tabs").tabs("section.pane");
  
  api_call_explorer();
  $('select[name$="type\\]"], select[name$="items\\]"], select[name$="values\\]"], select[name*=response]').change(function(){
    if($(this).val() == "array"){
      $(this).after($('<div></div>').append(' of <br />').append($(this).clone(true).attr('name', $(this).attr('name')+'[items]').children('option').removeAttr('selected').end()));
      $(this).attr('name', $(this).attr('name')+'[type]');
    } else if($(this).val() == "map"){
      $(this).after($('<div></div>').append(' with <br />').append($(this).clone(true).attr('name', $(this).attr('name')+'[values]').children('option').removeAttr('selected').end()));
      $(this).attr('name', $(this).attr('name')+'[type]');
    } else {
      if($(this).attr('name').match(/\[(type|response|items|values)\]\[type\]$/)){
        $(this).attr('name', $(this).attr('name').replace(/\[type\]$/,''));
        $(this).next('div').remove();
      }
    }
  });
  $('div.new').click(function(e){
    e.preventDefault();
    template = $(this).closest('section').children('section:first').clone(true);
    template.find('section section:first').siblings('section').remove();
    template.find('h1,h2,h3,h4,h5,h6').html('Untitled');
    template.find('input[type=hidden]:not([name$="type\\]"])').not('input[name$="type\\]"]').remove();
    template.find('input[type=text], textarea').val('');
    template.find('select').each(function(i, el){ console.log($(el)); $(el).children('option').removeAttr('selected').first().attr('selected', 'selected'); });
    
    $('textarea', template).markItUpRemove();
    $('textarea.textile:not(.reduced)', template).markItUp(textileMarkUpSet);
    $('textarea.textile.reduced', template).markItUp(reducedTextileMarkUpSet);
    
    $(this).closest('section').append(template);
  });
});