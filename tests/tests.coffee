assert = require 'assert'
jsdom = require 'mocha-jsdom'
NoSexism = require '../src/app.coffee'

describe "No Sexism: isSexist", ->

  jsdom()

  testLinkTo = (url, title) ->
    noSexism = new NoSexism()
    link = document.createElement 'a'
    link.setAttribute 'href', url
    link.setAttribute 'title', title
    noSexism.isSexist link

  testImgTag = (src, alt) ->
    noSexism = new NoSexism()
    img = document.createElement 'img'
    img.setAttribute 'src', src
    img.setAttribute 'alt', alt
    noSexism.isSexist img

  it "Links with target URL should be considered sexist", ->
    result = testLinkTo 'http://j.mp/belas-da-torcida/?42', 'Joanne Doe'
    assert.equal result, true

  it "Links with target title should be considered sexist ", ->
    result = testLinkTo '#', 'Belas da torcida'
    assert.equal result, true

  it "Links with target URL & title should be considered sexist ", ->
    result = testLinkTo 'http://j.mp/bela-da-torcida/', 'Bela da torcida'
    assert.equal result, true

  it "Links with no target should pass", ->
    result = testLinkTo 'http://cuducos.me/', 'Eduardo Cuducos'
    assert.equal result, false

  it "Image with target src should be considered sexist", ->
    result = testImgTag 'thumb_belas_da_torcida.png?cache=true', 'Joanne Doe'
    assert.equal result, true

  it "Image with target alt should be considered sexist ", ->
    result = testImgTag 'img.png', 'Quem tem a dama mais bonita'
    assert.equal result, true

  it "Image with target src & alt should be considered sexist ", ->
    result = testImgTag 'thumb_bela_da_torcida.png', 'Qual bela da torcida..'
    assert.equal result, true

  it "Image with no target should pass", ->
    result = testImgTag 'http://cuducos.me/assets/img/cuducos.jpg', 'Cuducos'
    assert.equal result, false

describe "No Sexism: cleanUpLink", ->

  jsdom()

  testLink = (link) ->
    noSexism = new NoSexism()
    noSexism.cleanUpLink link
    link.getAttribute 'class'

  it "Processed link without classes should have 1 class", ->
    link = document.createElement 'a'
    result = testLink link
    assert.equal 'conteudo-sexista', result

  it "Processed link with 1 classshould have 2 classes", ->
    link = document.createElement 'a'
    link.setAttribute 'class', '42'
    result = testLink link
    assert.equal '42 conteudo-sexista', result

  it "Processed link two classes, one added, should have 2 classes", ->
    link = document.createElement 'a'
    link.setAttribute 'class', '42 conteudo-sexista'
    result = testLink link
    assert.equal '42 conteudo-sexista', result
