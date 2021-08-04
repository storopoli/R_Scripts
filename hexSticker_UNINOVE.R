library(hexSticker)

# imgurl <- "https://github.com/storopoli/Estatistica-Bayesiana/raw/master/images/uninove.png"
# imgurl <- "https://raw.githubusercontent.com/storopoli/Estatistica-Bayesiana/master/slides/logos/uninove_white.png"
imgurl <- "https://raw.githubusercontent.com/storopoli/Estatistica-Bayesiana/master/slides/logos/uninove_black.png"

sticker(imgurl,
        package = "CIS",
        p_size = 22,
        s_x = 1, s_y = .75, s_width = .8,
        filename = here::here("images", "UNINOVE_CIS.png")
)

sticker(imgurl,
        package = "PPGA",
        p_size = 22,
        s_x = 1, s_y = .75, s_width = .8,
        filename = here::here("images", "UNINOVE_PPGA.png")
)

sticker(imgurl,
        package = "PPGI",
        p_size = 22,
        s_x = 1, s_y = .75, s_width = .8,
        filename = here::here("images", "UNINOVE_PPGI.png")
)
