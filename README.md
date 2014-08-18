util
====
It is a lua library write by lua, used for array and string, based on https://raw.githubusercontent.com/chunpu/Shim/master/shim.lua

bugfix some bugs and add some new methods

usage:

local util = require 'util'
print "test isArray!"
print("{1,2,3} is Array: " ..tostring(util.isArray({1,2,3})))
print("{['a']=1} is Array: " .. tostring(util.isArray({['a']=1})))
print("SSS is Array: " ..  tostring(util.isArray("SSS")))
print("#########################")
print("test each")
print("test {2,1,3}")
util.each({2,1,3},function(x,i)
  print(i,x)
end)
print("test {['a']=1,['b']=2,['c']=3,4}")
util.each({['a']=1,['b']=2,['c']=3,4},function(v,k)
    print(k,v)
end)
print("test abcdefg")
util.each("abcdefg",function(x)
   print(x)
end)
print("#########################")
print("test _each")
print("test {2,0,3}")
util._each({2,0,3},function(x,i)
  print(i,x)
  return x == 0
end)
print("test {['a']=1,['b']=0,['c']=3,4}")
util._each({['a']=1,['b']=0,['c']=3,4},function(v,k)
    print(k,v)
    return v == 0
end)

print("test abcdefg")
util._each("abcdefg",function(x)
   print(x)
end)
print("#########################")
print("test every {1,2,3,4} all above 1")
print(util.every({1,2,3,4},function(x)
   return x>0
end))
print("test every {1,2,3,4} all above 3")
print(util.every({1,2,3,4},function(x)
   return x > 3
end))

print("#########################")
print("test some {1,2,3,4} all above 3")
print(util.some({1,2,3,4},function(x)
   return x>3
end))
print("test some {1,2,3,4} all above 5")
print(util.some({1,2,3,4},function(x)
   return x>5
end))
print("test some {['a']=1,['b']=10} all above 5")
print(util.some({['a']=1,['b']=10},function(x)
   return x>5
end))

print("#########################")
print("test some {['a']=1,['b']=10} map")
tb=util.map({['a']=1,['b']=10},function(x,k)
     return x * 5
end)
for k,v in pairs(tb) do
   print(k,v)
end

print("#########################")
print("test isEqual")
print(util.isEqual(2,2))
print(util.isEqual({2},{2}))
print(util.isEqual({2,['a']=1},{2,['a']=1}))

print("#########################")
print("test has")
print(util.has("str","st"))
print(util.has({1,2},{1}))

print("#########################")
print("test sub")
print(util.sub("stttttt",1,3))
for k,v in ipairs(util.sub({1,2,3,4,5},2)) do
   print(k,v)
end
print("sub number to number")
for k,v in ipairs(util.sub({1,2,3,4,5},2,2)) do
   print(k,v)
end

print("#########################")
print("test Trim")
print(util.trim("  str  ","left"))
print(util.trim("  str  ","right"))
print("#########################")
print("test flatten")
local tb = util.flatten({1,2,3,{['a']=1,4},['b']=2,{{1,2,{['c']=11}}}})
for k,v in pairs(tb) do
   print(k,v)
end
print("#########################")
print("test push")
local tb = util.push({1,2,3},{4,5})
for k,v in pairs(tb) do
   print(k,v)
end
print("#########################")
print("test pop")
tb={1,2,4}
print(util.pop(tb))
for k,v in pairs(tb) do
   print(k,v)
end

print("#########################")
print("test uniq")
tb={1,2,4,2,3,4,5}
tb = util.uniq(tb)
for k,v in pairs(tb) do
   print(k,v)
end

print("#########################")
print("test union")
tb={{['a']=1,23},24,54}

for k,v in pairs(util.union(tb)) do
   print(k,v)
end

print("#########################")
print("test extended")
for k,v in pairs(util.extend(tb,1,2,3,34)) do
    print(k,v)
end

print("#########################")
print("test grep")
tb={{['a']=1,23},24,54}
for k,v in pairs(util.grep(tb,function(x) return type(x) == "number" end)) do
     print(k,v)
end

print("#########################")
print("test string")
tb = util.split("_launchservicesd:*:239:239:_launchservicesd:/var/empty:/usr/bin/false",":")
for _,v in ipairs(tb) do
   print(v)
end


print("#########################")
print("test difference")
for k,v in pairs(util.difference({1,2,3,4,5,['a']=1},{1,2,['a']=1})) do
   print(k,v)
end
print("#########################")
print("test reduce")
tb={1,2,3,4,5}
print(util.reduce(tb,function(prev,v) return prev * v end,1))
print("#########################")
print("test only")
local t = util.only({1,2,3,4,5},"1 2 3")
for k,v in pairs(t) do
    print(k,v)
end

print("#########################")
print("test invoke")
local t = util.invoke({1,2,3,4,5},function(x) return x * 5 end)
for k,v in pairs(t) do
	print(k,v)
end


print("#########################")
print("test Equal")
util.assertEqual({1,2,3},{1,2,3,4,['a']=1},5)
