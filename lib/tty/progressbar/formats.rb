# frozen_string_literal: true

module TTY
  class ProgressBar
    module Formats
      FORMATS = {
        arrow: { # ▸▸▸▸▸▹▹▹▹▹
          complete: "▸",
          incomplete: "▹",
          unknown: "▸"
        },
        block: { # ██████████
          complete: "█",
          incomplete: " ",
          unknown: "◀▶"
        },
        box: { # ■■■■■□□□□□
          complete: "■",
          incomplete: "□",
          unknown: "■"
        },
        burger: { # ≡≡≡≡≡≡≡≡≡≡
          complete: "≡",
          incomplete: " ",
          unknown: "≡"
        },
        circle: { # ●●●●●○○○○○
          complete: "●",
          incomplete: "○",
          unknown: "●"
        },
        classic: { # ==========
          complete: "=",
          incomplete: " ",
          unknown: "<=>"
        },
        dot: { # ･･････････
          complete: "･",
          incomplete: " ",
          unknown: "･"
        },
        track: { # ▬▬▬▬▬═════
          complete: "▬",
          incomplete: "═",
          unknown: "▬"
        },
        wave: { # ~~~~~_____
          complete: "~",
          incomplete: "_",
          unknown: "~"
        }
      }.freeze
    end # Formats
  end # ProgressBar
end # TTY
