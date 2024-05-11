local rawget = rawget
local setmetatable = setmetatable
local type = type
local Mathf = Mathf

local Color32 = {}
local _getter = {}
local unity_Color32 = CS.UnityEngine.Color32

Color32.__index = function(t,k)
	local var = rawget(Color32, k)
	if var ~= nil then
		return var
	end
	
	var = rawget(_getter, k)
	if var ~= nil then
		return var(t)
	end
	
	return rawget(unity_Color32, k)
end

Color32.__call = function(t, r, g, b, a)
	return setmetatable({r = r or 0, g = g or 0, b = b or 0, a = a or 1}, Color32)   
end

function Color32.New(r, g, b, a)
	return setmetatable({r = r or 0, g = g or 0, b = b or 0, a = a or 1}, Color32)		
end

function Color32:Set(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a or 1 
end

function Color32:Get()
	return self.r, self.g, self.b, self.a
end

function Color32:Equals(other)
	return self.r == other.r and self.g == other.g and self.b == other.b and self.a == other.a
end

function Color32.Lerp(a, b, t)
	t = Mathf.Clamp01(t)
	return Color32.New(a.r + t * (b.r - a.r), a.g + t * (b.g - a.g), a.b + t * (b.b - a.b), a.a + t * (b.a - a.a))
end

function Color32.LerpUnclamped(a, b, t)
  return Color32.New(a.r + t * (b.r - a.r), a.g + t * (b.g - a.g), a.b + t * (b.b - a.b), a.a + t * (b.a - a.a))
end

function Color32.HSVToRGB(H, S, V, hdr)
  hdr = hdr and false or true  
  local white = Color32.New(1,1,1,1)
  
  if S == 0 then    
    white.r = V
    white.g = V
    white.b = V
    return white
  end
  
  if V == 0 then    
    white.r = 0
    white.g = 0
    white.b = 0
    return white
  end
  
  white.r = 0
  white.g = 0
  white.b = 0;
  local num = S
  local num2 = V
  local f = H * 6;
  local num4 = Mathf.Floor(f)
  local num5 = f - num4
  local num6 = num2 * (1 - num)
  local num7 = num2 * (1 - (num * num5))
  local num8 = num2 * (1 - (num * (1 - num5)))
  local num9 = num4
  
  local flag = num9 + 1
  
  if flag == 0 then
    white.r = num2
    white.g = num6
    white.b = num7
  elseif flag == 1 then
    white.r = num2
    white.g = num8
    white.b = num6
  elseif flag == 2 then
    white.r = num7
    white.g = num2
    white.b = num6
  elseif flag == 3 then
    white.r = num6
    white.g = num2
    white.b = num8
  elseif flag == 4 then
    white.r = num6
    white.g = num7
    white.b = num2
  elseif flag == 5 then
    white.r = num8
    white.g = num6
    white.b = num2
  elseif flag == 6 then
    white.r = num2
    white.g = num6
    white.b = num7
  elseif flag == 7 then
    white.r = num2
    white.g = num8
    white.b = num6
  end
  
  if not hdr then    
    white.r = Mathf.Clamp(white.r, 0, 1)
    white.g = Mathf.Clamp(white.g, 0, 1)
    white.b = Mathf.Clamp(white.b, 0, 1)
  end
    
  return white
end

local function RGBToHSVHelper(offset, dominantColor32, Color32one, Color32two)
  local V = dominantColor32
    
  if V ~= 0 then    
    local num = 0
        
    if Color32one > Color32two then        
      num = Color32two
    else        
      num = Color32one
    end
        
    local num2 = V - num
    local H = 0
    local S = 0
        
    if num2 ~= 0 then        
      S = num2 / V
      H = offset + (Color32one - Color32two) / num2
    else        
      S = 0
      H = offset + (Color32one - Color32two)
    end
        
    H = H / 6  
    if H < 0 then H = H + 1 end                
    return H, S, V
  end
  
  return 0, 0, V  
end

function Color32.RGBToHSV(rgbColor32)
    if rgbColor32.b > rgbColor32.g and rgbColor32.b > rgbColor32.r then    
        return RGBToHSVHelper(4, rgbColor32.b, rgbColor32.r, rgbColor32.g)    
    elseif rgbColor32.g > rgbColor32.r then    
        return RGBToHSVHelper(2, rgbColor32.g, rgbColor32.b, rgbColor32.r)
    else    
        return RGBToHSVHelper(0, rgbColor32.r, rgbColor32.g, rgbColor32.b)
    end
end

function Color32.GrayScale(a)
	return 0.299 * a.r + 0.587 * a.g + 0.114 * a.b
end

Color32.__tostring = function(self)
	return string.format("RGBA(%f,%f,%f,%f)", self.r, self.g, self.b, self.a)
end

Color32.__add = function(a, b)
	return Color32.New(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
end

Color32.__sub = function(a, b)	
	return Color32.New(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
end

Color32.__mul = function(a, b)
	if type(b) == "number" then
		return Color32.New(a.r * b, a.g * b, a.b * b, a.a * b)
	elseif getmetatable(b) == Color32 then
		return Color32.New(a.r * b.r, a.g * b.g, a.b * b.b, a.a * b.a)
	end
end

Color32.__div = function(a, d)
	return Color32.New(a.r / d, a.g / d, a.b / d, a.a / d)
end

Color32.__eq = function(a,b)
	return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
end

_getter.red 	= function() return Color32.New(1,0,0,1) end
_getter.green	= function() return Color32.New(0,1,0,1) end
_getter.blue	= function() return Color32.New(0,0,1,1) end
_getter.white	= function() return Color32.New(1,1,1,1) end
_getter.black	= function() return Color32.New(0,0,0,1) end
_getter.yellow	= function() return Color32.New(1, 0.9215686, 0.01568628, 1) end
_getter.cyan	= function() return Color32.New(0,1,1,1) end
_getter.magenta	= function() return Color32.New(1,0,1,1) end
_getter.gray	= function() return Color32.New(0.5,0.5,0.5,1) end
_getter.clear	= function() return Color32.New(0,0,0,0) end

_getter.gamma = function(c) 
  return Color32.New(Mathf.LinearToGammaSpace(c.r), Mathf.LinearToGammaSpace(c.g), Mathf.LinearToGammaSpace(c.b), c.a)  
end

_getter.linear = function(c)
  return Color32.New(Mathf.GammaToLinearSpace(c.r), Mathf.GammaToLinearSpace(c.g), Mathf.GammaToLinearSpace(c.b), c.a)
end

_getter.maxColor32Component = function(c)    
  return Mathf.Max(Mathf.Max(c.r, c.g), c.b)
end

_getter.grayscale = Color32.GrayScale

Color32.unity_Color32 = CS.UnityEngine.Color32
CS.UnityEngine.Color32 = Color32
setmetatable(Color32, Color32)
return Color32



