mySettings = {
  onShiftEnter:		{keepDefault:false, replaceWith:'\n\n'},
  markupSet: [
	  {name:'Heading 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Заголовок 1го уровня' },
	  {name:'Heading 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Заголовок 2го уровня' },
	  {name:'Heading 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Заголовок 3го уровня' },
	  {name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Заголовок 4го уровня' },
	  {name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Заголовок 5го уровня' },
	  {name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Заголовок 6го уровня' },
	  {name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
	  {separator:'---------------' },
	  {name:'Bold', key:'B', closeWith:'*', openWith:'*'},
	  {name:'Italic', key:'I', closeWith:'_', openWith:'_'},
	  {name:'Stroke through', key:'S', closeWith:'-', openWith:'-'},
	  {separator:'---------------' },
	  {name:'Bulleted list', openWith:'* Элемент 1 \n* Элемент 2 \n* Элемент 3 \n* и т.д \n'},
	  {name:'Numeric list', openWith:'# Элемент 1 \n# Элемент 2 \n# Элемент 3 \n# и т.д \n'},
	  {separator:'---------------' },
	  {name:'Picture', replaceWith:'![![URL адрес картинки:!:http://]!]([![Пояснение к картинке]!])!'}, 
	  {name:'Link', openWith:'"', closeWith:'[![Текст ссылки]!]":[![Адрес в Интернет:!:http://]!]' },
	  {separator:'---------------' },
	  {name:'Quotes', openWith:'bq(!(([![Class]!]))!). '},
	  {name:'Code', openWith:"@@@LANG@@@\n", closeWith:"\n@@@", placeHolder:'Ваш программный код'}
  ]
}
