screenWidth, screenHeight = guiGetScreenSize()

XTREAM_ORANGE = {255,100,0}
XTREAM_ORANGE_TOCOLOR = tocolor(unpack(XTREAM_ORANGE))

DEBUG = false

function load_after_login_constants()
    TEAM_RANKS = {
        [5] = { loc"ADMINRANK_5_1" },
        [4] = { loc"ADMINRANK_4_1",
                loc"ADMINRANK_4_2",
                loc"ADMINRANK_4_3" },
        [3] = { loc"ADMINRANK_3_1" },
        [2] = { loc"ADMINRANK_2_1" },
        [1] = { loc"ADMINRANK_1_1" },
        [0] = { loc"DEFAULTRANK" }
    }   
end

