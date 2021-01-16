# frozen_string_literal: true

module TTY
  class ProgressBar
    module Formats
      FORMATS = {
        arrow: { # ▸▸▸▸▸▹▹▹▹▹
          complete: "▸",
          incomplete: "▹",
          unknown: "◂▸"
        },
        asterisk: { # ✱✱✱✱✱✳✳✳✳✳
          complete: "✱",
          incomplete: "✳",
          unknown: "✳✱✳"
        },
        blade: { # ▰▰▰▰▰▱▱▱▱▱
          complete: "▰",
          incomplete: "▱",
          unknown: "▱▰▱"
        },
        block: { # █████░░░░░
          complete: "█",
          incomplete: "░",
          unknown: "█"
        },
        box: { # ■■■■■□□□□□
          complete: "■",
          incomplete: "□",
          unknown: "□■□"
        },
        bracket: { # ❭❭❭❭❭❭❭❭❭❭
         complete: "❭",
         incomplete: " ",
         unknown: "❬=❭"
        },
        burger: { # ≡≡≡≡≡≡≡≡≡≡
          complete: "≡",
          incomplete: " ",
          unknown: "<≡>"
        },
        button: { # ⦿⦿⦿⦿⦿⦾⦾⦾⦾⦾
          complete: "⦿",
          incomplete: "⦾",
          unknown: "⦾⦿⦾"
        },
        chevron: { # ››››››››››
          complete: "›",
          incomplete: " ",
          unknown: "‹=›"
        },
        circle: { # ●●●●●○○○○○
          complete: "●",
          incomplete: "○",
          unknown: "○●○"
        },
        classic: { # ==========
          complete: "=",
          incomplete: " ",
          unknown: "<=>"
        },
        crate: { # ▣▣▣▣▣⬚⬚⬚⬚⬚
          complete: "▣",
          incomplete: "⬚",
          unknown: "⬚▣⬚"
        },
        diamond: { # ♦♦♦♦♦♢♢♢♢♢
          complete: "♦",
          incomplete: "♢",
          unknown: "♢♦♢"
        },
        dot: { # ･･････････
          complete: "･",
          incomplete: " ",
          unknown: "･･･"
        },
        heart: { # ♥♥♥♥♥♡♡♡♡♡
          complete: "♥",
          incomplete: "♡",
          unknown: "♡♥♡"
        },
        rectangle: { # ▮▮▮▮▮▯▯▯▯▯
          complete: "▮",
          incomplete: "▯",
          unknown: "▯▮▯"
        },
        square: { # ▪▪▪▪▪▫▫▫▫▫
          complete: "▪",
          incomplete: "▫",
          unknown: "▫▪▫"
        },
        star: { # ★★★★★☆☆☆☆☆
          complete: "★",
          incomplete: "☆",
          unknown: "☆★☆"
        },
        track: { # ▬▬▬▬▬═════
          complete: "▬",
          incomplete: "═",
          unknown: "═▬═"
        },
        tread: { # ❱❱❱❱❱❱❱❱❱❱
          complete: "❱",
          incomplete: " ",
          unknown: "❰=❱"
        },
        triangle: { # ▶▶▶▶▶▷▷▷▷▷
          complete: "▶",
          incomplete: "▷",
          unknown: "◀▶"
        },
        wave: { # ~~~~~_____
          complete: "~",
          incomplete: "_",
          unknown: "<~>"
        }
      }.freeze
    end # Formats
  end # ProgressBar
end # TTY
