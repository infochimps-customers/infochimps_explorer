textilePreview = {
  preview: function(editor){
    if($(editor.textarea).closest('.markItUpContainer').find('.markItUpHeader').find('.write').hasClass('selected')){
      $(editor.textarea).hide().after($('<div class="preview">Loading...</div>'));
      $(editor.textarea).next('.preview').load('/textile?textile='+escape($(editor.textarea).val()));
      $(editor.textarea).closest('.markItUpContainer').find('.markItUpHeader').find('li').filter('.preview').addClass('selected').end().filter('.write').removeClass('selected').end().not('.write, .preview').hide();
      
    }
  },
  write: function(editor){
    if($(editor.textarea).closest('.markItUpContainer').find('.markItUpHeader').find('.preview').hasClass('selected')){
      $(editor.textarea).show().next('.preview').remove();
      $(editor.textarea).closest('.markItUpContainer').find('.markItUpHeader').find('li').show().filter('.write').addClass('selected').end().filter('.preview').removeClass('selected');
    }
  }
}

// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags example
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
textileMarkUpSet = {
	onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
	resizeHandle: false,
	markupSet: [
		{name:'Heading 1 (h1. )', openWith:'h1. ', className: 'h1'},
		{name:'Heading 2 (h2. )', openWith:'h2. ', className: 'h2'},
		{name:'Heading 3 (h3. )', openWith:'h3. ', className: 'h3'},
		{name:'Heading 4 (h4. )', openWith:'h4. ', className: 'h4'},
		{separator:'---------------' },
		{name:'Emphasis (_text_)', openWith:'[_', closeWith:'_]', className: 'em'},
		{name:'Strong (*text*)', openWith:'[*', closeWith:'*]', className: 'strong'},
		{name:'Strike (-text-)', openWith:'[-', closeWith:'-]', className: 'strike'},
		{name:'Code (@text@)', openWith:'[@', closeWith:'@]', className: 'code'},
		{separator:'---------------' },
		{name:'Bulleted List (* text)', openWith:'(!(* |!|*)!)', className: 'ul'},
		{name:'Numbered List (# text)', openWith:'(!(# |!|#)!)', className: 'ol'}, 
		{name:'Table (|text|)', openWith:'|', closeWith:'|', className: 'table'},
		{separator:'---------------' },
		{name:'Image (!url!)', openWith:'[!http://', closeWith:'!]', className: 'img'}, 
		{name:'Link ("text":url)', openWith:'["', closeWith:'":http://]', className: 'link'},
		{name:'Horizantal rule', replaceWith:'<hr />', className: 'hr'},
		{separator:'---------------' },
		{name:'Preview', openWith:textilePreview.preview, closeWith:'', className:'preview'},
		{name:'Write', openWith:textilePreview.write, closeWith:'', className:'write selected'}
	]
}

reducedTextileMarkUpSet = {
	onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
	resizeHandle: false,
	markupSet: [
		{name:'Emphasis (*text*)', openWith:'[*', closeWith:'*]', className: 'em'},
		{name:'Strong (_text_)', openWith:'[_', closeWith:'_]', className: 'strong'},
		{name:'Strike (-text-)', openWith:'[-', closeWith:'-]', className: 'strike'},
		{name:'Code (@text@)', openWith:'[@', closeWith:'@]', className: 'code'},
		{separator:'---------------' },
		{name:'Link ("text":url)', openWith:'["', closeWith:'":http://]', className: 'link'},
		{separator:'---------------' },
		{name:'Preview', openWith:textilePreview.preview, closeWith:'', className:'preview'},
		{name:'Write', openWith:textilePreview.write, closeWith:'', className:'write selected'}
	]
}