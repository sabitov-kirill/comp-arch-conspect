#let imagebox(imageName, label: none, width: none, height: none, alignMode: center) = {
  let size = (:)
  if width != none { size.insert("width", width) }
  if height != none { size.insert("height", height) }

  set text(size: 0.8em)
  align(alignMode)[
    #stack[
      #image("images/" + imageName, ..size)\
      #emph(label) 
    ]
  ]
}