class NoSexism

  constructor: ->
    @expressions = [
      /(bela)(s)*([ -_])(da)([ -_])(torcida)/gi
      /(bela)([ -_])(d)([a|o])/gi
      /(ensaio)([ -_])(sensual)/gi
      /(namoradinha)(s)*([ -_])(do)([ -_])(esporte)/gi
      /([qual|quem])(.)+(a)(.)+(do)([ -_])(esporte)/gi
      /(qual|quem)(.)+(namorada|mulher|esposa|amante|dama)(.)+(bela|bonita|gostosa)/gi
    ]

  run: =>
    for link in document.getElementsByTagName('a')
      @cleanUpLink(link) if @isSexist(link)
    for img in document.getElementsByTagName('img')
      @cleanUpImage(img) if @isSexist(img)

  isSexist: (node) =>
    if node isnt 'undefined'
      for attr in ['href', 'title', 'src', 'alt']
        value = node.getAttribute attr
        for re in @expressions
          return true if re.test value
    false

  cleanUpLink: (link) =>
    @addClass(link)
    for img in link.getElementsByTagName 'img'
      @cleanUpImage img

  cleanUpImage: (img) =>
    width = img.clientWidth
    height = img.clientHeight
    img.setAttribute 'src', "http://dummyimage.com/#{width}x#{height}/ff007f/ffffff&text=Conteúdo+Sexista"

  addClass: (node) =>
    toAdd = 'conteudo-sexista'
    classOrNull = node.getAttribute 'class'
    className = if classOrNull then classOrNull else ''
    classes = if className then className.split(/\s+/) else []
    if toAdd not in classes
      node.setAttribute 'class', "#{className} #{toAdd}".trim()

if typeof window isnt 'undefined'
  noSexism = new NoSexism()
  window.addEventListener 'DOMContentLoaded', noSexism.run
else
  module.exports = NoSexism
