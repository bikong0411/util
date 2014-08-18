#!/usr/bin/env lua
local util = {}
function util.isArray(t)
   if type(t) == "table" then
       local i = 1
       for _ in pairs(t) do
           if t[i] == nil then
               return false
           end
           i = i + 1
       end
       return true
   end
   return false
end

function util.each(t,func) 
    if type(t) == "table" then
       if util.isArray(t) then
         for index,value in ipairs(t) do
           func(value,index,t)
         end
       else
         for k,v in pairs(t) do
           func(v,k,t)  
         end
       end
    elseif type(t) == "string" then
      for i=1,#t  do
         func(t:sub(i,i),i,t)
      end
    end
end

function util._each(t,func)
    if type(t) == "table" then
       if util.isArray(t) then
         for index,value in ipairs(t) do
           if func(value,index,t) == false then
               break
           end
         end
       else
         for k,v in pairs(t) do
           if func(v,k,t) == false then
             break
           end
         end
       end
    elseif type(t) == "string" then
      for i=1,#t  do
        if func(t:sub(i,i),i,t) == false then
           break
        end
      end
    end
    return t
end

function util.every(t, func) 
  local flag = true
   util._each(t,function (v,k,arr) 
       if not func(v,k,arr) then
          flag = false
          return flag
       end
     end)
     return flag
end

function util.some(t, func)
  local flag = false
   util.each(t,function(...) 
       if func(...) then
          flag = true
          return flag
       end
   end)
   return flag
end

function util.map(t,func) 
   local ret = {}
   util.each(t, function(v,k,t) 
       ret[k] = func(v,k,t)
   end)
   return ret
end

function util.isEqual(a,b) 
   if a == b then return true end
   if type(a) == "table" and type(b) == "table" then
       for k,v in pairs(a) do
           if not util.isEqual(v,b[k]) then
               return false
           end
       end
       for k,v in pairs(b) do
           if not util.isEqual(v,a[k]) then
               return false
           end
       end
       return true
   else
      return a==b
   end
end

function util.has(list, item, key) 
    local tp = type(list)
    if tp == "string" then
       return list:find(item) ~= nil
    elseif tp == 'table' then
       for k,v in pairs(list) do
           if type(key) ~= "string" then
             if v == item then
                 return true
             end
           else
             if v == item and k == key then
                 return true
             end
           end
       end
       return false
    end
end

function util.sub(s,i,j) 
   j = j or #s
   if type(s) == "string" then
      return s:sub(i,j)
   elseif type(s) == "table" then
      local ret = {}
      for I=1,j do
        ret[I] = s[I+i]
      end
      return ret
   end
end

function util.ltrim(s) 
  return util.trim(s,"left")
end

function util.rtrim(s)
  return util.trim(s,"right")
end

function util.trim(s,where) 
   if type(s) ~= "string" then
      return s
   end
   local i = 1
   local j = #s
   if where == "left" then
      c, i = util.indexOf(s,"%s+")
      if type(i) == "number" then
         i = i + 1
      end
   elseif where == "right" then
      j = util.lastIndexOf(s,"%s")
      if type(i) == "number" then
        j = j-1
      end
   end
   return s:sub(i,j)
end

function util.flatten(t)
   local ret = {}
   util.each(t, function(v,k,arr) 
      if type(v) == "table" then
         local val = util.flatten(v)
         util.each(val,function(x) 
            if type(x) ~= "table" then
               table.insert(ret,x)
            end
         end)
      else
         table.insert(ret,v)
      end
   end)
   return ret
end

function util.push(t,...) 
   util.each({...},function(v) 
       table.insert(t,v)
   end)
   return t
end

function util.pop(t)
  local i = #t  
  local v = t[i]
  table.remove(t,i)
  return v
end

function util.unshift(t,v)
  table.insert(t,1,v)
  return t
end

function util.shift(t)
   local v = t[1]
   table.remove(t,1)
   return v
end

function util.uniq(t) 
   local hash = {}
   local ret = {}
   util.each(t, function(v) 
       if hash[v] == nil then
          table.insert(ret,v)
          hash[v]=1
       end
   end)
   return ret
end

function util.union(...) 
   return util.uniq(util.flatten({...}))
end

function util.extend(t,...) 
   local ret = {}
   util.each({...}, function(v,k) 
       if type(k) == "number" then
         table.insert(t,v)
       else 
         t[k] = v
       end
   end)
   return t
end

function util.sort(t,fn)
   table.sort(t,fn)
   return t
end

