

-- [[ ATM ]] --

local Shader = dxCreateShader("Files/shader.fx");
local Textur = dxCreateTexture("Files/Images/Textures/ATM.png");
dxSetShaderValue(Shader,"gTexture",Textur);
engineApplyShaderToWorldTexture(Shader,"kmb_atm_sign");

-- [[ GETRÄNKEAUTOMAT ]] --

local Shader = dxCreateShader("Files/shader.fx");
local Textur = dxCreateTexture("Files/Images/Textures/Automat.png");
dxSetShaderValue(Shader,"gTexture",Textur);
engineApplyShaderToWorldTexture(Shader,"cj_sprunk_dirty");