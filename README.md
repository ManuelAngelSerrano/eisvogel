Para instalar eisvogel hay que copiar 2 archivos, como dice en:

[https://github.com/Wandmalfarbe/pandoc-latex-template](https://github.com/Wandmalfarbe/pandoc-latex-template)

Más info en: [https://lornajane.net/posts/2023/generating-a-nice-looking-pdf-with-pandoc](https://lornajane.net/posts/2023/generating-a-nice-looking-pdf-with-pandoc)

Luego hay que ejecutar el pandoc con parámetros como se muestra a continuación:

```bash
pandoc "$1" \
    --template eisvogel \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -o "$2"
```

Se puede añadir a un archivo bash (md2pdf.sh) poniendo en la primera línea el intérprete:


```bash
#!/bin/bash

pandoc "$1" \
    --template eisvogel \
    -V linkcolor:blue \
    -V geometry:a4paper \
    -o "$2"
```

O hacer un alias con 
```bash
alias md2pdf='(){pandoc "$1" --template eisvogel -V linkcolor:blue -V geometry:a4paper -o "$2"}
```

> **# Nota:** Pero no veo claro lo del alias.

Una opción mejor de alias sería:
```bash
alias md2pdf='pandoc --template eisvogel -V linkcolor:blue -V geometry:a4paper --listings' 
```

Y se llama con:
```bash
md2pdf input.md -o output.pdf
```


Para que funcionen los emojis, es conveniente instalar tectonic latex [https://tectonic-typesetting.github.io/en-US/](https://tectonic-typesetting.github.io/en-US/)(**No es necesario instalar tectonic**)

Y actualizar MacTex al 2025 [https://tug.org/mactex/mactex-download.html](https://tug.org/mactex/mactex-download.html)

Hay que instalar twemojis y otras fuentes:
```bash
tlmgr install twemojis noto-emoji emo fontspec luacode
```

Hay que instalar Noto Color Emoji Font:
[https://fonts.google.com/noto/specimen/Noto+Color+Emoji](https://fonts.google.com/noto/specimen/Noto+Color+Emoji)

Probando con WeasyPrint: [https://weasyprint.org/](https://weasyprint.org/)

```
brew install weasyprint
```

Tras muchas pruebas podemos hacer 3 cosas:
1. No usar emojis y llamar con --template eisvogel
2. Usar weasyprint pero entonces queda un poco más feo. Se llama con:
```bash
 pandoc input.md \
	 -o output.pdf \
	 -f gfm \
	 --pdf-engine=weasyprint \
	 -V geometry:margin=1in
	 -V mainfont=SourceCodeSans \
	 -V fontsize=10pt
```

3. Usar una cabecera (headers.tex) y lualatex... queda más o menos bien y tiene emojis, aunque no es igual que eisvogel:

**headers.tex**
```latex
% Enable emoji handling via LuaLaTeX
\usepackage{fontspec}
\usepackage{luacode} % Needed for direct Lua code execution in LaTeX

% Add the emoji fallback mechanism using LuaLaTeX
\directlua{
    luaotfload.add_fallback("emojifallback", {
        "Noto Color Emoji:mode=harf;script=DFLT;"
    })
}

% Set the main and sans-serif fonts with emoji fallback
\setmainfont{Source Sans Pro}[RawFeature={fallback=emojifallback}]
\setsansfont{Source Sans Pro}[RawFeature={fallback=emojifallback}]
\setmonofont{Source Sans Pro}[RawFeature={fallback=emojifallback}]

% Optional: Load emoji-specific package if you plan to use emoji characters via name
\usepackage{emo}

% Esto para poner lineas de separación en cabecera y pie de página
\usepackage{fancyhdr}% http://ctan.org/pkg/fancyhdr
\pagestyle{fancy}% Change page style to fancy
\fancyhf{}% Clear header/footer
%\fancyhead[C]{Header}
%\fancyfoot[C]{Footer}
\fancyfoot[R]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}% Default \headrulewidth is 0.4pt
\renewcommand{\footrulewidth}{0.4pt}% Default \footrulewidth is 0pt
```

Y se llama con (-f gfm es para usar el formato de entrada de github):
```bash
pandoc input.md \
	-o output.pdf \
	-f gfm \
	--pdf-engine=lualatex \ 
	-H ~/.pandoc/templates/headers.tex \
	-V geometry:margin=1in \
	-V linkcolor:blue \
	-V geometry:a4paper \
	-V fontsize=12pt \
	--listings
```

Una versión ampliada del comando es:

```bash
#!/bin/bash

pandoc "$1" \
    --template eisvogel \
    -V linkcolor:blue \
    -V geometry:a4paper \
	--listings \
    -o "$2"
```
