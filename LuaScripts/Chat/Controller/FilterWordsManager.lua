--[[
	敏感字过滤系统
    技术方案：trie字典树

    注意：
    1、如果str中包含的敏感词中间有sfilter中的字符就过滤掉 如 “你.大爷” 那敏感词是你大爷 此时就要显示 *.** 
    2、主串检测还没结束 还有检测后面的字符  比如 主串:hello  敏感字: he  hel  那检测到he还不行 还要把hel检测出来
]]

local sfilter = {
    [" "] = true,
    ["。"] = true,
    ["，"] = true,
    ["、"] = true,
    ["；"] = true,
    ["："] = true,
    ["’"] = true,
    ["‘"] = true,
    ["."] = true,
    [","] = true,
    ["/"] = true,
    [";"] = true,
    [":"] = true,
    ["'"] = true,
}

local FilterWordsManager = BaseClass("FilterWordsManager")

function FilterWordsManager:__init()
	self.badWordMap = {}
	self.loadFileNames = {}
    self.cursor = 1  -- 游标 用于检测敏感字
end

 --[[
 0. front_end_badwords_new 开，则走下面对其他语言的支持。不开则不支持
 1. 只要有对应的屏蔽文件，就直接屏蔽
 2. 如果不存在对应的屏蔽文件，默认是英文的
 3. 文件的格式如：bad_words_kr.txt。英文为en, 韩语保持之前的写法是kr, 中文保持之前的写法是cn, 其他的语言保持和国际化中的对应。
    中文.cn，英文.en，韩文.kr。后面的其他语言前端建议命名规则是：法语.fr，德语.de，俄语.ru，泰语.th，日语.ja，葡萄牙语.pt，西班牙语.es，土耳其语.tr，印度尼西亚语.id，意大利语.it，波兰语.pl，荷兰语.nl，阿拉伯语.ar，波斯语.pr
 4. 支持对这种类型en_**的识别，这种类型会被识别为en
 ]]
function FilterWordsManager:getBadWordFileName()
    local lang = ChatInterface.getLanguageName()
	local filename = "";
    if lang ~= "ko" and  ChatInterface.isChina() and ChatInterface.checkIsOpenByKey("front_end_badwords") then 
        filename = "bad_words_cn.txt";
    elseif lang == "ko" and ChatInterface.checkIsOpenByKey("korean_shielding") then 
        filename = "bad_words_kr.txt";
    else --if ChatInterface.checkIsOpenByKey("front_end_badwords_new") then  先屏蔽 测试完再打开
        local thisLang = lang;
        local arr = {"en","fr","de","ru","th","ja","pt","es","tr","id","it","pl","nl","ar","pr"};
        for j = 1,#arr do
            local str = arr[j]
            if string.len(str) <= string.len(lang) then 
                local str1 = string.sub(lang,1,string.len(str)) 
	            -- 如果字符串相等
	            if str1 == str then 
	                thisLang = str
	                break
	            end
            end
        end
        -- 动态加载对应语言的文件
        filename = "bad_words_" .. thisLang .. ".txt";
        local localFile = "local/" .. filename;
        -- 如果不存在，则默认就是en
        if not ChatInterface.isFileExist(localFile) then 
            filename = "bad_words_en.txt"
        end
    end
    ChatPrint("敏感字文件:%s",filename)
   	return filename
end

-- 初始化脏话系统
function FilterWordsManager:initBadWords()
    local filename = self:getBadWordFileName()
    if filename == "" then 
    	return 
    end 
 
    if self.loadFileNames[filename] then 
    	return
    end  

    self.loadFileNames[filename] = true
    local path = ChatInterface.getFullPath("local/" .. filename)

	local content = io.readfile(path)
	if not content then 
		return 
	end 
	local strList = string.split(content,",")
	for i = 1,#strList do 
		self:addFilterWorld(strList[i])
	end 
end


function FilterWordsManager:splitStringToWords(str)
    local words = {}
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do
        words[#words+1] = uchar
    end
    return words
end

--按照树的形式存储
function FilterWordsManager:addFilterWorld(vals)
    local words = self:splitStringToWords(vals)
    local t = self.badWordMap
    local wordNum = #words
    local pos = 1
    while pos <= wordNum do
        if not t[words[pos]] then
            t[words[pos]] = {}
        end
        --敏感词最后一个字打个标记
        if pos == wordNum then 
            t[words[pos]].flag = true
        end 
        t = t[words[pos]]
        pos = pos+1
        
    end
end

function FilterWordsManager:replaceSensitiveWord(words,bIndex,eIndex)
    for i=bIndex, eIndex do
        if sfilter[words[i]] ~= true then
            words[i] = "*"
        end
    end
end

--移动游标
function FilterWordsManager:moveCursor(words)
    self.cursor = self.cursor +1
    if sfilter[words[self.cursor]] then
        self.cursor = self.cursor +1
    end
end

--[[
	过滤敏感词 
	如果str中包含的敏感词中间有sfilter中的字符就过滤掉 如 “你.大爷”
]]
function FilterWordsManager:filterSensitiveWord(str)
    -- ChatPrint("原字符:%s", str)
    local words = self:splitStringToWords(str)
    local existSensitiveWord = false
    local pos = 1
    while pos <= #words do
        self.cursor = pos
        local head = self.badWordMap[words[pos]]
        local getNextWord = function()
            self:moveCursor(words)
            return head[words[self.cursor]]
        end

        while head ~= nil do
            if not head.flag then
                head = getNextWord()
            else
                existSensitiveWord = true
                self:replaceSensitiveWord(words,pos,self.cursor)
                -- 主串检测还没结束 还有检测后面的字符  比如 主串:hello  敏感字: he  hel  那检测到he还不行 还要把hel检测出来
                if table.count(head) > 1 then  
                    head = getNextWord()
                else 
                    pos = self.cursor
                    break
                end 
            end
        end
        pos = pos +1
    end
    local newStr = ""
    if existSensitiveWord then
        for i=1, #words do
            newStr = newStr .. words[i]
        end
    else
        newStr = str
    end
    -- ChatPrint("过滤后:%s", newStr)
    return newStr
end

--[[
	检测是否包含敏感词 
]]
function FilterWordsManager:IsHaveSensitiveWord(str)
    local words = self:splitStringToWords(str)
    local pos = 1
    while pos <= #words do
        self.cursor = pos
        local head = self.badWordMap[words[pos]]
        local getNextWord = function()
            self:moveCursor(words)
            return head[words[self.cursor]]
        end

        while head ~= nil do
            if not head.flag then
                head = getNextWord()
            else
                return true
            end
        end
        pos = pos +1
    end

    return false
end

return FilterWordsManager