﻿/********************************************************************
created:    2017-11-13
author:     lixianmin

Copyright (C) - All Rights Reserved
*********************************************************************/

using System.Collections.Generic;
using UnityEngine.Profiling;


public static class LuaClientProfiler
{
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// begin / end sample
    public static void BeginSample(int id)
    {
        string name;
        _showNames.TryGetValue(id, out name);
        name = name ?? string.Empty;

        Profiler.BeginSample(name);
        ++_sampleDepth;
    }

    public static void BeginSample(int id, string name)
    {
        name = name ?? string.Empty;
        _showNames[id] = name;

        Profiler.BeginSample(name);
        ++_sampleDepth;
    }

    internal static void BeginSample(string name)
    {
        name = name ?? string.Empty;
        Profiler.BeginSample(name);
        ++_sampleDepth;
    }

    public static void EndSample()
    {
        if (_sampleDepth > 0)
        {
            --_sampleDepth;
            Profiler.EndSample();
        }
    }

    private static int _sampleDepth;

    // private const int  _maxSampleDepth = 100;
    private static readonly Dictionary<int, string> _showNames = new Dictionary<int, string>();
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    /// attach / detach lua profiler
	public static void Attach()
	{
        if (_isAttached || GameEntry.Lua == null)
        {
            return;
        }

        _isAttached = true;

        string script = @"
        local profiler = CS.LuaClientProfiler
        local debug = debug

        local _cache = {}
        local _id_generator = 0
        local _ignore_count = 0

        local function lua_profiler_hook (event, line)
            if event == 'call' then
                local func = debug.getinfo (2, 'f').func
                local id = _cache[func]

                if id then
                    profiler.BeginSample (id)
                else
                    local ar = debug.getinfo (2, 'Sn')
                    local method_name = ar.name
                    local linedefined = ar.linedefined

                    if linedefined ~= -1 or (method_name and method_name ~= '__index')  then
                        local short_src = ar.short_src
                        method_name = method_name or '[unknown]'

                        local index = short_src:match ('^.*()[/\\]')
                        local filename  = index and short_src:sub (index + 1) or short_src
                        local show_name = filename .. ':' .. method_name .. ' '.. linedefined

                        local id = _id_generator + 1
                        _id_generator = id
                        _cache[func] = id

                        profiler.BeginSample (id, show_name)
                    else
                        _ignore_count = _ignore_count + 1
                    end
                end
            elseif event == 'return' then
                if _ignore_count == 0 then
                    profiler.EndSample ()
                else
                    _ignore_count = _ignore_count - 1
                end
            end
        end

        debug.sethook (lua_profiler_hook, 'cr', 0)
        ";

        GameEntry.Lua.Env.DoString (script);
	}

	public static void Detach()
	{
        if (!_isAttached || GameEntry.Lua == null)
        {
            return;
        }

        _isAttached = false;
        var script = "debug.sethook (nil)";
        GameEntry.Lua.Env.DoString (script);
	}

    public static bool IsAttached => _isAttached;

    private static bool _isAttached;
}