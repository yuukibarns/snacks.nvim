(inline_formula
  (#set! image.ext "math.tex")
  (#set! image.math "inline"))
  @image.content @image

(displayed_equation
  (#set! image.ext "math.tex")
  (#set! image.math "display"))
  @image.content @image

((math_environment
  (#set! image.ext "math.tex")
  (#set! image.math "environment"))
  @image.content @image
  (#not-has-ancestor? @image "displayed_equation"))

(graphics_include
  (_ (path) @image.src)
) @image