function util.grep(t, fn)
   local ret = {}
   util.each(t, function (v) 
       if fn(v) then
          table.insert(ret,v)
       end
   end)
   return ret
end

function util.indexOf(t,val,from,isPlain)
  if type(t) == "string" then
      return t:find(val,from,isPlain)
  elseif type(t) == "table" then
      for i = from, #t do
         if t[i] == val then
            return i
         end 
      end
  end
  return nil
end

function util.lastIndexOf(t,val,from,isPlain)
  if type(t) == "string" then
      return t:find(val.."$",from,isPlain)
  elseif type(t) == "table" then
      for i=from,1,-1 do
          if t[i] == val then
              return i
          end
      end
  end
  return nil
end

function util.split(str,sep)
   if type(str) ~= "string" then return end
   local i = 1
   local ret = {}
   local len = #str
   while true do
      j,k = str:find(sep,i)
      if j == nil then
          table.insert(ret,str:sub(i))
          break
      end
      table.insert(ret,str:sub(i,j-1))
      i = k+1
   end
   return ret
end

function util.empty(x) 
   if not x then return true end
   local tp = type(x)
   if tp == "string" or tp == "table" then
      return #x == 0 
   end
   if x == 0 then return true end
   return false
end

function util.difference(t,other)
    local ret = {}
    util.each(t, function(v,k) 
       if not util.has(other,v,k) then
          if type(k) == "number" then
             table.insert(ret,v)
          else 
             ret[k] = v
          end
       end
    end)
    return ret
end

function util.without(t,...)
   return util.difference(t,{...})
end

function util.reduce(t,fn,prev) 
   util.each(t, function(v,i,arr) 
      prev = fn(prev,v,i,arr)
   end)
   return prev
end

function util.only(obj,keys) 
    obj = obj or {}
    if type(keys) == 'string' then
      keys = util.split(keys," +")
    end
    return util.reduce(keys, function(ret, key)
      if nil ~= obj[key] or nil ~= obj[tonumber(key)] then
          ret[key] = obj[key] or obj[tonumber(key)]
      end
      return ret
    end, {})
end

function util.invoke(t, fn) 
    return util.map(t, function(x) 
       if type(fn) == 'function' then
           return fn(x)
       end
    end)
end

function util.assertEqual(actual, expect, level)
    level = level or 2
    if not util.isEqual(actual, expect) then
        local msg = 'AssertionError: ' .. util.dump(actual) .. ' == ' .. util.dump(expect)
        error(msg, level)
    end
end

function util.ok(...)
    local arr = {...}
    util.each(arr, function(x)
        if type(x) == 'table' then
            util.assertEqual(x[1], x[2], 5)
        else
            util.assertEqual(x, true, 5)
        end
    end)
end

function call(_, val)
   local ret = {
      wrap = val
   }
   
   setmetatable(ret,{
      __index = function(ret,k)
         if k == 'chain' then
             return function()
                 ret.__chain = true
                 return ret
             end
         elseif k == 'value' then
              return function()
                 return ret.wrap
              end
         elseif type(_[k]) == 'function' then
              return function(ret, ...)
                local v = _[k](ret.wrap,...)
                if ret.__chain then
                    ret.wrap = v
                    return ret
                else
                    return v
                end
              end
         end
      end
   })
   return ret
end

local dump, dumpTable -- fix old luajit

function dumpTable(o, lastIndent)
    if type(lastIndent) ~= 'string' then
        lastIndent = ''
    end
    local indent = '    ' .. lastIndent
    if #indent > 4 * 7 then
        return '[Nested]' -- may be nested, default is 7
    end
    local ret = '{\n'
    local arr = {}
    for k, v in pairs(o) do
        table.insert(arr, indent .. dump(k) .. ': ' .. dump(v, indent))
    end
    ret = ret .. table.concat(arr, ',\n') .. '\n' .. lastIndent .. '}'
    return ret
end

-- TODO multi args
function dump(v, indent)
    local t = type(v)
    if t == 'number' or t == 'boolean' then
        return tostring(v)
    elseif t == 'string' then
        return "'" .. v .. "'"
    elseif t == 'table' then
        if util.isArray(v) then
            return '[' .. table.concat(util.map(v, function(x)
                return dump(x, indent)
            end) , ', ') .. ']'
        else
            return dumpTable(v, indent)
        end
    elseif t == 'nil' then
        return 'null'
    end
    return '[' .. t .. ']'
end

-- TODO other function

util.dump = dump

setmetatable(_, {__call = call})

return util
